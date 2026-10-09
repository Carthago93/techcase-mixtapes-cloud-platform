# Mixtapes Cloud Platform

Cloud Architecture | AWS | Terraform | Kubernetes | Amazon EKS

An independent cloud architecture project developed as part of my application process at Rockstars IT.

## Overview

Mixtapes is a music discovery platform for Rocky Roads, connecting emerging musicians with record labels, festivals, radio stations and other music professionals.

The original platform runs on traditional hosting infrastructure in Amsterdam. International growth introduces new requirements for global audio delivery, application scalability, security and predictable operational costs.

This project explores how Mixtapes could be modernized using AWS, Terraform and Kubernetes.

The proposed architecture separates the application platform from audio delivery, allowing each layer to scale independently.

## Business Challenges
Deliver audio efficiently to users across Europe and North America, with a path to expansion into Asia.
Store FLAC master recordings and distribute MP3 and AAC versions securely.
Reduce playback latency and unnecessary data transfer.
Protect copyrighted audio through authentication and authorization controls.
Keep operations manageable for a small IT team.
Scale application workloads according to demand.
Maintain visibility into infrastructure costs.

## Proposed Architecture

The design uses AWS managed services and Kubernetes to separate application workloads from audio delivery.

Amazon EKS: Managed Kubernetes control plane for containerized application workloads.
Amazon EC2 worker nodes: Compute capacity for Kubernetes workloads, managed through EKS node groups or an appropriate autoscaling solution.
Amazon S3: Private object storage for audio masters and distribution formats.
Amazon CloudFront: Global content delivery network for audio playback.
CloudFront Origin Access Control (OAC): Restricts direct access to the S3 origin.
CloudFront signed URLs: Provides time-limited access to protected audio.
AWS IAM and EKS access controls: Controls access to AWS resources and the Kubernetes cluster.
Terraform: Provisions cloud infrastructure.
Kubernetes and Kustomize: Define and customize application deployments.
GitHub Actions: Automates infrastructure and manifest validation.

The existing PHP REST API remains responsible for business logic, user authentication and track-level authorization.

## Architecture Overview

                         Global Users
                              |
                              v
                      Mixtapes Frontend
                              |
                              v
                     CloudFront / HTTPS
                              |
                    Application API Entry
                              |
                              v
                         Amazon EKS
                     +----------------+
                     | PHP REST API   |
                     | Kubernetes     |
                     | Deployments    |
                     +----------------+
                              |
                    Application Services
                              |
                   Authentication and
                      Authorization
                              |
                    Short-lived Signed URL
                              |
                              v
                         CloudFront
                              |
                       Private S3
                       Audio Storage


The diagram is conceptual. The application entry point and audio playback path are logically separate: API requests reach the application platform, while authorized audio requests are served through CloudFront.

## Infrastructure as Code

Terraform defines the AWS infrastructure and its relationships.

**The intended infrastructure modules cover:**

Private S3 audio storage.
S3 public-access blocking and encryption.
CloudFront distribution and origin access.
Amazon EKS cluster infrastructure.
Worker-node capacity and cluster networking.
Environment-specific configuration.

Kubernetes manifests define application workloads, services and deployment settings. Kustomize overlays allow selected configuration differences between development, staging and production.

## Why Amazon EKS?

Amazon EKS provides a managed Kubernetes control plane while allowing control over application scheduling, deployment strategies and cluster workloads.

It is a suitable platform to evaluate when Kubernetes expertise, portability, workload orchestration and a consistent container platform are strategic goals.

EKS introduces additional operational and financial overhead compared with simpler container services. The design therefore treats cluster sizing, autoscaling, observability, upgrades and access management as explicit operational concerns.

## Security

The design follows a defense-in-depth approach:

Private S3 storage with public access blocked.
CloudFront Origin Access Control for the S3 origin.
HTTPS for application and audio delivery.
IAM least-privilege policies.
Controlled access to the EKS cluster.
Kubernetes RBAC and namespace-level separation.
Secure handling of application secrets.
Short-lived signed URLs issued only after application authorization.
Terraform state stored in a protected remote backend.

Signed URLs restrict access but do not provide complete digital rights management. Users may still record audio during authorized playback.

## Scalability and Performance

The proposed architecture separates application scaling from audio delivery.

CloudFront caching: Reduces repeated requests to the S3 origin.
Amazon S3: Stores audio without managing storage servers.
Kubernetes Deployments: Maintain the desired number of application replicas.
Horizontal Pod Autoscaler: Can scale application replicas based on resource metrics.
Cluster autoscaling: Can add or remove worker-node capacity as workload demand changes.
Independent workloads: API services and audio-processing workers can use different resource requirements.

Autoscaling requires appropriate metrics, capacity configuration and operational testing. It does not automatically guarantee lower latency or lower costs.

## Cost Optimization

**The main cost drivers include:**

EKS cluster and worker-node capacity.
Load balancing, networking and NAT data processing.
S3 storage and requests.
CloudFront data transfer and requests.
Logging, monitoring and retained data.
Audio transcoding workloads.

Potential optimization measures include right-sizing worker nodes, using appropriate autoscaling, controlling log retention, monitoring CDN cache-hit ratios and selecting CloudFront price classes based on target markets.

EKS should be evaluated against the simpler operational model of alternative container services. The decision is based on the desired Kubernetes capabilities, not on an assumption that Kubernetes is always cheaper or faster.

## Environments

The repository defines separate configurations for:

Environment	Purpose
dev: Development and experimentation
staging: Integration, security and acceptance testing
prod: Production-oriented configuration and controlled deployments

Separate AWS accounts are recommended for stronger environment isolation. The repository structure alone does not mean that all three environments have been deployed.

## CI and Validation

GitHub Actions is intended to validate:

Terraform formatting and configuration.
Kubernetes YAML syntax and manifest structure.
Kustomize overlays.
Additional security checks as the project matures.

Validation does not prove that the infrastructure has been deployed successfully or that the application meets performance objectives.

## Future Improvements
Implement the PHP API container image and deployment pipeline.
Configure ingress, TLS and application networking.
Integrate AWS IAM Roles for Service Accounts or EKS Pod Identity where appropriate.
Add monitoring, alerting and resource dashboards.
Implement secure uploads and asynchronous audio transcoding.
Add automated infrastructure and security tests.
Measure playback latency and CDN cache performance.
Compare actual EKS operating costs against simpler container platforms.

## Disclaimer

This is an independent portfolio project developed as part of my application process at Rockstars IT. It is based on a cloud architecture challenge and is not an official implementation for Rockstars IT or Rocky Roads.

The repository documents the proposed architecture and the code implemented to support it. No production deployment, measured performance improvement or realized cost saving is claimed unless explicitly documented.
