
# Djangoのインストール

```bash
pip install django
```

# Djangoプロジェクトの作成

```bash
django-admin startproject myproject
cd myproject
django-admin startapp myapp
cd ..
```

# settings.pyの更新

```bash
# myproject/settings.py

# 以下のデータベース設定をコメントアウト
# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.sqlite3',
#         'NAME': BASE_DIR / "db.sqlite3",
#     }
# }

# 他の設定はそのまま
```

# ルーティングの設定

```python:myproject/urls.py
from django.contrib import admin
from django.urls import path
from myapp import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
]
```

# ビューの作成

```python:myapp/views.py
from django.shortcuts import render

# Create your views here.

def home(request):
    return render(request, 'home.html')

def about(request):
    return render(request, 'about.html')
```

# テンプレートの作成

```html:myapp/templates/home.html
<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
</head>
<body>
    <h1>Welcome to the Home Page</h1>
    <p>This is the home page of our simple Django application.</p>
    <a href="{% url 'about' %}">About</a>
</body>
</html>
```

```html:myapp/templates/about.html
<!DOCTYPE html>
<html>
<head>
    <title>About</title>
</head>
<body>
    <h1>About Us</h1>
    <p>This is the about page of our simple Django application.</p>
    <a href="{% url 'home' %}">Home</a>
</body>
</html>
```

# Dockerfileの作成

```dockerfile
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
```

# docker composeの作成

```yml
version: '3.8'

services:
  web:
    build: .
    command: gunicorn --bind 0.0.0.0:8000 myproject.wsgi:application
    ports:
      - "8000:8000"
    volumes:
      - .:/app
```

# Docker Compose用を使用してアプリケーションを起動してみる

```bash
docker-compose up --build
```

```bash
# ECRリポジトリの作成
aws ecr create-repository --repository-name my-django-app

# ECRへログイン
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <your-aws-account-id>.dkr.ecr.ap-northeast-1.amazonaws.com

# Dockerイメージをビルド
docker build -t my-django-app .

# Dockerイメージにタグを付ける
docker tag my-django-app:latest <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-django-app:latest

# DockerイメージをECRにプッシュ
docker push <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-django-app:latest

```

```bash
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 605030569844.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t django-aws-app .

docker tag django-aws-app:latest 605030569844.dkr.ecr.ap-northeast-1.amazonaws.com/django-aws-app:latest

docker push 605030569844.dkr.ecr.ap-northeast-1.amazonaws.com/django-aws-app:latest
```

# App Runnderへデプロイ

AWS console画面からApp RunnerにDjangoWebアプリケーションを構築します。

1. AWS ダッシュボードへアクセスする
2. AWS App Runnerへ移動する
3. サービスの作成ボタンを押下する
4. コンテナから作成する
5. IAMは新規作成、ネットワークやセキュリティはデフォルトで設定する
6. デプロイ完了を待つ

# 再ビルド方法

```bash
# Dockerイメージを再ビルド
docker build --no-cache -t django-aws-app .

# Dockerイメージにタグを付ける
docker tag my-django-app:latest <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-django-app:latest

# DockerイメージをECRにプッシュ
docker push <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/my-django-app:latest
```

# URL

- AWS console

https://ap-northeast-1.console.aws.amazon.com/
