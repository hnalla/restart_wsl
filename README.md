# WSL Restart Utility

A simple utility to restart the Windows Subsystem for Linux (WSL) service without requiring a full system restart.

## Why This Tool Helps You

If you use WSL regularly, you've likely encountered situations where it stops working properly. Instead of restarting your entire computer (losing your work and waiting through a full reboot), this utility lets you:
- Fix WSL issues in seconds
- Avoid a full system restart

## Quick Start Guide

### Download

1. **[Click here to download the latest release](https://github.com/hnalla/restart_wsl/releases/latest/download/wsl-restart-utility.zip)**
2. Extract the ZIP file to any location on your computer
3. No installation needed - the tool is ready to use!

### Usage

1. When WSL isn't working properly, simply **double-click** the `run_restart.bat` file
2. Enter your local administrator password when prompted (this is required to restart the service)
3. Wait a few seconds while the tool restarts the WSL service
4. When you see "WSL service restarted successfully", press Enter to close
5. Your WSL should now work properly again!

## Advanced Information

### What's Included
- `run_restart.bat`: The main file you'll run when needed
- `restart_vm_computer.ps1`: A PowerShell script that handles the actual service restart

### How It Works

The utility safely restarts the Windows `vmcompute` service, which is the underlying service that powers WSL. It:
1. Automatically requests administrator rights (required to restart services)
2. Properly stops the service if running
3. Starts it again with proper error handling
4. Creates logs if any issues occur (in the `logs` folder)

### System Requirements

- Windows 10 or 11 with WSL installed
- Administrator access on your computer

### Troubleshooting

If WSL still doesn't work after running the utility:
1. Good luck! It fixes my issue ( :

## License

MIT License - See [LICENSE](LICENSE) file for details.