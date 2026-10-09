# Cost Analysis
## Main Cost Drivers

**The main cost categories are:**

Amazon EKS cluster management.
EC2 worker nodes and associated storage.
Load balancers and networking.
NAT Gateway processing and data transfer, where applicable.
S3 storage and requests.
CloudFront data transfer and requests.
Logging, monitoring and retention.
Audio transcoding and background processing.
Storage Estimate

**The average estimated file sizes are:**

FLAC master: 6 MB.
MP3 distribution file: 3 MB.
AAC distribution file: 3 MB.

This results in approximately 12 MB per track, excluding metadata, additional versions and storage overhead.

**For 100,000 tracks:**

100,000 × 12 MB = approximately 1.2 TB of audio.

## Delivery Estimate

If 100,000 tracks are each downloaded in full 100 times at an average delivery-file size of 3 MB, the resulting delivery volume is approximately 30 TB.

This is an illustrative scenario rather than a forecast. Real usage depends on playback duration, audio format, caching and user behavior.

## EKS Cost Considerations

EKS introduces a recurring cluster-management cost in addition to worker-node and networking costs.

Worker nodes should be sized against actual workload requirements. Autoscaling can reduce unused capacity, but a minimum number of nodes is still needed for availability and scheduling.

Development environments can use smaller capacity and scheduled shutdowns where appropriate. Production should not sacrifice availability simply to minimize compute costs.

## Cost Optimization
Keep audio delivery outside the Kubernetes cluster.
Monitor CloudFront cache-hit ratio and origin requests.
Right-size EC2 worker nodes.
Evaluate Cluster Autoscaler or Karpenter for node provisioning.
Scale application replicas using workload metrics.
Control log retention and monitoring volume.
Review NAT Gateway costs and alternative network designs.
Configure AWS Budgets and cost alerts.
Compare EKS costs with alternative managed container services.
Evaluation Criteria

**The EKS decision should be reviewed against:**

Monthly infrastructure cost.
Cost per 1,000 successful playback sessions.
Worker-node utilization.
Application latency and error rate.
CloudFront cache-hit ratio.
Operational effort required to maintain the platform.

Actual pricing should be calculated using current AWS pricing and realistic workload assumptions before production deployment.
