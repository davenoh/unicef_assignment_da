import os
print("Working directory:", os.getcwd())
# Set your correct working directory
os.chdir('/Users/dnoh/Library/CloudStorage/GoogleDrive-dnohkim00@gmail.com/My Drive/Work/_Job Application/3_Job Market 2025/3_Interviews/UNICEF/Written Assessment/unicef_assessment_submitted/Consultancy-Assessment')
print("Now working in:", os.getcwd())
import stat

# 1. Create folder structure
folders = ["_scripts", "02_data_processed", "03_out", "04_document"]
for folder in folders:
    os.makedirs(folder, exist_ok=True)

# 2. Create placeholder for README.md
readme_path = "README.md"
if not os.path.exists(readme_path):
    with open(readme_path, "w") as f:
        f.write("# Project README\n\nDescribe your Stata project here.\n")

# 3. Create placeholder master.do file
master_do_path = "_scripts/master.do"
if not os.path.exists(master_do_path):
    with open(master_do_path, "w") as f:
        f.write("// master.do - placeholder\n\nclear all\nset more off\n\n// Insert your Stata code here\n")

# 4. Create user_profile
user_profile_content = """#!/bin/bash

# ==== STATA COMMAND ====
# # Set your Stata command here (adjust for your model and install location)
STATA_CMD="/Applications/Stata/StataIC.app/Contents/MacOS/StataIC"
export STATA_CMD

echo "User profile setup completed."
"""

with open("user_profile", "w") as f:
    f.write(user_profile_content)

# Make user_profile executable
os.chmod("user_profile", os.stat("user_profile").st_mode | stat.S_IXUSR)

# 5. Create run_project
run_project_content = """#!/bin/bash


# Navigate to the directory where this script is located
cd "$(dirname "$0")"

# Load environment setup
source ./user_profile

# Run Stata master do-file in batch mode, log output to output folder
echo "Analysis started."

if ! command -v $STATA_CMD &> /dev/null; then
    echo "Error: Stata command '$STATA_CMD' not found. Please check your user_profile."
    exit 1
fi

if [ ! -f ./_scripts/master.do ]; then
    echo "Error: './_scripts/master.do' file not found."
    exit 1
fi

$STATA_CMD -b do _scripts/master.do PROJECT_DIR "$PROJECT_DIR"

echo "Analysis completed. Check the '03_out' folder."
"""

with open("run_project", "w") as f:
    f.write(run_project_content)

# Make run_project executable
os.chmod("run_project", os.stat("run_project").st_mode | stat.S_IXUSR)

print("Project setup complete.")
