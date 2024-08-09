# AWSプロバイダーの設定
# ローカル変数から地域を指定
provider "aws" {
  region = local.region
}

# Terraformの設定
terraform {
  # S3バックエンドの設定
  # 状態ファイルをS3に保存し、DynamoDBでロックを管理
  backend "s3" {
    bucket         = "aws-ecs-terraform-tfstate-2"  # 状態ファイルを保存するS3バケット
    key            = "terraform.tfstate"            # 状態ファイルの名前
    region         = "ap-northeast-1"               # S3バケットのリージョン
    dynamodb_table = "aws-ecs-terraform-tfstate-locking"  # ステートロック用のDynamoDBテーブル
    encrypt        = true                           # 状態ファイルの暗号化を有効化
  }

  # 必要なプロバイダーの指定
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # AWSプロバイダーのソース
      version = "~> 5.0"         # AWSプロバイダーのバージョン指定（5.x系）
    }
  }
}