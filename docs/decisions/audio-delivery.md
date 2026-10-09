# Audio Delivery Architecture
Status: Accepted for the portfolio design
Decision: Private S3 origin behind CloudFront

## Context

Audio files must be delivered quickly to users across multiple regions while restricting access to copyrighted material.

## Decision

Store audio in a private S3 bucket and distribute it through CloudFront with Origin Access Control.

The application authorizes playback and issues short-lived signed URLs.

## Rationale

The application does not need to proxy large audio files. CDN caching reduces repeated requests to the storage origin and improves delivery latency for geographically distributed users.

## Alternatives considered
Serve audio directly from application servers.
Expose public S3 objects.
Operate regional storage and delivery servers independently.

## Consequences

The design requires secure signing-key management and application-level authorization.

Signed URLs are an access-control measure, not complete digital rights management. Cache configuration and expiration behavior must be tested carefully.
