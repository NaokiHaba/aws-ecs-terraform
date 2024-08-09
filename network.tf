# VPCモジュールの定義
# terraform-aws-modules/vpc/aws モジュールを使用してVPCを構築
module "vpc" {
  # AWS VPCモジュールのソースを指定
  # 公式のTerraform Registryから最新バージョンを使用
  source = "terraform-aws-modules/vpc/aws"

  # VPC名をローカル変数から設定
  # locals.tf で定義された名前を使用し、一貫性を保つ
  name = local.name

  # VPCのCIDRブロックを指定
  # 10.0.0.0/16 は 65,536 個のIPアドレスを提供
  cidr = "10.0.0.0/16"

  # 利用可能なアベイラビリティーゾーンを指定（aとc）
  # 高可用性を確保するため、複数のAZを使用
  azs             = ["${local.region}a", "${local.region}c"]

  # プライベートサブネットのCIDRブロックを指定
  # 各サブネットは /24 で、256個のIPアドレスを提供
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  # パブリックサブネットのCIDRブロックを指定
  # 各サブネットは /24 で、256個のIPアドレスを提供
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  # パブリックサブネットの名前を指定
  # 明示的な名前付けにより、AWSコンソールでの識別が容易になる
  public_subnet_names  = ["aws-ecs-terraform-public-subnet-1", "aws-ecs-terraform-public-subnet-2"]

  # プライベートサブネットの名前を指定
  # 明示的な名前付けにより、AWSコンソールでの識別が容易になる
  private_subnet_names = ["aws-ecs-terraform-private-subnet-1", "aws-ecs-terraform-private-subnet-2"]

  # DNSホスト名の有効化
  # EC2インスタンスがパブリックDNSホスト名を受け取ることを可能にする
  enable_dns_hostnames = true

  # NATゲートウェイの有効化
  # プライベートサブネット内のリソースがインターネットにアクセスできるようにする
  # 注意: コストが発生するため、開発環境では無効にすることを検討
  enable_nat_gateway   = true

  # DNSサポートの有効化
  # VPC内のDNS解決を可能にし、Route 53 プライベートホストゾーンの使用を可能にする
  enable_dns_support   = true
}
