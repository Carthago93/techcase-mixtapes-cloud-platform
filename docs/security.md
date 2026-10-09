# Security
## Security objectives

Mixtapes contains original music recordings. Access must be restricted according to ownership, permissions and business relationships.

Storage security
Block all public S3 access.
Use CloudFront Origin Access Control.
Restrict the S3 bucket policy to the intended CloudFront distribution.
Enable encryption at rest.
Enforce HTTPS for content delivery.
Apply least-privilege IAM permissions.

## Authorization

The application API remains responsible for user authentication and authorization.

A user must not automatically receive access to every track merely because they have an account.

The API should evaluate track ownership, sharing permissions, subscriptions and other relevant business rules before issuing a signed URL.

## Signed URLs

Signed URLs should have a short expiration time appropriate to the playback experience.

The signing private key must be stored securely and must never be committed to Git or embedded in frontend code.

Signed URLs reduce unauthorized access but do not prevent copying or recording content during a valid playback session. Additional content protection may be required for higher-risk use cases.

## Secrets management
Do not commit credentials or private keys.
Use AWS Secrets Manager or another approved secret-management service where appropriate.
Prefer GitHub Actions OIDC for CI/CD authentication to AWS.
Keep Terraform state encrypted and access-controlled.

## Logging and monitoring

Production deployments should enable appropriate CloudTrail auditing, CloudFront and S3 access logging, security monitoring and alerting.

Logging configurations must balance audit requirements, privacy and storage costs.

## Production readiness

This document describes the intended controls. Their effectiveness must be verified through configuration reviews and security tests before production use.
