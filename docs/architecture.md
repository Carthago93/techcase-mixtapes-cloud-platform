# Architecture
## Objective

Modernize Mixtapes to support international growth while maintaining secure audio delivery, scalable application workloads and manageable operating costs.

## Architecture Layers
**1. Application layer**

The PHP REST API runs as a containerized application on Amazon EKS.

Kubernetes Deployments manage application replicas, while Services provide stable internal connectivity. An application entry point, such as an AWS Application Load Balancer managed through an appropriate ingress integration, exposes the API over HTTPS.

**2. Audio delivery layer**

Audio files are stored in a private S3 bucket and distributed through CloudFront.

The API authorizes playback and provides a short-lived signed URL. The client retrieves the audio directly from CloudFront rather than streaming it through the PHP application.

**3. Infrastructure layer**

Terraform provisions the AWS infrastructure, including the networking foundation, EKS cluster, node capacity, S3 storage and CloudFront distribution.

Kubernetes manifests manage application workloads separately from the underlying cloud infrastructure.

## Request Flow
A user requests playback through the Mixtapes application.
The API authenticates the user and checks track-level permissions.
The API issues a signed CloudFront URL.
The client requests the audio through CloudFront.
CloudFront validates the signature and serves a cached object or retrieves it from S3.
Monitoring captures relevant application and delivery metrics.

## Scaling Strategy

Application scaling and audio delivery scaling are independent.

Kubernetes replica scaling adjusts the number of application Pods.
Node autoscaling adjusts available worker capacity.
S3 provides managed object storage.
CloudFront distributes cached audio to users across geographic regions.

Audio transcoding should run as a separate worker workload rather than blocking API requests.

## Availability and Recovery

A production deployment should distribute worker capacity across multiple Availability Zones and define suitable Pod placement, disruption budgets and health checks.

Recovery objectives, backup policies, cluster upgrade procedures and regional disaster recovery require additional design and testing.

## Scope

The repository focuses on infrastructure and deployment design. Any component not implemented and validated should be described as proposed rather than operational.
