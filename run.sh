#!/bin/bash

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

# Check if config.json exists
if [ ! -f config.json ]; then
    echo "config.json file not found!"
    exit 1
fi

# Loop through the bots in config.json
for bot in $(jq -r 'to_entries[] | "\(.key),\(.value.source),\(.value.branch // \"main\"),\(.value.run)"' config.json); do
  name=$(echo $bot | cut -d',' -f1)
  source=$(echo $bot | cut -d',' -f2)
  branch=$(echo $bot | cut -d',' -f3)
  run=$(echo $bot | cut -d',' -f4)

  # Clone or update repositories
  if [ -d "$name" ]; then
    echo "Directory $name already exists, pulling latest changes..."
    cd $name
    git fetch origin
    git checkout $branch
    git pull origin $branch
  else
    echo "Cloning repository $source on branch $branch into $name..."
    git clone --branch $branch $source $name || { echo "Failed to clone $name"; continue; }
    cd $name
  fi
  
  # Install Python dependencies
  if [ -f "requirements.txt" ]; then
    echo "Installing/updating dependencies for $name..."
    pip install --no-cache-dir -r requirements.txt || { echo "Failed to install dependencies for $name"; cd ..; continue; }
  else
    echo "No requirements.txt found for $name, skipping dependency installation."
  fi

  # Run the bot
  echo "Running $run for $name..."
  python3 $run || { echo "Failed to run $run for $name"; cd ..; continue; }

  cd ..
done
