#!/bin/bash

# 服务器环境配置脚本
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

# 检查系统
check_system() {
    print_header "检查系统信息"
    
    # 检查操作系统
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        print_info "操作系统: $NAME $VERSION"
        OS=$ID
    else
        print_error "无法识别操作系统"
        exit 1
    fi
    
    # 检查架构
    ARCH=$(uname -m)
    print_info "系统架构: $ARCH"
    
    # 检查是否为 root 用户
    if [ "$EUID" -eq 0 ]; then
        print_info "当前用户: root"
    else
        print_warning "当前用户不是 root，某些操作可能需要 sudo"
    fi
}

# 更新系统
update_system() {
    print_header "更新系统包"
    
    case $OS in
        ubuntu|debian)
            apt update
            apt upgrade -y
            apt install -y curl wget git vim htop
            ;;
        centos|rhel|fedora)
            if command -v dnf &> /dev/null; then
                dnf update -y
                dnf install -y curl wget git vim htop
            else
                yum update -y
                yum install -y curl wget git vim htop
            fi
            ;;
        *)
            print_warning "未知的操作系统，跳过系统更新"
            ;;
    esac
    
    print_info "系统更新完成"
}

# 安装 Docker
install_docker() {
    print_header "安装 Docker"
    
    # 检查 Docker 是否已安装
    if command -v docker &> /dev/null; then
        print_warning "Docker 已安装，版本: $(docker --version)"
        return 0
    fi
    
    # 使用官方安装脚本
    print_info "下载并执行 Docker 安装脚本..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    
    # 启动 Docker 服务
    systemctl start docker
    systemctl enable docker
    
    # 将当前用户添加到 docker 组（如果不是 root）
    if [ "$EUID" -ne 0 ]; then
        usermod -aG docker $USER
        print_warning "请重新登录以使 Docker 组权限生效"
    fi
    
    print_info "Docker 安装完成: $(docker --version)"
}

# 安装 Docker Compose
install_docker_compose() {
    print_header "安装 Docker Compose"
    
    # 检查是否已安装
    if command -v docker-compose &> /dev/null; then
        print_warning "Docker Compose 已安装，版本: $(docker-compose --version)"
        return 0
    fi
    
    # 获取最新版本
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    print_info "安装 Docker Compose $COMPOSE_VERSION"
    
    # 下载并安装
    curl -L "https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    print_info "Docker Compose 安装完成: $(docker-compose --version)"
}

# 配置防火墙
configure_firewall() {
    print_header "配置防火墙"
    
    # Ubuntu/Debian 使用 ufw
    if command -v ufw &> /dev/null; then
        print_info "配置 UFW 防火墙..."
        ufw --force enable
        ufw allow 22/tcp    # SSH
        ufw allow 80/tcp    # HTTP
        ufw allow 443/tcp   # HTTPS
        ufw status
    # CentOS/RHEL 使用 firewalld
    elif command -v firewall-cmd &> /dev/null; then
        print_info "配置 Firewalld 防火墙..."
        systemctl start firewalld
        systemctl enable firewalld
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
        firewall-cmd --list-all
    else
        print_warning "未找到防火墙工具，请手动配置"
    fi
}

# 创建目录结构
create_directories() {
    print_header "创建目录结构"
    
    # 创建应用目录
    mkdir -p /var/www/blog
    mkdir -p /var/log/blog
    mkdir -p /var/backups/blog
    
    # 设置权限
    chmod 755 /var/www/blog
    chmod 755 /var/log/blog
    chmod 755 /var/backups/blog
    
    print_info "目录结构创建完成"
    ls -la /var/www/
    ls -la /var/log/
}

# 安装 Nginx（备用）
install_nginx() {
    print_header "安装 Nginx（备用）"
    
    if command -v nginx &> /dev/null; then
        print_warning "Nginx 已安装，版本: $(nginx -v 2>&1)"
        return 0
    fi
    
    case $OS in
        ubuntu|debian)
            apt install -y nginx
            ;;
        centos|rhel|fedora)
            if command -v dnf &> /dev/null; then
                dnf install -y nginx
            else
                yum install -y nginx
            fi
            ;;
        *)
            print_warning "未知操作系统，跳过 Nginx 安装"
            return 0
            ;;
    esac
    
    # 启动但不启用（因为我们使用 Docker）
    systemctl start nginx
    print_info "Nginx 安装完成（作为备用）"
}

# 测试 Docker
test_docker() {
    print_header "测试 Docker 安装"
    
    print_info "运行 Hello World 容器..."
    docker run --rm hello-world
    
    print_info "Docker 测试成功！"
}

# 显示总结
show_summary() {
    print_header "安装总结"
    
    echo -e "${GREEN}✅ 系统信息:${NC}"
    echo "   - 操作系统: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
    echo "   - 架构: $(uname -m)"
    
    echo -e "${GREEN}✅ 已安装软件:${NC}"
    [ -x "$(command -v docker)" ] && echo "   - Docker: $(docker --version)"
    [ -x "$(command -v docker-compose)" ] && echo "   - Docker Compose: $(docker-compose --version)"
    [ -x "$(command -v nginx)" ] && echo "   - Nginx: $(nginx -v 2>&1)"
    
    echo -e "${GREEN}✅ 目录结构:${NC}"
    echo "   - /var/www/blog (应用目录)"
    echo "   - /var/log/blog (日志目录)"
    echo "   - /var/backups/blog (备份目录)"
    
    echo -e "${GREEN}✅ 下一步:${NC}"
    echo "   1. 配置 GitHub Secrets"
    echo "   2. 推送代码触发自动部署"
    echo "   3. 访问服务器 IP 查看网站"
    
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW}⚠️  注意: 请重新登录以使 Docker 组权限生效${NC}"
    fi
}

# 主函数
main() {
    print_header "博客服务器环境配置"
    
    case "${1:-full}" in
        "full")
            check_system
            update_system
            install_docker
            install_docker_compose
            configure_firewall
            create_directories
            install_nginx
            test_docker
            show_summary
            ;;
        "docker")
            check_system
            install_docker
            install_docker_compose
            test_docker
            ;;
        "firewall")
            configure_firewall
            ;;
        "dirs")
            create_directories
            ;;
        "test")
            test_docker
            ;;
        "help")
            echo "使用方法: $0 [选项]"
            echo "选项:"
            echo "  full     - 完整安装（默认）"
            echo "  docker   - 仅安装 Docker"
            echo "  firewall - 仅配置防火墙"
            echo "  dirs     - 仅创建目录"
            echo "  test     - 测试 Docker"
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