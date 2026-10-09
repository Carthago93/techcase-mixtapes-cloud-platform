# Application

## Purpose

This directory documents the integration between the existing Mixtapes PHP REST API and the AWS infrastructure.

## Responsibilities

**The API is responsible for:**

Authenticating users.
Authorizing access to individual tracks.
Validating upload permissions.
Generating short-lived signed CloudFront URLs.
Returning track metadata and playback information.
Kubernetes Integration

The API is intended to run as a containerized workload on Amazon EKS.

Kubernetes manages application replicas and internal service connectivity. Audio bytes are delivered through CloudFront and S3 instead of being proxied through the API.

## Status

This document describes the intended integration. A running API, container image and application endpoints must be implemented and tested separately.
