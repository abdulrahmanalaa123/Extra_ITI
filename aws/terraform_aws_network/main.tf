provider "aws" {
  shared_config_files      = ["/home/tomato/.aws/config"]
  shared_credentials_files = ["/home/tomato/.aws/credentials"]
  region                   = "eu-central-1"
}
