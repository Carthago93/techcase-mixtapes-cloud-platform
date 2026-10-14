#This policy is a reusable least-privilege policy document for the workload.
#For production, bind it to a Kubernetes service account through EKS Pod Identity

data "aws_iam_policy_document" "application_audio_and_queue" {
  statement {
    sid       = "ReadWriteAudioObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:AbortMultipartUpload"]
    resources = ["${aws_s3_bucket.audio.arn}/*"]
  }

  statement {
    sid       = "ListAudioBucket"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.audio.arn]
  }

  statement {
    sid       = "UseAudioKmsKey"
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:Encrypt", "kms:GenerateDataKey", "kms:DescribeKey"]
    resources = [aws_kms_key.audio.arn]
  }

  statement {
    sid       = "SendAndReceiveTranscodingMessages"
    effect    = "Allow"
    actions   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:ChangeMessageVisibility", "sqs:GetQueueAttributes"]
    resources = [aws_sqs_queue.transcoding.arn]
  }
}

resource "aws_iam_policy" "application_audio_and_queue" {
  name        = "${local.name}-application-audio-queue"
  description = "Least-privilege permissions for Mixtapes application workloads"
  policy      = data.aws_iam_policy_document.application_audio_and_queue.json
  tags        = local.tags
}
