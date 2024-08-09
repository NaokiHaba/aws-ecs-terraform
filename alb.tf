# Application Load Balancer (ALB) リソースの作成
resource "aws_lb" "alb" {
  name               = "${local.app}-alb"          # ALBの名前をアプリケーション名を含めて設定
  load_balancer_type = "application"               # ロードバランサーのタイプをALBに指定
  subnets            = module.vpc.public_subnets   # ALBを配置するパブリックサブネットを指定
  security_groups    = [aws_security_group.alb.id] # ALBに適用するセキュリティグループを指定
}

# ALBリスナーの設定
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn # リスナーを関連付けるALBのARNを指定
  port              = 80             # リスナーのポートを80（HTTP）に設定
  protocol          = "HTTP"         # リスナーのプロトコルをHTTPに設定

  # デフォルトアクションの設定
  default_action {
    type = "fixed-response" # デフォルトアクションとして固定レスポンスを設定
    fixed_response {
      content_type = "text/plain"          # レスポンスのコンテンツタイプを指定
      message_body = "Fixed response page" # レスポンスのメッセージ本文を設定
      status_code  = "200"                 # レスポンスのステータスコードを200（OK）に設定
    }
  }
}

# ALBリスナールールの設定
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn # ルールを適用するリスナーのARNを指定

  # アクションの設定
  action {
    type             = "forward"                                # トラフィックをターゲットグループに転送するアクションを設定
    target_group_arn = aws_lb_target_group.alb_target_group.arn # 転送先のターゲットグループを指定
  }

  # 条件の設定
  condition {
    host_header {
      values = ["*"] # すべてのホストヘッダーに対してルールを適用
    }
  }
}

# ALBターゲットグループの設定
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${local.app}-alb-target-group" # ターゲットグループの名前をアプリケーション名を含めて設定
  port        = 8080                            # ターゲットグループのポートを8080に設定
  protocol    = "HTTP"                          # ターゲットグループのプロトコルをHTTPに設定
  target_type = "ip"                            # ターゲットタイプをIPアドレスに設定（ECS Fargateで使用）
  vpc_id      = module.vpc.vpc_id               # ターゲットグループを配置するVPCを指定

  # ヘルスチェックの設定
  health_check {
    path              = "/health_checks" # ヘルスチェックのパスを指定
    protocol          = "HTTP"           # ヘルスチェックのプロトコルをHTTPに設定
    interval          = 30               # ヘルスチェックの間隔を30秒に設定
    timeout           = 5                # ヘルスチェックのタイムアウトを5秒に設定
    healthy_threshold = 3                # 正常と判断するまでのヘルスチェック成功回数を3回に設定
  }
}
