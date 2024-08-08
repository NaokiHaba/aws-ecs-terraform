terraform {
  backend "s3" {
    # 状態ファイルの保存先としてAWS S3を使用する
    bucket         = "terraform-state-bucket-dev"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}
