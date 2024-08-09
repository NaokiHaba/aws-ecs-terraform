locals {
  # プロジェクト名を設定
  # 現在の作業ディレクトリ名からアンダースコアをハイフンに置換して使用
  name   = replace(basename(path.cwd), "_", "-")

  # AWSリージョンを設定
  # 東京リージョン（ap-northeast-1）を使用
  region = "ap-northeast-1"

  # アプリケーション名を設定
  # このプロジェクトで使用するGoアプリケーションの名前
  app    = "go-simple-server"
}
