# Cost Analysis
## Main cost drivers

**The primary cost drivers are:**

S3 storage volume.
CloudFront data transfer to users.
CDN and storage requests.
Audio transcoding and processing.
Logging, monitoring and retained versions.
Supporting application and database infrastructure.
Storage estimate

**An average track consists of:**

FLAC master: 6 MB.
MP3 version: 3 MB.
AAC version: 3 MB.

The estimated total is 12 MB per track, excluding metadata, versions and overhead.

For 100,000 tracks:

100,000 × 12 MB = approximately 1.2 TB of stored audio.

## Delivery estimate

If 100,000 tracks are each downloaded in full 100 times at an average distribution-file size of 3 MB, the resulting audio delivery volume is approximately 30 TB.

This is an illustrative scenario rather than a forecast. Actual delivery volume depends on playback duration, format, user behavior and caching.

## Cost optimization
Use CloudFront to reduce repeated origin requests.
Monitor cache-hit ratio and origin traffic.
Evaluate CloudFront price classes against target markets.
Review S3 lifecycle transitions against actual access patterns.
Configure AWS Budgets and cost alerts.
Monitor unexpected traffic spikes and automated downloads.
Evaluate transcoding costs separately from delivery costs.

## Important limitations

CloudFront caching does not eliminate data-transfer costs. Regional pricing, request volume and the geographic distribution of users affect expenditure.

S3 Intelligent-Tiering can reduce storage costs for suitable access patterns, but monitoring charges and minimum storage-duration rules must be considered.

Before production deployment, validate estimates against current AWS pricing and realistic traffic measurements.

## KPIs
Monthly audio delivery cost.
Cost per 1,000 full-track plays.
CloudFront cache-hit ratio.
S3 origin requests and data transfer.
Average time to first audio byte.
Storage cost per active track.
Cost per successfully transcoded track.
