#!/bin/bash

# VitePress Blog 部署脚本
set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 配置变量
IMAGE_NAME="zyx-blog"
CONTAINER_NAME="zyx-blog"
PORT="80"

# 函数：打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装或未在 PATH 中找到"
        exit 1
    fi
    print_message "Docker 检查通过"
}

# 构建镜像
build_image() {
    print_message "开始构建 Docker 镜像..."
    docker build -t $IMAGE_NAME .
    print_message "镜像构建完成"
}

# 停止并删除旧容器
stop_old_container() {
    if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "发现旧容器，正在停止并删除..."
        docker stop $CONTAINER_NAME || true
        docker rm $CONTAINER_NAME || true
        print_message "旧容器已清理"
    fi
}

# 启动新容器
start_container() {
    print_message "启动新容器..."
    
    # 创建日志目录
    mkdir -p ./logs
    
    docker run -d \
        --name $CONTAINER_NAME \
        --restart unless-stopped \
        -p $PORT:80 \
        -v $(pwd)/logs:/var/log/nginx \
        -e TZ=Asia/Shanghai \
        $IMAGE_NAME
    
    print_message "容器已启动"
}

# 健康检查
health_check() {
    print_message "等待服务启动..."
    sleep 10
    
    if docker ps --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
        print_message "容器运行正常"
        
        # 检查服务是否响应
        if curl -f http://localhost:$PORT/health &> /dev/null; then
            print_message "服务健康检查通过"
            print_message "🎉 部署成功！访问地址: http://localhost:$PORT"
        else
            print_warning "服务可能还在启动中，请稍后检查"
        fi
    else
        print_error "容器启动失败"
        docker logs $CONTAINER_NAME
        exit 1
    fi
}

# 清理未使用的镜像
cleanup() {
    print_message "清理未使用的镜像..."
    docker image prune -f
    print_message "清理完成"
}

# 显示使用说明
show_usage() {
    echo "使用方法: $0 [选项]"
    echo "选项:"
    echo "  build    - 仅构建镜像"
    echo "  deploy   - 构建并部署"
    echo "  stop     - 停止容器"
    echo "  logs     - 查看容器日志"
    echo "  status   - 查看容器状态"
    echo "  cleanup  - 清理未使用的镜像"
    echo "  help     - 显示此帮助信息"
}

# 主逻辑
case "${1:-deploy}" in
    "build")
        check_docker
        build_image
        ;;
    "deploy")
        check_docker
        build_image
        stop_old_container
        start_container
        health_check
        cleanup
        ;;
    "stop")
        docker stop $CONTAINER_NAME 2>/dev/null || print_warning "容器未运行"
        docker rm $CONTAINER_NAME 2>/dev/null || print_warning "容器不存在"
        print_message "容器已停止"
        ;;
    "logs")
        docker logs -f $CONTAINER_NAME
        ;;
    "status")
        if docker ps --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
            print_message "容器正在运行"
            docker ps --filter name=$CONTAINER_NAME
        else
            print_warning "容器未运行"
        fi
        ;;
    "cleanup")
        cleanup
        ;;
    "help")
        show_usage
        ;;
    *)
        print_error "未知选项: $1"
        show_usage
        exit 1
        ;;
esac 