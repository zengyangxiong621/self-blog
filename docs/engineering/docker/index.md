# Docker 技术指南

## Docker 简介

Docker 是一个开源的容器化平台，它使开发者能够将应用程序与其依赖项打包到一个可移植的容器中，确保在任何环境中都能一致地运行。

### 为什么使用 Docker？

- **一致的运行环境**：消除了"在我的机器上能运行"的问题
- **快速部署**：容器可以在几秒钟内启动和停止
- **版本控制**：容器镜像可以版本化，方便回滚
- **隔离性**：应用程序运行在隔离的环境中，不会互相影响

## 核心概念

### 镜像（Image）

镜像是一个只读的模板，包含了运行应用程序所需的所有文件和配置。

```bash
# 查看本地镜像列表
docker images

# 拉取镜像
docker pull nginx:latest
```

### 容器（Container）

容器是镜像的运行实例，可以被启动、停止、删除等。

```bash
# 启动容器
docker run -d -p 80:80 nginx

# 查看运行中的容器
docker ps

# 停止容器
docker stop container_id
```

### Dockerfile

Dockerfile 是用于构建 Docker 镜像的文本文件，包含了一系列的指令和参数。

```dockerfile
# 基础镜像
FROM node:16

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["npm", "start"]
```

## 常用命令

### 镜像管理

```bash
# 构建镜像
docker build -t myapp:1.0 .

# 删除镜像
docker rmi image_id

# 推送镜像到仓库
docker push myapp:1.0
```

### 容器管理

```bash
# 进入容器
docker exec -it container_id /bin/bash

# 查看容器日志
docker logs container_id

# 删除容器
docker rm container_id
```

## Docker Compose

Docker Compose 用于定义和运行多容器 Docker 应用程序。

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
  db:
    image: mongo:latest
    volumes:
      - db-data:/data/db
volumes:
  db-data:
```

## 前端开发中的应用

### 开发环境标准化

使用 Docker 可以确保所有开发人员使用相同的开发环境：

```dockerfile
FROM node:16

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
```

### 持续集成/持续部署

Docker 在 CI/CD 流程中的应用：

1. 构建阶段：使用 Docker 构建应用
2. 测试阶段：在隔离环境中运行测试
3. 部署阶段：将 Docker 镜像推送到生产环境

## 最佳实践

1. **使用多阶段构建**：减小最终镜像的大小
2. **合理使用缓存**：优化构建速度
3. **注意安全性**：使用非 root 用户运行应用
4. **及时更新基础镜像**：获取安全补丁

## 总结

Docker 已经成为现代开发流程中不可或缺的工具。掌握 Docker 不仅能提高开发效率，还能确保应用的可靠部署和运行。在前端开发中，Docker 的使用越来越普遍，特别是在开发环境标准化和持续集成/部署方面发挥着重要作用。