# ALB用のセキュリティグループを作成
resource "aws_security_group" "alb" {
  # セキュリティグループの名前を設定（アプリケーション名を含む）
  name = "${local.app}-alb"
  # セキュリティグループの説明を設定
  description = "ALB Security Group"
  # セキュリティグループを配置するVPCを指定（VPCモジュールから取得）
  vpc_id = module.vpc.vpc_id

  # インバウンドルールの設定
  ingress {
    # HTTP通信（ポート80）を許可
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # すべてのIPアドレスからのアクセスを許可（0.0.0.0/0）
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }

  # アウトバウンドルールの設定
  egress = {
    # すべてのポート（0-65535）とプロトコルを許可
    from_port = 0
    to_port   = 0
    protocol  = "-1"  # すべてのプロトコルを意味する
    # すべてのIPアドレスへのアクセスを許可（0.0.0.0/0）
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic to the internet"
  }

  # リソースにタグを付与（Name タグにアプリケーション名を含む）
  tags = {
    Name = "${local.app}-alb"
  }
}

# ECS用のセキュリティグループを作成
resource "aws_security_group" "ecs" {
  # セキュリティグループの名前を設定（アプリケーション名を含む）
  name        = "${local.app}-ecs"
  # セキュリティグループの説明を設定
  description = "ECS Security Group"
  # セキュリティグループを配置するVPCを指定（VPCモジュールから取得）
  vpc_id      = module.vpc.vpc_id

  # アウトバウンドルールの設定
  egress {
    # すべてのポート（0-65535）とプロトコルを許可
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # すべてのプロトコルを意味する
    # すべてのIPアドレスへのアクセスを許可（0.0.0.0/0）
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic to the internet"
  }

  # リソースにタグを付与（Name タグにアプリケーション名を含む）
  tags = {
    Name = "${local.app}-ecs"
  }
}

# ALBからECSへのトラフィックを許可するセキュリティグループルールを作成
resource "aws_security_group_rule" "alb_to_ecs" {
  # インバウンドルールとして設定
  type                     = "ingress"
  # ポート8080を許可（アプリケーションのポート）
  from_port                = 8080
  to_port                  = 8080
  # TCPプロトコルを使用
  protocol                 = "tcp"
  # このルールを適用するセキュリティグループ（ECS用）
  security_group_id        = aws_security_group.ecs.id
  # トラフィックの送信元セキュリティグループ（ALB用）
  source_security_group_id = aws_security_group.alb.id
  # 説明（コメントはここに追加可能）
}
