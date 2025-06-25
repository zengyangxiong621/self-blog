# 部署指南

本指南将帮助您将 VitePress 博客部署到个人服务器上。

## 部署方式

我们提供了两种部署方式：

1. **传统部署**：直接将构建产物复制到服务器
2. **Docker部署**：使用容器化部署（推荐）

## 方式一：传统部署

### 服务器准备

1. 安装 Nginx
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx

# CentOS/RHEL
sudo yum install nginx
```

2. 配置 Nginx
```bash
sudo nano /etc/nginx/sites-available/blog
```

添加以下配置：
```nginx
server {
    listen 80;
    server_name your-domain.com;  # 替换为您的域名
    root /var/www/blog;
    index index.html;

    # Gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # SPA 路由支持
    location / {
        try_files $uri $uri/ $uri.html /index.html;
    }
}
```

3. 启用站点
```bash
sudo ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### GitHub Secrets 配置

在 GitHub 仓库设置中添加以下 Secrets：

- `HOST`: 服务器 IP 地址
- `USERNAME`: SSH 用户名
- `PRIVATE_KEY`: SSH 私钥
- `PORT`: SSH 端口（默认 22）

### 部署流程

推送代码到 `main` 分支后，GitHub Actions 会自动：
1. 构建 VitePress 项目
2. 通过 SSH 连接到服务器
3. 备份现有文件
4. 部署新版本
5. 设置正确的权限

## 方式二：Docker 部署（推荐）

### 服务器准备

1. 安装 Docker
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 添加用户到 docker 组
sudo usermod -aG docker $USER
```

2. 安装 Docker Compose（可选）
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Docker Hub 配置

1. 在 Docker Hub 创建仓库
2. 在 GitHub Secrets 中添加：
   - `DOCKER_USERNAME`: Docker Hub 用户名
   - `DOCKER_PASSWORD`: Docker Hub 密码或访问令牌

### 本地部署

使用提供的部署脚本：

```bash
# 构建并部署
./scripts/deploy.sh

# 查看日志
./scripts/deploy.sh logs

# 查看状态
./scripts/deploy.sh status

# 停止服务
./scripts/deploy.sh stop
```

### 服务器部署

GitHub Actions 会自动：
1. 构建 Docker 镜像
2. 推送到 Docker Hub
3. 在服务器上拉取并运行新镜像

## SSL 证书配置

### 使用 Let's Encrypt

1. 安装 Certbot
```bash
sudo apt install certbot python3-certbot-nginx
```

2. 获取证书
```bash
sudo certbot --nginx -d your-domain.com
```

3. 自动续期
```bash
sudo crontab -e
# 添加以下行
0 12 * * * /usr/bin/certbot renew --quiet
```

### Docker 环境中的 SSL

使用 Docker Compose 配置：
```bash
# 启用 SSL profile
docker-compose --profile ssl up -d

# 获取证书
docker-compose run --rm certbot
```

## 监控和维护

### 日志查看

传统部署：
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

Docker 部署：
```bash
docker logs -f zyx-blog
# 或使用脚本
./scripts/deploy.sh logs
```

### 健康检查

访问 `http://your-domain.com/health` 检查服务状态。

### 备份策略

1. 自动备份（已集成在部署流程中）
2. 手动备份：
```bash
sudo cp -r /var/www/blog /var/backups/blog-$(date +%Y%m%d_%H%M%S)
```

## 故障排除

### 常见问题

1. **构建失败**
   - 检查 Node.js 版本
   - 确认依赖安装正确
   - 查看 GitHub Actions 日志

2. **部署失败**
   - 验证 SSH 连接
   - 检查服务器权限
   - 确认目标目录存在

3. **服务无法访问**
   - 检查防火墙设置
   - 验证 Nginx 配置
   - 查看服务器日志

### 调试命令

```bash
# 检查服务状态
sudo systemctl status nginx

# 测试 Nginx 配置
sudo nginx -t

# 查看端口占用
sudo netstat -tlnp | grep :80

# 检查 Docker 容器
docker ps
docker logs zyx-blog
```

## 性能优化

1. **启用 Gzip 压缩**（已在配置中包含）
2. **配置缓存头**（已在配置中包含）
3. **使用 CDN**（可选）
4. **图片优化**
5. **资源压缩**

## 安全建议

1. **定期更新系统**
```bash
sudo apt update && sudo apt upgrade
```

2. **配置防火墙**
```bash
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

3. **使用强密码和密钥认证**
4. **定期备份数据**
5. **监控日志异常**

## 扩展功能

### 多环境部署

可以创建不同的分支对应不同环境：
- `main` -> 生产环境
- `staging` -> 测试环境
- `develop` -> 开发环境

### 回滚机制

如果需要回滚到之前版本：

传统部署：
```bash
sudo cp -r /var/backups/blog/backup-YYYYMMDD_HHMMSS /var/www/blog
```

Docker 部署：
```bash
docker run -d --name zyx-blog -p 80:80 your-username/zyx-blog:previous-tag
```

## 联系支持

如果在部署过程中遇到问题，请：
1. 检查本文档的故障排除部分
2. 查看 GitHub Actions 构建日志
3. 检查服务器日志文件 