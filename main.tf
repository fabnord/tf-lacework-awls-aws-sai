provider "lacework" {}

provider "aws" {
  region = "eu-central-1"
}

// This module will create AWS account "global" resources such as IAM roles, an S3 bucket, and a Secret Manager secret.
// This will also create a new Cloud Account Integration within the Lacework console.
module "lacework_aws_agentless_scanning_global" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  global                    = true
  lacework_integration_name = "AWS_AWLS_Integration"
}

// The following modules should be included per-region where scanning will occur.
// This creates an ECS cluster, a VPC and VPC IG for that cluster, and an EventBridge trigger in this region.
// The trigger will start a periodic Task to snapshot and analyze EC2 volumes in this region.

// Create regional resources in our first region
module "lacework_aws_agentless_scanning_region" {
  source  = "lacework/agentless-scanning/aws"
  version = "~> 0.6"

  regional                = true
  global_module_reference = module.lacework_aws_agentless_scanning_global
}