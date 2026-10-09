# Deployment Guide

## Prerequisites
An AWS account with appropriately restricted permissions.
Terraform installed locally.
AWS CLI configured for the intended account.
kubectl installed.
Kustomize installed, or an equivalent supported workflow.
Access to the repository and its GitHub Actions workflows.
Deployment Principles

Infrastructure and application deployment are separate stages.

Terraform manages AWS resources. Kubernetes manifests manage application workloads on the resulting cluster.

## Suggested Workflow
Review the environment configuration.
Validate and format Terraform.
Generate and review a Terraform plan.
Apply infrastructure changes only after reviewing the plan.
Configure kubectl access to the intended EKS cluster.
Validate Kubernetes manifests and Kustomize overlays.
Deploy the application using the approved deployment workflow.
Monitor costs, errors and resource utilization.

## Environment Isolation

Development, staging and production should use separate state and deployment permissions.

Separate AWS accounts are recommended for production isolation. Never use production credentials for local experiments.

## Cleanup

Before destroying a non-production environment, inspect the Terraform plan and identify persistent data resources.

Audio storage must not be destroyed automatically as part of a routine cluster cleanup.

## Limitations

The guide describes the intended workflow. It should be updated with tested commands, actual module inputs and verified deployment steps as the implementation matures.
