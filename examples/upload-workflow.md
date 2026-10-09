# Audio Upload Workflow
An authenticated artist requests an upload.
The API validates ownership and upload permissions.
The API generates a short-lived presigned S3 upload URL.
The client uploads the audio directly to S3.
The platform validates the uploaded file and metadata.
An asynchronous worker converts the FLAC master into distribution formats.
The application records processing status and makes authorized versions available.

## Security

Upload URLs must be scoped to the intended operation and object. Validate file size, file format and ownership.

Audio transcoding should run as a separate worker workload on EKS or another appropriate processing service.

This document describes the intended workflow and does not claim that the upload or transcoding implementation already exists.
