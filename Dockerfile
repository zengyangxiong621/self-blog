# ==========================================
# 多阶段构建 Dockerfile
# 第一阶段：构建 VitePress 项目
# 第二阶段：使用 Nginx 提供静态文件服务
# ==========================================

# === 构建阶段 ===
# 使用 Node.js 18 Alpine 版本作为构建环境（体积小，安全性高）
FROM node:18-alpine AS builder

# 设置容器内的工作目录
WORKDIR /app

# 先复制 package.json 和 package-lock.json
# 这样做的好处：如果依赖没有变化，Docker 可以使用缓存层，加快构建速度
COPY package*.json ./

# 安装项目依赖
# npm ci: 比 npm install 更快，更适合生产环境
# 注意：这里安装完整依赖（包括 devDependencies），因为构建需要 VitePress
RUN npm ci

# 复制所有源代码到容器中
# 放在依赖安装之后，这样源代码变化时不会重新安装依赖
COPY . .

# 构建 VitePress 项目
# 将 Markdown 文档编译成静态 HTML 文件
# 输出目录：docs/.vitepress/dist
RUN npm run docs:build

# 清理 node_modules 目录
# 构建完成后不再需要 Node.js 依赖，删除以减小镜像大小
RUN rm -rf node_modules

# === 生产阶段 ===
# 使用轻量级的 Nginx Alpine 镜像提供静态文件服务
FROM nginx:alpine

# 复制自定义的 Nginx 配置文件
# 包含了 Gzip 压缩、缓存策略、安全头等优化配置
COPY nginx.conf /etc/nginx/nginx.conf

# 从构建阶段复制构建产物到 Nginx 的默认静态文件目录
# --from=builder: 指定从构建阶段复制文件
COPY --from=builder /app/docs/.vitepress/dist /usr/share/nginx/html

# 暴露 80 端口
# 告诉 Docker 这个容器会监听 80 端口
EXPOSE 80

# 启动 Nginx 服务
# -g "daemon off;": 让 Nginx 在前台运行，这样 Docker 容器不会退出
CMD ["nginx", "-g", "daemon off;"] 