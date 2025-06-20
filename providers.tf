terraform{
  required_providers{
    source = "hashicorp/aws"
    version = "6.0.0"
  }
}
provider "aws" {
  region = "us-east-1"
}