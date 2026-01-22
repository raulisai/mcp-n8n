@echo off
REM n8n Manager CLI - Global Command Wrapper
REM This script allows you to run 'n8n' from anywhere in CMD

REM Get the directory where this batch file is located
SET "SCRIPT_DIR=%~dp0"

REM Run the Python script from the core folder
python "%SCRIPT_DIR%core\n8n_manager.py" %*
