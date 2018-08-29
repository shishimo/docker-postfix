# docker-postfix
開発用PostfixのDockerイメージ

## 起動方法

SMTP Authにsaslを利用しています。  
認証情報が保存されている.dbファイルをDockerイメージに含めたくなかったので、  
起動時にsasl_passwdファイルを含むホストのディレクトリをマウントして、  
そのsasl_passwdファイルからpostmapコマンドを実行して.dbファイルを作成するように作りました。

```
# Git clone
git clone https://github.com/shishimo/docker-postfix.git
cd docker-postfix

# sasl_passwdファイルを作成
echo "[smtp.google.com:587 <username>@gmail.com:<password>]" > etc/postfix/sasl_passwd

# 起動
docker run -it -p 25:25 -p 587:587 -v $PWD/etc /app/etc --name postfix postfix
```
