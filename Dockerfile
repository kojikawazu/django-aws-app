# ベースイメージとして公式のPythonイメージを使用
FROM python:3.9

# 作業ディレクトリを設定
WORKDIR /app

# 依存関係をコピーしてインストール
COPY requirements.txt /app/
RUN pip install -r requirements.txt

# アプリケーションコードをコピー
COPY . /app/

# ポートを公開
EXPOSE 8000

# アプリケーションの起動コマンド
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
