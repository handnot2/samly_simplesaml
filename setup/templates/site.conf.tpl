server {
  listen {{ .idp_port }} ssl;
  listen [::]:{{ .idp_port }} ssl ipv6only=on;
  server_name {{ .idp_host }};
  ssl_certificate /etc/nginx/cert/server.crt;
  ssl_certificate_key /etc/nginx/cert/server.pem;
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers HIGH:!aNULL:!MD5;
  add_header X-Frame-Options "SAMEORIGIN";
  add_header X-Content-Type-Options "nosniff";
  add_header X-XSS-Protection "1; mode=block";

  error_log   /var/log/nginx/error.log;
  access_log  /var/log/nginx/access.log;
  root        /usr/share/nginx/html;
  index       index.php;

  location / {
    try_files $uri $uri/ =404;
    proxy_pass http://localhost:8080;
  }

  location ^~ /simplesaml {
    alias /srv/simplesaml/www;
    location ~ ^(?<prefix>/simplesaml)(?<phpfile>.+?\.php)(?<pathinfo>/.*)?$ {
      include fastcgi_params;
      fastcgi_pass  idp:9000;
      fastcgi_param SCRIPT_FILENAME $document_root$phpfile;
      fastcgi_param PATH_INFO       $pathinfo if_not_empty;
    }
  }

  location ~ \.php(/|$) {
    fastcgi_split_path_info ^(.+?\.php)(/.+)$;
    fastcgi_param           PATH_INFO $fastcgi_path_info;
    fastcgi_pass            idp:9000;
    fastcgi_index           index.php;
    include fastcgi_params;
  }
}
