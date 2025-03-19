import os
import shutil
import xml.etree.ElementTree as ET

CONFIG_FILE = "/steamapps/serverconfig.xml"

def update_xml():
    if not os.path.exists(CONFIG_FILE):
        print(f"Error: Config file {CONFIG_FILE} not found!")
        exit(1)

    print(f"Updating {CONFIG_FILE} with environment variables...")

    try:
        # Backup the original file
        backup_file = CONFIG_FILE + ".bak"
        shutil.copy(CONFIG_FILE, backup_file)
        print(f"Backup created: {backup_file}")

        tree = ET.parse(CONFIG_FILE)
        root = tree.getroot()
        updated = False

        # Normalize env vars to lowercase
        env_vars = {key.lower(): value for key, value in os.environ.items()}

        for element in root:
            name_attr = element.get("name")
            if name_attr and name_attr.lower() in env_vars:
                element.set("value", env_vars[name_attr.lower()])
                print(f"Updated {name_attr} -> {env_vars[name_attr.lower()]}")
                updated = True

        if updated:
            tree.write(CONFIG_FILE)
            print("Config file updated successfully.")
        else:
            print("No matching config keys found in serverconfig.xml.")

    except ET.ParseError as e:
        print(f"XML parsing error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    update_xml()
