# WSL Restart Utility

A simple utility to restart the Windows Subsystem for Linux (WSL) service without requiring a full system restart.

## Why This Exists

WSL occasionally encounters issues that cause it to stop functioning correctly. Typically, this requires restarting your entire laptop to fix the problem - a time-consuming and disruptive solution. This utility provides a quick way to restart only the necessary WSL service (`vmcompute`), saving you time and avoiding interruption to your workflow.

## Installation

1. Download both files (`run_restart.bat` and `restart_vm_computer.ps1`)
2. Place them in the same folder
3. No additional setup required

## Download

You can download the latest version of the utility without cloning the repository:

1. Go to the [Releases page](https://github.com/hnalla/restart_wsl/releases)
2. Download the `wsl-restart-utility.zip` file from the latest release
3. Extract the ZIP file to a location of your choice
4. Follow the usage instructions above

## Usage

Simply double-click the `run_restart.bat` file to run the utility:
- The script will automatically request administrator privileges if needed
- It will restart the WSL service (`vmcompute`)
- You'll see a success message once the service restarts
- Press Enter to close the window

## How It Works

1. The batch file executes the PowerShell script with the necessary permissions
2. The PowerShell script checks for administrator rights and requests elevation if needed
3. The script then safely restarts the `vmcompute` service
4. Error handling ensures any issues are logged and displayed

## Requirements

- Windows 10 or 11 with WSL installed
- Administrator access on your computer

## Troubleshooting

If you encounter any issues, check the error log in the `logs` folder that will be created in the same directory as the scripts.

## License

MIT License - See [LICENSE](LICENSE) file for details.
