import json
import os
from datetime import datetime
import glob

def get_list_name():
    """Asks the user for a list name and returns it."""
    return input("Enter the list name (e.g., 'Work', 'Shopping'): ")

def get_filename(list_name):
    """Generates a standardized filename from a list name."""
    # Cleans the name to make it a valid filename and adds a prefix.
    clean_name = "".join(c for c in list_name if c.isalnum() or c in (' ', '_')).rstrip()
    return f"list_{clean_name.replace(' ', '_')}.json"

def load_data(list_name):
    """Loads a specific to-do list from its JSON file."""
    filename = get_filename(list_name)
    if os.path.exists(filename):
        with open(filename, 'r') as file:
            return json.load(file)
    else:
        # Create a new list structure if the file doesn't exist
        print(f"Creating new list: '{list_name}'")
        today = datetime.now()
        return {
            "list_name": list_name,
            "month": today.strftime("%B"),
            "date": today.strftime("%d, %Y"),
            "tasks": [],
            "priorities": [],
            "notes": "",
            "reminder": ""
        }

def save_data(data):
    """Saves the to-do list to its JSON file."""
    filename = get_filename(data["list_name"])
    with open(filename, 'w') as file:
        json.dump(data, file, indent=4)
    print("\n✅ List saved successfully!")

def add_task(data):
    """Adds a new task to the list."""
    description = input("Enter the task description: ")
    is_priority = input("Is this a priority task? (yes/no): ").lower()

    task = {"description": description, "status": "pending"}
    data["tasks"].append(task)

    if is_priority == 'yes':
        data["priorities"].append(description)
    save_data(data)

def mark_complete(data):
    """Marks a task as complete."""
    view_list(data, show_status=True)
    if not data["tasks"]:
        return

    try:
        task_num = int(input("Enter the task number to mark as complete: "))
        if 1 <= task_num <= len(data["tasks"]):
            data["tasks"][task_num - 1]["status"] = "complete"
            save_data(data)
        else:
            print("❌ Invalid task number.")
    except ValueError:
        print("❌ Please enter a valid number.")

def add_notes_reminder(data):
    """Adds or updates notes and reminders."""
    print(f"\nCurrent Notes: {data.get('notes', '')}")
    data['notes'] = input("Enter your notes (press Enter to keep current): ") or data.get('notes', '')

    print(f"\nCurrent Reminder: {data.get('reminder', '')}")
    data['reminder'] = input("Enter your reminder (press Enter to keep current): ") or data.get('reminder', '')
    save_data(data)

def view_list(data, show_status=False):
    """Displays the entire to-do list."""
    print("\n" + "="*40)
    print(f"🗓️  LIST: {data['list_name']} (Created: {data['month']} {data['date']})")
    print("="*40)
    
    print("\n📋 TO DO:")
    if not data["tasks"]:
        print("  No tasks yet.")
    else:
        for i, task in enumerate(data["tasks"]):
            status_icon = "✅" if task.get('status') == 'complete' else "🔲"
            if show_status:
                print(f"  {i+1}. {status_icon} {task['description']}")
            else:
                print(f"  {status_icon} {task['description']}")
    
    print("\n⭐ PRIORITIES:")
    if not data["priorities"]:
        print("  No priority tasks.")
    else:
        for item in data["priorities"]:
            print(f"  - {item}")
            
    print("\n📝 NOTES:")
    print(f"  {data.get('notes') or 'No notes added.'}")

    print("\n🔔 REMINDER:")
    print(f"  {data.get('reminder') or 'No reminder set.'}")
    print("\n" + "="*40)

def list_manager():
    """The main menu for managing multiple lists."""
    while True:
        print("\n--- To-Do List Manager ---")
        print("1. Open/Create a List")
        print("2. View All Lists")
        print("3. Delete a List")
        print("4. Exit")
        choice = input("Choose an option: ")

        if choice == '1':
            list_name = get_list_name()
            if list_name:
                list_menu(list_name)
        elif choice == '2':
            view_all_lists()
        elif choice == '3':
            delete_list()
        elif choice == '4':
            print("Goodbye! 👋")
            break
        else:
            print("❌ Invalid choice. Please try again.")

def view_all_lists():
    """Finds and displays all saved to-do lists."""
    print("\n--- All Saved Lists ---")
    # Find all files starting with 'list_' and ending with '.json'
    saved_lists = glob.glob("list_*.json")
    if not saved_lists:
        print("No lists found.")
        return

    for f in saved_lists:
        # Extract the name from the filename
        list_name = f.replace('list_', '').replace('.json', '').replace('_', ' ')
        print(f"  - {list_name}")

def delete_list():
    """Deletes a specified to-do list file."""
    view_all_lists()
    list_name = get_list_name()
    filename = get_filename(list_name)

    if os.path.exists(filename):
        confirm = input(f"Are you sure you want to permanently delete the list '{list_name}'? (yes/no): ").lower()
        if confirm == 'yes':
            os.remove(filename)
            print(f"✅ List '{list_name}' has been deleted.")
        else:
            print("Deletion cancelled.")
    else:
        print("❌ List not found.")

def list_menu(list_name):
    """The menu for interacting with a specific to-do list."""
    todo_data = load_data(list_name)
    
    while True:
        print(f"\n--- Menu for '{list_name}' ---")
        print("1. View List")
        print("2. Add Task")
        print("3. Mark Task as Complete")
        print("4. Add/Edit Notes & Reminder")
        print("5. Back to Main Menu")

        choice = input("Choose an option: ")

        if choice == '1':
            view_list(todo_data)
        elif choice == '2':
            add_task(todo_data)
        elif choice == '3':
            mark_complete(todo_data)
        elif choice == '4':
            add_notes_reminder(todo_data)
        elif choice == '5':
            break # Exit this loop to go back to the list manager
        else:
            print("❌ Invalid choice. Please try again.")

if __name__ == "__main__":
    list_manager()
