# Security
## Objectives

Protect original music recordings, user identities, application interfaces and AWS infrastructure against unauthorized access.

## AWS Security
Block public access to the S3 audio bucket.
Use CloudFront Origin Access Control for access to the S3 origin.
Enforce HTTPS for public endpoints.
Apply least-privilege IAM permissions.
Protect Terraform state through encryption and access controls.
Use separate AWS accounts for production and non-production where practical.

## EKS Security
Restrict Kubernetes API access to authorized administrators and CI/CD identities.
Use Kubernetes RBAC and least-privilege permissions.
Run application containers as non-root where possible.
Avoid privileged containers and unnecessary Linux capabilities.
Apply resource requests and limits.
Store application secrets in an approved secret-management service.
Keep EKS, node images and add-ons on supported versions.
Use network policies where supported by the chosen networking implementation.

## Application Authorization

The PHP API remains responsible for user authentication and track-level authorization.

An artist should only be able to manage recordings they own or are authorized to manage. A paying music professional should only access tracks permitted by the applicable business rules.

The API must validate these permissions before generating a signed playback URL.

## Signed URLs

Signed URLs should have a limited lifetime and be issued only after authorization.

Signing private keys must remain server-side and should be stored and rotated securely.

Signed URLs can be shared while valid and do not prevent recording audio during authorized playback. Stronger DRM requirements would need a separate assessment.

## CI/CD Security
Prefer GitHub Actions OIDC over long-lived AWS access keys.
Use restricted IAM roles for infrastructure validation and deployment.
Separate plan and apply permissions.
Protect production deployments with branch protection and approval rules.
Scan Terraform and Kubernetes manifests for security misconfigurations.

## Production Readiness

The presence of security configuration does not prove that a system is secure. Validate the implementation through policy checks, access tests, image scanning and deployment reviews before production use.
