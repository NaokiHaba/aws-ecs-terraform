terraform {
  backend "s3" {
    # 状態ファイルの保存先としてAWS S3を使用する
    bucket         = "aws-ecs-terraform-tfstate-2"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "aws-ecs-terraform-tfstate-locking"
    encrypt        = true
  }
}
