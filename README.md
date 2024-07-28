# PK.Fail Checker
This is a batch file that will check if your firmware has the UEFI/Bios vulnerability using Binarly's PK.Fail checker.
The script will find your firmware file automatically and upload it to Binarlys online checker.
The output will give a status of "vulnerable" or  "not-vulnerable".
Depending on which result is given you will see either "Safe and Secure" in green text.
If you are vulnerable, you will see "You're Affected!" in red text.
This has been written in such a way that it's easily read and understood by the user.
There is an option to view the RAW output, which includes all the hashes to your firmware file.
After the script has ran you have the option to view Binarly's full report of the vulnerability on their website.


![Script Results](https://michaelreynolds.tech/wp-content/uploads/2024/07/pkfailchecker.png)

## Troubleshooting:
Windows is trying to protect my PC:

This will always appear no matter what batch file you download and attempt to run. This is simply a security feature built into Windows.
Windows is not stating that the file is malicious, only that it could be.
There is nothing in this script that has any sort of ill intent. Please feel free to review the code as I've commented it the best I can to show what
each and every line and command does.

### Steps:
Select "More Info"

![Script Results](https://michaelreynolds.tech/wp-content/uploads/2024/07/windows_protect_1.png)

Select "Run Anyway"

![Script Results](https://michaelreynolds.tech/wp-content/uploads/2024/07/windows_protect_2.png)

If you have any questions, concerns, or improvements, please feel free to reach out!

