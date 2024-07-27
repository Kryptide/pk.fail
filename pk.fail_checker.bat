@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape codes for Windows 10 and 11
for /f "delims=" %%i in ('"echo("') do set "ESC=%%i"
set "COLOR_GREEN=%ESC%[32m"
set "COLOR_RESET=%ESC%[0m"

:: Set the color of the text
color 0E

:: Display ASCII art
echo "           _____  _  __  ______    _ _    _____ _               _                       "
echo "          |  __ \| |/ / |  ____|  (_) |  / ____| |             | |                      "
echo "          | |__) | ' /  | |__ __ _ _| | | |    | |__   ___  ___| | _____ _ __           "
echo "          |  ___/|  <   |  __/ _` | | | | |    | '_ \ / _ \/ __| |/ / _ \ '__|          "
echo "          | |    | . \ _| | | (_| | | | | |____| | | |  __/ (__|   <  __/ |             "
echo "          |_|    |_|\_(_)_|  \__,_|_|_|  \_____|_| |_|\___|\___|_|\_\___|_| v1.3        "
echo.                                                                            
echo ------------------------------------------------------------------------------------------
:: Inform the user about the action and provide the link
echo This will find and upload your firmware to Binarly's pk.fail vulnerability checker.
echo To learn more please visit: https://pk.fail/
echo Press any key to continue or click the X to Quit...
pause >nul

:: Set the path to the folder where firmware files are located
set "FIRMWARE_PATH=%windir%\Firmware"

:: Initialize variables to store folder path, file path, and modification time
set "NEWEST_FOLDER="
set "NEWEST_FILE="
set "NEWEST_FILE_TIME="

:: Search for the newest folder in the directory
for /f "delims=" %%d in ('dir /b /ad /o-d "%FIRMWARE_PATH%"') do (
    set "NEWEST_FOLDER=%%d"
    goto :folder_found
)

:folder_found
:: Check if NEWEST_FOLDER was set
if defined NEWEST_FOLDER (
    set "NEWEST_FOLDER_PATH=%FIRMWARE_PATH%\!NEWEST_FOLDER!"
    echo Found newest folder at: !NEWEST_FOLDER_PATH!
) else (
    echo No folders found in the specified directory.
    pause
)

:: Search for the newest file in the newest folder
for /f "delims=" %%f in ('dir /b /a-d /o-d "!NEWEST_FOLDER_PATH!\*"') do (
    set "NEWEST_FILE=%%f"
    goto :file_found
)

:file_found
:: Check if NEWEST_FILE was set
if defined NEWEST_FILE (
    set "FILE_PATH=!NEWEST_FOLDER_PATH!\!NEWEST_FILE!"
    echo Found newest file at: !FILE_PATH!
) else (
    echo No Firmware File Was Found.
	echo Please open Windows Update, go to Advanced Options, then Optional Updates.
	echo Make sure to install all updates, reboot, and run the script again.
    echo Press any key to exit...
    pause >nul
)

:: Define temporary file for curl response
set "RESPONSE_FILE=%TEMP%\curl_response.txt"

:: Execute curl to upload the file and capture the output
curl -X POST https://pk.fail/ -F "file=@!FILE_PATH!" > "!RESPONSE_FILE!"

:: Check if the curl command succeeded
if %ERRORLEVEL% neq 0 (
    echo Upload failed.
    del "!RESPONSE_FILE!"
    exit /b %ERRORLEVEL%
)

:: Read the response file and extract the status using PowerShell
for /f "delims=" %%i in ('powershell -Command "Get-Content -Path \"!RESPONSE_FILE!\" | ConvertFrom-Json | Select-Object -ExpandProperty status"') do (
    set "STATUS=%%i"
)

:: Debug: Print the status
echo Status found: !STATUS!
echo.

if "!STATUS!" == "" (
    echo No status found in the response.
) else (
    if "!STATUS!" == "vulnerable" (
        powershell -Command "Write-Host 'You're Affected!' -ForegroundColor Red"
    ) else if "!STATUS!" == "not-vulnerable" (
        powershell -Command "Write-Host 'You''re Safe and Secure' -ForegroundColor Green"
    ) else if "!STATUS!" == "error" (
        powershell -Command "Write-Host 'There is something wrong with your Firmware file.' -ForegroundColor Red"
    )
)

:: Ask the user if they want to view the raw output
set /p "USER_CHOICE=Would you like to view the RAW output? (y/n): "
if /i "!USER_CHOICE!" == "y" (
    :: Display the formatted raw output using PowerShell
    echo RAW output:
    powershell -Command "Get-Content -Path \"!RESPONSE_FILE!\" | ConvertFrom-Json | ConvertTo-Json -Depth 10 | Write-Output"
)

:cleanup
:: Clean up temporary file
del "!RESPONSE_FILE!"

:: Indicate success
echo Process completed.
echo To learn more about PK.Fail check Binarly's report

:: Ask the user if they want to view Binarly's vulnerability report
set /p "REPORT_CHOICE=Would you like to view Binarly's vulnerability report? (y/n): "
if /i "!REPORT_CHOICE!" == "y" (
    start "" "https://www.binarly.io/advisories/brly-2024-005-usage-of-default-test-keys-leads-to-complete-secure-boot-bypass"
)

:: Press any key to exit
echo Press any key to exit...
pause >nul

endlocal
