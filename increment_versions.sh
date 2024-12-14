#!/bin/bash

# Increment image tag
increment_image_tag() {
    local current_tag="$1"
    local incremented_tag=$(echo "$current_tag + 0.1" | bc)
    printf "%.1f" "$incremented_tag"  # Format to one decimal place
}

# Increment helm chart version
increment_helm_chart_version() {
    local current_version="$1"
    local major=$(echo "$current_version" | cut -d '.' -f 1)
    local minor=$(echo "$current_version" | cut -d '.' -f 2)
    local patch=$(echo "$current_version" | cut -d '.' -f 3)
    ((patch++))
    echo "$major.$minor.$patch"
}

# Jenkinsfile path
jenkinsfile_path="/home/jenkins/agent/workspace/first/Jenkinsfile"

# Chart.yaml path
chart_yaml_path="/home/jenkins/agent/workspace/first/my-frontend-chart/Chart.yaml"

# Deployment.yaml path
deployment_yaml_path="/home/jenkins/agent/workspace/first/my-frontend-chart/templates/deployment.yaml"

# Get current image tag and increment
current_tag=$(awk '/image:/ {print $2}' "$deployment_yaml_path" | cut -d ':' -f 2)
new_tag=$(increment_image_tag "$current_tag")

# Replace image tag in deployment.yaml
sed -i "s/image: lavi324\/frontend:$current_tag/image: lavi324\/frontend:$new_tag/" "$deployment_yaml_path"
echo "Image tag updated from $current_tag to $new_tag in deployment.yaml."

# Jenkinsfile - Get current image tag and increment
current_jenkins_tag=$(awk -F "'" '/TAG/ {print $2}' "$jenkinsfile_path")
new_jenkins_tag=$(increment_image_tag "$current_jenkins_tag")

# Replace image tag in Jenkinsfile
sed -i "s/TAG = '$current_jenkins_tag'/TAG = '$new_jenkins_tag'/" "$jenkinsfile_path"
echo "Image tag updated from $current_jenkins_tag to $new_jenkins_tag in Jenkinsfile."

# Jenkinsfile - Get current helm chart version and increment
current_chart_version=$(awk -F '[.-]' '/helm push/ {print $4 "." $5 "." $6}' "$jenkinsfile_path")
new_chart_version=$(increment_helm_chart_version "$current_chart_version")

# Replace helm chart version in Jenkinsfile
sed -i "s/helm push my-frontend-chart-$current_chart_version.tgz/helm push my-frontend-chart-$new_chart_version.tgz/" "$jenkinsfile_path"
echo "Helm chart version updated from $current_chart_version to $new_chart_version in Jenkinsfile."

# Chart.yaml - Get current helm chart version and increment
current_chart_version=$(awk '/version:/ {print $2}' "$chart_yaml_path")
new_chart_version=$(increment_helm_chart_version "$current_chart_version")

# Replace helm chart version in Chart.yaml
sed -i "s/version: $current_chart_version/version: $new_chart_version/" "$chart_yaml_path"
echo "Helm chart version updated from $current_chart_version to $new_chart_version in Chart.yaml."

echo "Image tag and helm chart version incremented."
