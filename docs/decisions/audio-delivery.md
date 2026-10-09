# Audio Delivery Architecture
Status: Accepted
Decision: Private Amazon S3 origin behind Amazon CloudFront

## Context

Audio must be delivered quickly across regions while protecting original recordings and limiting unnecessary origin traffic.

## Decision

Store audio in a private S3 bucket and deliver it through CloudFront using Origin Access Control.

The PHP API remains responsible for authorization and issues short-lived CloudFront signed URLs.

## Rationale

CloudFront caching reduces repeated origin requests and allows audio delivery to scale independently of the EKS application platform.

S3 avoids the need to operate storage servers or mount audio libraries into application containers.

## Alternatives Considered
Streaming audio through PHP application Pods;
Serving audio from public S3 objects;
Operating regional audio servers.

## Consequences

The design requires secure signing-key management, careful cache configuration and testing of authorization and HTTP Range Requests.

Signed URLs provide temporary access control but do not prevent recording audio during valid playback.
