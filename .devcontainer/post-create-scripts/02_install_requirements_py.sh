#!/bin/bash
set -e  # Exit on error

REQUIREMENTS_FILE="/workspace/requirements.txt"

echo "Checking for requirements.txt file..."

# Check if requirements.txt exists in the workspace directory
if [ -f "$REQUIREMENTS_FILE" ]; then
    echo "requirements.txt found. Installing Python dependencies..."
    pip install --no-cache-dir -r "$REQUIREMENTS_FILE"
else
    echo "No requirements.txt file found. Skipping Python dependency installation."
fi
