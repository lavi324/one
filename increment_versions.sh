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

# Paths
jenkinsfile_path="/home/jenkins/agent/workspace/first/Jenkinsfile"
chart_yaml_path="/home/jenkins/agent/workspace/first/one-frontend-helm-chart/Chart.yaml"
deployment_yaml_path="/home/jenkins/agent/workspace/first/one-frontend-helm-chart/templates/deployment.yaml"

# Step 1: Increment image tag in deployment.yaml
current_tag=$(awk '/image:/ {print $2}' "$deployment_yaml_path" | cut -d ':' -f 2)
new_tag=$(increment_image_tag "$current_tag")
sed -i "s|image: lavi324/one-frontend:$current_tag|image: lavi324/one-frontend:$new_tag|" "$deployment_yaml_path"
echo "Image tag updated from $current_tag to $new_tag in deployment.yaml."

# Step 2: Increment image tag in Jenkinsfile
current_jenkins_tag=$(awk -F "'" '/TAG/ {print $2}' "$jenkinsfile_path")
new_jenkins_tag=$(increment_image_tag "$current_jenkins_tag")
sed -i "s|TAG = '$current_jenkins_tag'|TAG = '$new_jenkins_tag'|" "$jenkinsfile_path"
echo "Image tag updated from $current_jenkins_tag to $new_jenkins_tag in Jenkinsfile."

# Step 3: Increment Helm chart version in Jenkinsfile
current_chart_version=$(awk '/helm push/ {match($0, /one-frontend-helm-chart-([0-9]+\.[0-9]+\.[0-9]+)/, a); print a[1]}' "$jenkinsfile_path")
if [[ -z "$current_chart_version" ]]; then
    echo "Error: Unable to extract Helm chart version from Jenkinsfile."
    exit 1
fi
new_chart_version=$(increment_helm_chart_version "$current_chart_version")
sed -i "s|one-frontend-helm-chart-$current_chart_version|one-frontend-helm-chart-$new_chart_version|" "$jenkinsfile_path"
echo "Helm chart version updated from $current_chart_version to $new_chart_version in Jenkinsfile."

# Step 4: Increment Helm chart version in Chart.yaml
current_chart_version=$(awk '/version:/ {print $2}' "$chart_yaml_path")
new_chart_version=$(increment_helm_chart_version "$current_chart_version")
sed -i "s|version: $current_chart_version|version: $new_chart_version|" "$chart_yaml_path"
echo "Helm chart version updated from $current_chart_version to $new_chart_version in Chart.yaml."

echo "Increment script completed successfully."

