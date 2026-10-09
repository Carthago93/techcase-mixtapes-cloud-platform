# Cloud Provider Selection
Status: Accepted for the portfolio design
Decision: AWS

## Context

Mixtapes needs globally distributed audio delivery, durable object storage, access controls and infrastructure that can be managed by a small IT team.

## Decision

Use Amazon S3 for audio object storage and Amazon CloudFront for content delivery.

Terraform manages the infrastructure configuration.

## Rationale

S3 and CloudFront integrate directly and support a private-origin architecture. The services reduce the need to operate storage servers and regional delivery infrastructure.

## Alternatives considered
Azure Blob Storage with Azure Front Door or Azure CDN.
Google Cloud Storage with Cloud CDN.
Self-managed storage servers and a separately operated CDN.

## Consequences

The design benefits from managed services and AWS integration but creates dependency on AWS services and pricing.

The decision should be revisited if organizational standards, contractual requirements or cost measurements favor another platform.
