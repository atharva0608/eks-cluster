#!/bin/bash

# EKS Access Setup Script
# This script helps resolve common EKS access issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="devv-cluster"
REGION="us-west-2"
PROFILE="default"

echo -e "${GREEN}Starting EKS Access Setup...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}Checking prerequisites...${NC}"
for cmd in aws kubectl; do
    if ! command_exists $cmd; then
        echo -e "${RED}Error: $cmd is not installed${NC}"
        exit 1
    fi
done

# Check AWS CLI configuration
echo -e "${YELLOW}Checking AWS CLI configuration...${NC}"
if ! aws sts get-caller-identity --profile $PROFILE >/dev/null 2>&1; then
    echo -e "${RED}Error: AWS CLI not configured properly${NC}"
    exit 1
fi

# Get current user identity
CURRENT_USER=$(aws sts get-caller-identity --profile $PROFILE --query 'Arn' --output text)
echo -e "${GREEN}Current AWS Identity: $CURRENT_USER${NC}"

# Update kubeconfig
echo -e "${YELLOW}Updating kubeconfig...${NC}"
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME --profile $PROFILE

# Test kubectl access
echo -e "${YELLOW}Testing kubectl access...${NC}"
if kubectl get nodes >/dev/null 2>&1; then
    echo -e "${GREEN}✓ kubectl access successful${NC}"
    kubectl get nodes
else
    echo -e "${RED}✗ kubectl access failed${NC}"
    echo -e "${YELLOW}This might be due to aws-auth ConfigMap issues${NC}"
fi

# Check aws-auth ConfigMap
echo -e "${YELLOW}Checking aws-auth ConfigMap...${NC}"
if kubectl get configmap aws-auth -n kube-system >/dev/null 2>&1; then
    echo -e "${GREEN}✓ aws-auth ConfigMap exists${NC}"
    echo -e "${YELLOW}Current aws-auth ConfigMap:${NC}"
    kubectl get configmap aws-auth -n kube-system -o yaml
else
    echo -e "${RED}✗ aws-auth ConfigMap not found${NC}"
fi

# Provide troubleshooting information
echo -e "${YELLOW}Troubleshooting Tips:${NC}"
echo "1. Make sure your IAM user/role has the necessary permissions"
echo "2. Check if your user/role is added to the aws-auth ConfigMap"
echo "3. Verify the EKS cluster is in ACTIVE state"
echo "4. Ensure your AWS credentials are correctly configured"

echo -e "${GREEN}Setup complete!${NC}"