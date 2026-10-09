# Cloud Provider Selection
Status: Accepted
Decision: Amazon Web Services (AWS)

## Context

Mixtapes requires global audio delivery, durable object storage, secure application hosting and infrastructure that can scale internationally.

## Decision

Use AWS as the cloud platform.

Amazon S3 provides audio storage, CloudFront provides content delivery and Amazon EKS provides the container orchestration platform.

Terraform manages the infrastructure configuration.

## Rationale

AWS offers integrated services for object storage, global delivery, identity management, networking and Kubernetes.

This allows the platform to separate application execution from audio distribution.

## Alternatives Considered
Microsoft Azure.
Google Cloud Platform.
Traditional hosting with a separately managed CDN.

## Consequences

The design benefits from managed AWS services but creates dependency on AWS pricing, service availability and platform-specific integrations.

The choice should be reviewed if organizational requirements or measured cost comparisons favor another platform.
