# Container Platform Selection
Status: Proposed
Decision: Prefer ECS Fargate for the initial application container platform

## Context

The existing PHP REST API may need to scale independently of audio delivery.

The team has three people responsible for platform maintenance and limited cloud experience.

## Decision

Prefer Amazon ECS with Fargate for the initial containerized application platform.

## Rationale

Fargate removes the need to manage worker nodes and a Kubernetes control plane. It allows the team to focus on the application, security and deployment process.

## Alternatives considered
Amazon EKS with Kubernetes.
EC2 instances with self-managed containers.
Serverless functions for selected event-driven tasks.

## Consequences

ECS Fargate may reduce operational overhead but provides a different ecosystem and portability model from Kubernetes.

EKS should be reconsidered if the organization adopts Kubernetes as a standard or needs its scheduling, ecosystem and platform capabilities.

This decision does not imply that the application platform has already been implemented or deployed.
