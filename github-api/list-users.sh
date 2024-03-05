# This line is known as the shebang. It specifies the interpreter to be used (in this case, Bash) to execute the script.
#!/bin/bash

# Description: GitHub API Integration (Script will list organization collaborators with read access)

# This block of code checks whether the required command-line arguments are provided. If the number of arguments is not 2, it displays a message asking the user to provide the required arguments and exits the script with an exit status of 1.
if [ $# -ne 2 ]; then
    echo "Please provide the required arguments: <REPO_OWNER> <REPO_NAME>"
    exit 1
fi

# GitHub API URL/ This line sets a variable API_URL to the GitHub API endpoint.
API_URL="https://api.github.com"

# GitHub username and personal access token / These lines assign the values of the environment variables username and token to the variables USERNAME and TOKEN respectively.
USERNAME=$username
TOKEN=$token

# User and Repository information / These lines store the first and second command-line arguments into the variables REPO_OWNER and REPO_NAME respectively.
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API / This defines a function named github_api_get which takes an endpoint as an argument, constructs the full URL, and sends a GET request to the GitHub API with authentication using the curl command.
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository / This defines a function named list_users_with_read_access which constructs the API endpoint for listing collaborators with read access to the repository, fetches the list of collaborators using the github_api_get function, filters the collaborators with read access, and then displays the list.
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

# Main script
# These lines first display a message indicating that users with read access to the specified repository are being listed, and then call the list_users_with_read_access function to perform the listing.
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
