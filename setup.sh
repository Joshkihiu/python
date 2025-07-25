#!/bin/bash
#
# Setup script for the Python To-Do List CLI application.
# This script automates the installation process on macOS and Linux.
#

echo "🚀 Starting setup for the To-Do List CLI app..."

# --- Configuration ---
# The directory where the app will be installed.
INSTALL_DIR="$HOME/.todo_app"
# The name of the Python script to be installed.
SOURCE_SCRIPT="todo.py"
# The desired command name for the app.
COMMAND_NAME="tdl"

# --- Step 1: Check if the source 'todo.py' script exists ---
if [ ! -f "$SOURCE_SCRIPT" ]; then
    echo "❌ Error: The 'todo.py' script was not found in the current directory."
    echo "Please make sure this setup script is in the same folder as 'todo.py' and run it again."
    exit 1
fi

# --- Step 2: Create the installation directory ---
echo "🔧 Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# --- Step 3: Prepare and copy the script ---
echo "⚙️  Copying and preparing the main script..."
# Create a temporary copy to add the shebang line, ensuring the original is untouched.
TEMP_SCRIPT=$(mktemp)
echo "#!/usr/bin/env python3" > "$TEMP_SCRIPT"
cat "$SOURCE_SCRIPT" >> "$TEMP_SCRIPT"

# Copy the prepared script to the installation directory and make it executable.
cp "$TEMP_SCRIPT" "$INSTALL_DIR/$SOURCE_SCRIPT"
chmod +x "$INSTALL_DIR/$SOURCE_SCRIPT"
rm "$TEMP_SCRIPT" # Clean up temporary file

# --- Step 4: Create a launcher script for the 'tdl' command ---
# This script will simply execute the Python to-do list application.
echo "🔗 Creating a launcher for the '$COMMAND_NAME' command..."
LAUNCHER_PATH="$INSTALL_DIR/$COMMAND_NAME"
echo "#!/bin/bash" > "$LAUNCHER_PATH"
echo "# This script launches the To-Do List application." >> "$LAUNCHER_PATH"
echo "\"$INSTALL_DIR/$SOURCE_SCRIPT\"" >> "$LAUNCHER_PATH"
chmod +x "$LAUNCHER_PATH"

# --- Step 5: Add the installation directory to the user's PATH ---
# This makes the 'tdl' command available system-wide for the user.
SHELL_CONFIG_FILE=""
DETECTED_SHELL=$(basename "$SHELL")

if [ "$DETECTED_SHELL" = "zsh" ]; then
    SHELL_CONFIG_FILE="$HOME/.zshrc"
elif [ "$DETECTED_SHELL" = "bash" ]; then
    SHELL_CONFIG_FILE="$HOME/.bashrc"
else
    echo "⚠️ Could not automatically detect your shell configuration file."
    echo "Please add the following line to your shell's startup file (e.g., .profile, .bash_profile):"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\""
    exit 1
fi

echo "📝 Adding configuration to your shell file ($SHELL_CONFIG_FILE)..."
# Check if the PATH is already configured to avoid duplicate entries.
if grep -q "export PATH=.*$INSTALL_DIR" "$SHELL_CONFIG_FILE"; then
    echo "✅ Your PATH is already correctly configured."
else
    # Append the configuration to the shell file.
    echo "" >> "$SHELL_CONFIG_FILE"
    echo "# Add To-Do List (tdl) application to PATH" >> "$SHELL_CONFIG_FILE"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_CONFIG_FILE"
    echo "✅ Configuration added successfully!"
fi

# --- Final Instructions ---
echo ""
echo "🎉 Setup is complete!"
echo "❗️ IMPORTANT: You must restart your terminal for the changes to take effect."
echo "   Alternatively, you can run 'source $SHELL_CONFIG_FILE' in your current session."
echo ""
echo "After that, you can run the app from anywhere by just typing: tdl"
