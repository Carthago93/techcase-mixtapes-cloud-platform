# Signed URL Playback Workflow
The user selects a track.
The application requests playback authorization from the API.
The API authenticates the user and checks track-level permissions.
The API issues a short-lived CloudFront signed URL.
The client requests audio through CloudFront.
CloudFront validates the signature and serves the cached object or retrieves it from S3.

## Security Considerations

The signing private key must remain server-side. Signed URLs should have a limited lifetime and must not be exposed unnecessarily in application logs.

Signed URLs provide temporary access control but do not prevent audio recording during authorized playback.

## Validation

Test valid and expired signatures, unauthorized tracks, HTTP Range Requests, cache behavior and HTTPS enforcement before production use.
