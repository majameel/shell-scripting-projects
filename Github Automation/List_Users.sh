#!/bin/bash
#############################################################
## About the Author : MOHD ABDUL JAMEEL
## Date : 24 Apr 2025
## About : This script lists the number of users existing in the Repository 
## ** It doesn't list the users who have OWNER level Access ##
#############################################################

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME="your_github_username"
TOKEN="your_github_token"

# User and Repository information
REPO_OWNER="$1"
REPO_NAME="$2"

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

# Helper function to check arguments
function helper {
    expected_cmd_args=2
    if [ "$#" -ne "$expected_cmd_args" ]; then
        echo "Error: Please execute the script with the required arguments."
        echo "Usage: $0 <REPO_OWNER> <REPO_NAME>"
        echo "Retry or contact Jameel"
        exit 1
    fi
}

# Main script execution
helper "$@"
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
