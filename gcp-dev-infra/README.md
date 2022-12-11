# gcp-dev-infra

### 事前準備(初回デプロイ時のみ)

---

- Cloud Source Repositries 作成
- terraform の state 管理の為バケット作成
- cloudbuild 設定

- 証明書作成

```
openssl genrsa 2048 > server.key
openssl req -new -key server.key > server.csr

[root@my-gitlab01 ~]# openssl req -new -key server.key > server.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:JP
State or Province Name (full name) []:
Locality Name (eg, city) [Default City]:
Organization Name (eg, company) [Default Company Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:[DOMAIN]
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt
mv -i server.key /etc/gitlab/ssl/[DOMAIN].key
mv -i server.crt /etc/gitlab/ssl/[DOMAIN].crt
chmod 400 /etc/gitlab/ssl/[DOMAIN].key
chmod 400 /etc/gitlab/ssl/[DOMAIN].crt

gitlab-ctl reconfigure
```
