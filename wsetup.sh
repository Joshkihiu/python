@echo off
::
:: Setup script for the Python To-Do List CLI application on Windows.
:: This script automates the installation process by creating necessary files
:: and adding the application to the user's PATH.
::

echo.
echo 🚀 Starting setup for the To-Do List CLI app...
echo.

:: --- Configuration ---
set "INSTALL_DIR=%USERPROFILE%\.todo_app"
set "SOURCE_SCRIPT=todo.py"
set "COMMAND_NAME=tdl.bat"

:: --- Step 1: Check if the source 'todo.py' script exists ---
if not exist "%SOURCE_SCRIPT%" (
    echo ❌ Error: The 'todo.py' script was not found in the current directory.
    echo Please make sure this setup script is in the same folder as 'todo.py'.
    echo.
    pause
    exit /b 1
)

:: --- Step 2: Create installation directory and copy files ---
echo 🔧 Creating directory and copying files to %INSTALL_DIR%...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
copy "%SOURCE_SCRIPT%" "%INSTALL_DIR%\" > nul
echo    ...Done.

:: --- Step 3: Create the launcher batch file for the 'tdl' command ---
echo ⚙️  Creating the 'tdl' command...
(
    echo @echo off
    echo :: This batch file launches the Python To-Do list script.
    echo python "%INSTALL_DIR%\%SOURCE_SCRIPT%"
) > "%INSTALL_DIR%\%COMMAND_NAME%"
echo    ...Done.

:: --- Step 4: Add the installation directory to the User PATH ---
echo 🔗 Adding installation directory to your system's PATH...

:: Use 'reg query' to get the current PATH and 'find' to check if our directory is already in it.
reg query HKCU\Environment /v Path | find /I "%INSTALL_DIR%" > nul
if %errorlevel%==0 (
    echo ✅ Your PATH already includes the script directory. No changes needed.
) else (
    echo    Updating PATH. This may take a moment...
    :: Use 'setx' to permanently append the directory to the user's PATH.
    :: 'setx' is a reliable way to make persistent changes to environment variables.
    for /f "tokens=2,*" %%a in ('reg query HKCU\Environment /v Path') do set "CURRENT_PATH=%%b"
    setx PATH "%%CURRENT_PATH%%;%INSTALL_DIR%" > nul
    echo    ...PATH updated successfully!
)

:: --- Final Instructions ---
echo.
echo 🎉 Setup is complete!
echo =================================================================
echo.
echo ❗️ IMPORTANT: You must close and reopen any Command Prompt or
echo    PowerShell windows for the changes to take effect.
echo.
echo    After restarting, you can run the app from anywhere by typing:
echo    tdl
echo.
echo =================================================================
echo.
pause
