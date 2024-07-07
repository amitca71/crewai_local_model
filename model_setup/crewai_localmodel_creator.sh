#!/bin/bash


if [ -z "$1" ]; then
    echo "Error: Model name must be provided (e.g. llama3) full model list is on https://ollama.com/library"
    echo "Usage: $0 <model_name>"
    exit 1
fi
model_name="$1"
custom_model_name="crewai-${1}"
ollama pull $model_name

# Get the base model
ollama pull $model_name
# Function to generate ModelFile content
generate_model_file() {
    local model_name="$1"
    cat <<EOF
# Set parameters
FROM $model_name
PARAMETER temperature 0.8
PARAMETER stop Result


# Sets a custom system message to specify the behavior of
# the chat assistant

# Leaving it blank for now.

SYSTEM """"""
EOF
}
# Usage example: Generate ModelFile for 'llama3'
model_file_content=$(generate_model_file "$model_name")

# Write content to a file named {model_name}ModelFile in the local directory
model_file_name="/tmp/${model_name}ModelFile"
echo "$model_file_content" > "$model_file_name"

echo "ModelFile generated for model '$model_name' as '$model_file_name'."
ollama create $custom_model_name -f $model_file_name
ollama list
