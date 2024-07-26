@echo off
setlocal

:: Set the color of the text
color 0E

:: Display ASCII art
echo "           _____  _  __  ______    _ _    _____ _               _                       "
echo "          |  __ \| |/ / |  ____|  (_) |  / ____| |             | |                      "
echo "          | |__) | ' /  | |__ __ _ _| | | |    | |__   ___  ___| | _____ _ __           "
echo "          |  ___/|  <   |  __/ _` | | | | |    | '_ \ / _ \/ __| |/ / _ \ '__|          "
echo "          | |    | . \ _| | | (_| | | | | |____| | | |  __/ (__|   <  __/ |             "
echo "          |_|    |_|\_(_)_|  \__,_|_|_|  \_____|_| |_|\___|\___|_|\_\___|_|             "
echo.
echo ------------------------------------------------------------------------------------------
:: Inform the user about the action and provide the link
echo This will find and upload your firmware.bin file to pk.fail's vulnerability checker.
echo To learn more please visit: https://pk.fail/
echo Press any key to continue or click the X to Quit...
pause >nul

:: Set the path to the folder where firmware.bin is located
set "FIRMWARE_PATH=%windir%\Firmware"

:: Initialize variable to store file path
set "FILE_PATH="

:: Search for firmware.bin in all subfolders
for /r "%FIRMWARE_PATH%" %%f in (firmware.bin) do (
    set "FILE_PATH=%%f"
)

:: Check if FILE_PATH was set
if defined FILE_PATH (
    echo Found firmware.bin at: %FILE_PATH%
) else (
    echo firmware.bin not found.
    exit /b 1
)

:: Define temporary file for curl response
set "RESPONSE_FILE=%TEMP%\curl_response.txt"

:: Execute curl to upload the file and capture the output
curl -X POST https://pk.fail/ -F "file=@%FILE_PATH%" > "%RESPONSE_FILE%"

:: Check if the curl command succeeded
if %ERRORLEVEL% neq 0 (
    echo Upload failed.
    exit /b %ERRORLEVEL%
)

:: Read the response file and pass it to PowerShell for formatting
powershell -Command ^
    "$response = Get-Content -Path '%RESPONSE_FILE%' -Raw;" ^
    "$formattedResponse = ConvertFrom-Json -InputObject $response;" ^
    "$formattedResponse | ConvertTo-Json -Depth 10 | Out-String | Write-Output"

:: Clean up temporary file
del "%RESPONSE_FILE%"

:: Indicate success
echo Upload succeeded.

pause

endlocal
