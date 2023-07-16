# ビルドに使用されるベースイメージを指定
# Go 言語バージョン 1.20 がプリインストールされた Alpine Linux ベースのイメージを使用
FROM golang:1.20-alpine

# コンテナ内での作業ディレクトリを設定
# 後続の命令（RUN, CMD, ENTRYPOINT, COPY, ADD）はこのディレクトリ上で実行される
WORKDIR /go/src/

# Dockerfileが存在するディレクトリ（ビルドコンテキスト）のすべてのファイルとディレクトリを、コンテナの作業ディレクトリ（ここでは /go/src/）にコピー
COPY . ./
# Go の依存関係を解決し go.mod と go.sum ファイルを更新
# 不要な依存関係を削除し、不足している依存関係を追加するための手段
RUN go mod tidy
# ソースコードをビルド
# GOOS=linux GOARCH=amd64は、出力される実行可能ファイルが Linux OS と AMD64 アーキテクチャ用にビルドされることを示す
RUN GOOS=linux GOARCH=amd64 go build main.go

# コンテナが実行時に指定されたネットワークポートをリッスンすることを示す
# 実際のポートマッピングは Docker run コマンドの -p オプションや docker-compose ファイルなどで設定する
EXPOSE 8080
EXPOSE 8090

# コンテナが起動したときに実行されるコマンドを定義
# ここではビルドした実行可能ファイル main が指定されている
ENTRYPOINT ["./main"]