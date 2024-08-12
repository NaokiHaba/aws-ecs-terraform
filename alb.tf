# # Application Load Balancer (ALB) リソースの作成
# resource "aws_lb" "alb" {
#   name               = "${local.app}-alb"          # ALBの名前をアプリケーション名を含めて設定（一意性と識別性を確保）
#   load_balancer_type = "application"               # ロードバランサーのタイプをALB（Application Load Balancer）に指定（Layer 7での負荷分散を実現）
#   subnets            = module.vpc.public_subnets   # ALBを配置するパブリックサブネットを指定（インターネットからのアクセスを可能に）
#   security_groups    = [aws_security_group.alb.id] # ALBに適用するセキュリティグループを指定（トラフィックの制御とセキュリティ確保）
# }

# # ALBリスナーの設定
# resource "aws_lb_listener" "alb_listener" {
#   load_balancer_arn = aws_lb.alb.arn # リスナーを関連付けるALBのARNを指定（ALBとリスナーの紐付け）
#   port              = 80             # リスナーのポートを80（HTTP）に設定（標準的なHTTPポートでの受信）
#   protocol          = "HTTP"         # リスナーのプロトコルをHTTPに設定（HTTPトラフィックの処理）

#   # デフォルトアクションの設定
#   default_action {
#     type = "fixed-response" # デフォルトアクションとして固定レスポンスを設定（マッチしないリクエストへの対応）
#     fixed_response {
#       content_type = "text/plain"          # レスポンスのコンテンツタイプを指定（プレーンテキストとして返答）
#       message_body = "Fixed response page" # レスポンスのメッセージ本文を設定（デフォルトメッセージの定義）
#       status_code  = "200"                 # レスポンスのステータスコードを200（OK）に設定（正常応答を示す）
#     }
#   }
# }

# # ALBリスナールールの設定
# resource "aws_lb_listener_rule" "alb_listener_rule" {
#   listener_arn = aws_lb_listener.alb_listener.arn # ルールを適用するリスナーのARNを指定（リスナーとルールの関連付け）

#   # アクションの設定
#   action {
#     type             = "forward"                                # トラフィックをターゲットグループに転送するアクションを設定（リクエストの転送処理）
#     target_group_arn = aws_lb_target_group.alb_target_group.arn # 転送先のターゲットグループを指定（実際のアプリケーションインスタンスへの転送）
#   }

#   # 条件の設定
#   condition {
#     path_pattern {
#       values = ["*"] # すべてのパスパターンにマッチする条件を設定（全リクエストをターゲットグループに転送）
#     }
#   }
# }

# # ALBターゲットグループの設定
# resource "aws_lb_target_group" "alb_target_group" {
#   name        = "${local.app}-target-group" # ターゲットグループの名前をアプリケーション名を含めて設定（識別しやすい名前付け）
#   port        = 8080                        # ターゲットグループのポートを8080に設定（アプリケーションの待ち受けポート）
#   protocol    = "HTTP"                      # ターゲットグループのプロトコルをHTTPに設定（HTTPトラフィックの処理）
#   target_type = "ip"                        # ターゲットタイプをIPアドレスに設定（ECS Fargateで使用するため）
#   vpc_id      = module.vpc.vpc_id           # ターゲットグループを配置するVPCを指定（ネットワーク環境の指定）

#   # ヘルスチェックの設定
#   health_check {
#     path              = "/health_checks" # ヘルスチェックのパスを指定（アプリケーションの健康状態確認用エンドポイント）
#     protocol          = "HTTP"           # ヘルスチェックのプロトコルをHTTPに設定（HTTP経由でのヘルスチェック）
#     interval          = 30               # ヘルスチェックの間隔を30秒に設定（定期的な健康状態の確認）
#     timeout           = 5                # ヘルスチェックのタイムアウトを5秒に設定（応答がない場合の待機時間）
#     healthy_threshold = 3                # 正常と判断するまでのヘルスチェック成功回数を3回に設定（安定性の確保）
#   }
# }
