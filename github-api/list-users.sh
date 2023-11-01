#!/bin/bash


#####################
# Author: Sarat
# Version: v1
# Date: 1st-Nov
# Description: This script lists users with read access to a GitHub repository of a specified organization. 
# It uses the GitHub API and requires a GitHub username and personal access token for authentication.
#########################

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Helper function to check and handle command-line arguments
function check_arguments {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <organization> <repository>"
        exit 1
    fi
}

# Main script
check_arguments "$@"
REPO_OWNER=$1
REPO_NAME=$2

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
