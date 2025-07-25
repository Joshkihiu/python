# To-Do List CLI 📝

A simple, fast, and efficient command-line to-do list application built with Python. This tool helps you manage multiple to-do lists directly from your terminal, keeping you organized without ever leaving the keyboard.

Each list is saved as a separate `.json` file in the same directory, making your data portable and easy to access.

## ✨ Features

* **Multiple List Management**: Create, open, view, and delete multiple to-do lists for different projects or contexts (e.g., "Work," "Shopping," "Personal").
* **Task Tracking**: Add tasks to any list and mark them as complete.
* **Task Prioritization**: Flag important tasks as "priorities" to make them stand out.
* **Notes & Reminders**: Add detailed notes and a simple reminder to each list.
* **Automatic Saving**: All changes are saved automatically.
* **Cross-Platform**: Works on macOS, Linux, and Windows.
* **Easy Installation**: Comes with automated setup scripts to create a global `tdl` command.

## 🚀 Installation

To get started, first save `todo.py` and the appropriate setup script for your operating system in the same folder.

### For macOS & Linux

1.  Open your terminal.
2.  Navigate to the folder where you saved the files.
3.  Make the setup script executable:
    ```bash
    chmod +x setup.sh
    ```
4.  Run the script:
    ```bash
    ./setup.sh
    ```
5.  **Restart your terminal.** The `tdl` command will now be available.

### For Windows

1.  Open Command Prompt or PowerShell.
2.  Navigate to the folder where you saved the files.
3.  Run the batch script:
    ```batch
    setup.bat
    ```
4.  **Restart your terminal.** The `tdl` command will now be available.

## 💻 How to Use

Once installed, you can run the application from anywhere in your terminal by simply typing:

```bash
tdl
