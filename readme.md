#系统初始化工具脚本

1、deepin系统
====
[2020-05-19]  
docker安装[参考官方]： 自动最新  
docker-compose： 1.26.0-rc4   
docker源设置

git安装[apt-get]

[本地nginx+php]  
deppin_ngx_php.sh
```markdown
location / {
            #本地开发时，使用主机名称访问的 80的nginx转发到docker的10080nginx 
            proxy_set_header Host               $host;
            proxy_set_header X-Real-IP          $remote_addr;
            proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto  $scheme;
            proxy_set_header X-Forwarded-Host   $host;
            proxy_set_header X-Forwarded-Port   $server_port;
            if ( $http_host ~ .*\.(test|demo|rpc|api|swoole)$ ) {
                proxy_pass                      http://127.0.0.1:10080;
            }
        }
```


2、CentOS 8安装手记
=====
docker安装[yum]
docker-compose： 1.25

3
  