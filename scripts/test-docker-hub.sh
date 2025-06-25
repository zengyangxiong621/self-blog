#!/bin/bash

# Docker Hub 连接测试脚本
set -e

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
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

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# 测试基础网络
test_network() {
    print_header "测试基础网络连接"
    
    print_info "测试 DNS 解析..."
    if nslookup google.com > /dev/null 2>&1; then
        print_info "✅ DNS 解析正常"
    else
        print_error "❌ DNS 解析失败"
        return 1
    fi
    
    print_info "测试外网连接..."
    if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
        print_info "✅ 外网连接正常"
    else
        print_error "❌ 外网连接失败"
        return 1
    fi
}

# 测试 Docker Hub 连接
test_docker_hub() {
    print_header "测试 Docker Hub 连接"
    
    print_info "测试 Docker Hub 主站..."
    if curl -I --connect-timeout 10 https://hub.docker.com > /dev/null 2>&1; then
        print_info "✅ Docker Hub 主站可访问"
    else
        print_warning "⚠️ Docker Hub 主站访问较慢"
    fi
    
    print_info "测试 Docker Registry..."
    if curl -I --connect-timeout 10 https://registry-1.docker.io/v2/ > /dev/null 2>&1; then
        print_info "✅ Docker Registry 可访问"
    else
        print_error "❌ Docker Registry 无法访问"
        return 1
    fi
}

# 测试镜像加速器
test_mirrors() {
    print_header "测试镜像加速器"
    
    mirrors=(
        "https://docker.mirrors.ustc.edu.cn"
        "https://hub-mirror.c.163.com"
        "https://registry.docker-cn.com"
        "https://mirror.ccs.tencentyun.com"
    )
    
    for mirror in "${mirrors[@]}"; do
        print_info "测试 $mirror ..."
        if curl -I --connect-timeout 5 "$mirror/v2/" > /dev/null 2>&1; then
            print_info "✅ $mirror 可用"
        else
            print_warning "⚠️ $mirror 不可用"
        fi
    done
}

# 测试 Docker 配置
test_docker_config() {
    print_header "检查 Docker 配置"
    
    if [ -f /etc/docker/daemon.json ]; then
        print_info "Docker 配置文件存在"
        print_info "当前配置："
        cat /etc/docker/daemon.json | jq . 2>/dev/null || cat /etc/docker/daemon.json
    else
        print_warning "Docker 配置文件不存在"
    fi
    
    print_info "Docker 信息："
    docker info | grep -A 10 "Registry Mirrors" || print_warning "未配置镜像加速器"
}

# 测试拉取镜像
test_pull() {
    print_header "测试拉取镜像"
    
    print_info "尝试拉取 hello-world 镜像..."
    if timeout 60 docker pull hello-world > /dev/null 2>&1; then
        print_info "✅ 镜像拉取成功"
        docker run --rm hello-world
    else
        print_error "❌ 镜像拉取失败"
        return 1
    fi
}

# 测试登录
test_login() {
    print_header "测试 Docker Hub 登录"
    
    if [ -z "$DOCKER_USERNAME" ] || [ -z "$DOCKER_PASSWORD" ]; then
        print_warning "未设置 DOCKER_USERNAME 或 DOCKER_PASSWORD 环境变量"
        print_info "使用方法："
        print_info "export DOCKER_USERNAME=your_username"
        print_info "export DOCKER_PASSWORD=your_password"
        print_info "./test-docker-hub.sh login"
        return 0
    fi
    
    print_info "尝试登录 Docker Hub..."
    if echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin > /dev/null 2>&1; then
        print_info "✅ Docker Hub 登录成功"
        docker logout > /dev/null 2>&1
    else
        print_error "❌ Docker Hub 登录失败"
        return 1
    fi
}

# 主函数
main() {
    case "${1:-all}" in
        "network")
            test_network
            ;;
        "hub")
            test_docker_hub
            ;;
        "mirrors")
            test_mirrors
            ;;
        "config")
            test_docker_config
            ;;
        "pull")
            test_pull
            ;;
        "login")
            test_login
            ;;
        "all")
            test_network
            test_docker_hub
            test_mirrors
            test_docker_config
            test_pull
            ;;
        "help")
            echo "使用方法: $0 [选项]"
            echo "选项:"
            echo "  network  - 测试基础网络"
            echo "  hub      - 测试 Docker Hub 连接"
            echo "  mirrors  - 测试镜像加速器"
            echo "  config   - 检查 Docker 配置"
            echo "  pull     - 测试拉取镜像"
            echo "  login    - 测试登录（需要设置环境变量）"
            echo "  all      - 运行所有测试（默认）"
            echo "  help     - 显示帮助"
            ;;
        *)
            print_error "未知选项: $1"
            echo "使用 $0 help 查看帮助"
            exit 1
            ;;
    esac
}

main "$@" 