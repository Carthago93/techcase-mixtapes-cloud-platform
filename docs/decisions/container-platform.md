# Container Platform Selection
Status: Accepted for the proposed portfolio architecture
Decision: Amazon EKS with Kubernetes

## Context

Mixtapes needs a scalable application platform that supports containerized workloads, automated deployments and independent scaling of API and background-processing services.

The operations team is small, so the platform must balance Kubernetes capabilities with operational complexity and cost.

## Decision

Use Amazon EKS as the managed Kubernetes control plane, with EC2 worker nodes for application workloads.

Use Kubernetes Deployments and Services for the PHP REST API. Evaluate Horizontal Pod Autoscaler and a node autoscaling solution for workload scaling.

Audio files remain in S3 and are delivered through CloudFront rather than through the Kubernetes application Pods.

## Rationale

EKS provides a managed Kubernetes control plane while retaining Kubernetes APIs and ecosystem compatibility.

This approach demonstrates container orchestration, workload scheduling, deployment configuration and autoscaling.

It also provides flexibility for future services, including asynchronous audio transcoding and background processing.

## Alternatives Considered
Amazon ECS with Fargate for lower infrastructure-management overhead.
Self-managed Kubernetes on EC2.
Serverless functions for selected event-driven workloads.

## Trade-offs

EKS requires additional operational expertise and introduces costs for cluster management, worker nodes, networking, monitoring and upgrades.

The team must manage Kubernetes RBAC, node capacity, workload resources, cluster add-ons and application deployment practices.

## Consequences

The project prioritizes Kubernetes flexibility and demonstrates EKS architecture, while acknowledging that a simpler container platform could be more cost-effective for a small application.

The decision should be revisited using actual cost, performance and operational measurements.

This decision documents the intended architecture. It does not imply that an EKS cluster has already been deployed.
