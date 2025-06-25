#!/bin/bash

# Docker 构建测试脚本
set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Docker 是否可用
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装，请先安装 Docker"
        echo "安装命令："
        echo "curl -fsSL https://get.docker.com -o get-docker.sh"
        echo "sudo sh get-docker.sh"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker 服务未运行，请启动 Docker"
        echo "启动命令："
        echo "sudo systemctl start docker"
        exit 1
    fi
    
    print_info "Docker 检查通过"
}

# 构建镜像
build_image() {
    print_info "开始构建 Docker 镜像..."
    
    # 先构建项目
    print_info "构建 VitePress 项目..."
    npm run docs:build
    
    # 构建 Docker 镜像
    print_info "构建 Docker 镜像..."
    docker build -t zyx-blog:test .
    
    print_info "镜像构建完成"
}

# 测试运行
test_run() {
    print_info "测试运行容器..."
    
    # 停止可能存在的测试容器
    docker stop zyx-blog-test 2>/dev/null || true
    docker rm zyx-blog-test 2>/dev/null || true
    
    # 启动测试容器
    docker run -d \
        --name zyx-blog-test \
        -p 8080:80 \
        zyx-blog:test
    
    print_info "容器已启动，等待服务启动..."
    sleep 5
    
    # 健康检查
    if curl -f http://localhost:8080/health &> /dev/null; then
        print_info "✅ 健康检查通过"
        print_info "🎉 测试成功！访问地址: http://localhost:8080"
    else
        print_warning "健康检查失败，但容器可能正在启动中"
        print_info "请访问 http://localhost:8080 检查"
    fi
    
    # 显示容器日志
    print_info "容器日志："
    docker logs zyx-blog-test --tail 10
}

# 清理
cleanup() {
    print_info "清理测试资源..."
    docker stop zyx-blog-test 2>/dev/null || true
    docker rm zyx-blog-test 2>/dev/null || true
    docker rmi zyx-blog:test 2>/dev/null || true
    print_info "清理完成"
}

# 主函数
main() {
    case "${1:-test}" in
        "build")
            check_docker
            build_image
            ;;
        "test")
            check_docker
            build_image
            test_run
            ;;
        "cleanup")
            cleanup
            ;;
        "help")
            echo "使用方法: $0 [选项]"
            echo "选项:"
            echo "  build   - 仅构建镜像"
            echo "  test    - 构建并测试运行"
            echo "  cleanup - 清理测试资源"
            echo "  help    - 显示帮助"
            ;;
        *)
            print_error "未知选项: $1"
            echo "使用 $0 help 查看帮助"
            exit 1
            ;;
    esac
}

main "$@" 