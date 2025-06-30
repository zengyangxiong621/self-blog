# 资源加载优化

资源加载优化是前端性能优化的重要组成部分。通过合理的资源管理策略，可以显著提升网页的加载速度和用户体验。

## 🎯 优化目标

### 核心指标
- **FCP (First Contentful Paint)** - 首次内容绘制时间
- **LCP (Largest Contentful Paint)** - 最大内容绘制时间
- **TTI (Time to Interactive)** - 可交互时间
- **CLS (Cumulative Layout Shift)** - 累积布局偏移

### 优化策略
1. **减少请求数量** - 合并资源，减少HTTP请求
2. **压缩资源大小** - 文件压缩，去除冗余
3. **优化加载顺序** - 关键资源优先加载
4. **利用缓存机制** - 减少重复请求

## 🏗️ 资源类型优化

### 1. HTML优化

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- DNS预解析 -->
  <link rel="dns-prefetch" href="//cdn.example.com">
  <link rel="dns-prefetch" href="//api.example.com">
  
  <!-- 预连接 -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  
  <!-- 关键CSS内联 -->
  <style>
    /* 首屏关键样式 */
    body { margin: 0; font-family: -apple-system, sans-serif; }
    .header { height: 60px; background: #fff; }
  </style>
  
  <!-- 非关键CSS异步加载 -->
  <link rel="preload" href="/css/main.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
  <noscript><link rel="stylesheet" href="/css/main.css"></noscript>
  
  <!-- 资源预加载 -->
  <link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preload" href="/js/critical.js" as="script">
</head>
<body>
  <!-- 内容 -->
  
  <!-- JavaScript延迟加载 -->
  <script src="/js/critical.js"></script>
  <script defer src="/js/main.js"></script>
  <script async src="/js/analytics.js"></script>
</body>
</html>
```

### 2. CSS优化

```css
/* 1. 使用CSS压缩 */
/* 原始代码 */
.button {
  background-color: #007acc;
  border: 1px solid #005a9e;
  border-radius: 4px;
  color: white;
  padding: 8px 16px;
}

/* 压缩后 */
.button{background-color:#007acc;border:1px solid #005a9e;border-radius:4px;color:white;padding:8px 16px}

/* 2. 移除未使用的CSS */
/* 使用PurgeCSS等工具自动移除 */

/* 3. 关键路径CSS内联 */
/* 将首屏样式直接写在HTML中 */

/* 4. 使用CSS Sprites */
.icon {
  background-image: url('/images/sprites.png');
  background-repeat: no-repeat;
}

.icon-home { background-position: 0 0; }
.icon-user { background-position: -20px 0; }
.icon-settings { background-position: -40px 0; }
```

### 3. JavaScript优化

```javascript
// 1. 代码分割
// 使用动态导入实现按需加载
async function loadModule() {
  const { default: heavyModule } = await import('./heavy-module.js');
  return heavyModule;
}

// 2. Tree Shaking
// 只导入需要的函数
import { debounce } from 'lodash-es';
// 而不是
// import _ from 'lodash';

// 3. 懒加载组件
class LazyComponent {
  static async load() {
    const module = await import('./component.js');
    return module.default;
  }
}

// 4. Service Worker缓存
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .then(registration => {
      console.log('SW registered: ', registration);
    })
    .catch(registrationError => {
      console.log('SW registration failed: ', registrationError);
    });
}

// 5. 预加载关键资源
function preloadResource(url, type) {
  const link = document.createElement('link');
  link.rel = 'preload';
  link.href = url;
  link.as = type;
  document.head.appendChild(link);
}

// 预加载下一页面的资源
preloadResource('/page2.html', 'document');
preloadResource('/js/page2.js', 'script');
```

### 4. 图片优化

```html
<!-- 1. 响应式图片 -->
<picture>
  <source media="(min-width: 800px)" srcset="large.webp" type="image/webp">
  <source media="(min-width: 800px)" srcset="large.jpg">
  <source media="(min-width: 400px)" srcset="medium.webp" type="image/webp">
  <source media="(min-width: 400px)" srcset="medium.jpg">
  <img src="small.jpg" alt="描述" loading="lazy">
</picture>

<!-- 2. 懒加载 -->
<img src="placeholder.jpg" 
     data-src="actual-image.jpg" 
     alt="描述" 
     loading="lazy"
     class="lazy-image">

<!-- 3. 现代格式 -->
<picture>
  <source srcset="image.avif" type="image/avif">
  <source srcset="image.webp" type="image/webp">
  <img src="image.jpg" alt="描述">
</picture>
```

```javascript
// 图片懒加载实现
class LazyImageLoader {
  constructor() {
    this.images = document.querySelectorAll('img[data-src]');
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this));
    this.init();
  }

  init() {
    this.images.forEach(img => {
      this.observer.observe(img);
    });
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        this.loadImage(img);
        this.observer.unobserve(img);
      }
    });
  }

  loadImage(img) {
    const src = img.dataset.src;
    if (src) {
      img.src = src;
      img.removeAttribute('data-src');
      img.classList.add('loaded');
    }
  }
}

// 使用
new LazyImageLoader();
```

## 🚀 加载策略

### 1. 资源优先级

```html
<!-- 高优先级：关键资源 -->
<link rel="preload" href="/css/critical.css" as="style">
<link rel="preload" href="/js/critical.js" as="script">

<!-- 中优先级：重要资源 -->
<link rel="prefetch" href="/css/main.css">
<link rel="prefetch" href="/js/main.js">

<!-- 低优先级：可选资源 -->
<link rel="prefetch" href="/images/hero.jpg">
<link rel="prefetch" href="/js/analytics.js">
```

### 2. 代码分割策略

```javascript
// webpack配置
module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        // 第三方库单独打包
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
          priority: 10
        },
        // 公共代码提取
        common: {
          name: 'common',
          minChunks: 2,
          chunks: 'all',
          priority: 5
        }
      }
    }
  }
};

// 路由级代码分割
const routes = [
  {
    path: '/',
    component: () => import('./pages/Home.vue')
  },
  {
    path: '/about',
    component: () => import('./pages/About.vue')
  },
  {
    path: '/contact',
    component: () => import('./pages/Contact.vue')
  }
];
```

### 3. 渐进式加载

```javascript
class ProgressiveLoader {
  constructor() {
    this.loadQueue = [];
    this.isLoading = false;
  }

  // 添加到加载队列
  add(resource) {
    this.loadQueue.push(resource);
    this.processQueue();
  }

  // 处理加载队列
  async processQueue() {
    if (this.isLoading || this.loadQueue.length === 0) return;

    this.isLoading = true;

    while (this.loadQueue.length > 0) {
      const resource = this.loadQueue.shift();
      await this.loadResource(resource);
      
      // 避免阻塞主线程
      await this.sleep(10);
    }

    this.isLoading = false;
  }

  // 加载单个资源
  loadResource(resource) {
    return new Promise((resolve, reject) => {
      if (resource.type === 'script') {
        const script = document.createElement('script');
        script.src = resource.url;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
      } else if (resource.type === 'style') {
        const link = document.createElement('link');
        link.rel = 'stylesheet';
        link.href = resource.url;
        link.onload = resolve;
        link.onerror = reject;
        document.head.appendChild(link);
      }
    });
  }

  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// 使用示例
const loader = new ProgressiveLoader();

// 优先加载关键资源
loader.add({ type: 'style', url: '/css/critical.css' });
loader.add({ type: 'script', url: '/js/critical.js' });

// 后续加载次要资源
setTimeout(() => {
  loader.add({ type: 'style', url: '/css/main.css' });
  loader.add({ type: 'script', url: '/js/main.js' });
}, 1000);
```

## 📦 构建优化

### 1. Webpack优化配置

```javascript
const path = require('path');
const TerserPlugin = require('terser-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

module.exports = {
  mode: 'production',
  
  // 入口点优化
  entry: {
    main: './src/index.js',
    vendor: ['react', 'react-dom', 'lodash']
  },

  // 输出优化
  output: {
    filename: '[name].[contenthash:8].js',
    chunkFilename: '[name].[contenthash:8].chunk.js',
    path: path.resolve(__dirname, 'dist'),
    clean: true
  },

  // 优化配置
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          compress: {
            drop_console: true, // 移除console
            drop_debugger: true, // 移除debugger
            pure_funcs: ['console.log'] // 移除特定函数调用
          }
        }
      }),
      new CssMinimizerPlugin()
    ],
    
    // 代码分割
    splitChunks: {
      chunks: 'all',
      maxInitialRequests: 10,
      maxAsyncRequests: 10,
      cacheGroups: {
        default: {
          minChunks: 2,
          priority: -20,
          reuseExistingChunk: true
        },
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          priority: -10,
          chunks: 'all'
        }
      }
    },
    
    // 运行时代码单独提取
    runtimeChunk: {
      name: 'runtime'
    }
  },

  // 模块配置
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
            plugins: ['@babel/plugin-syntax-dynamic-import']
          }
        }
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'postcss-loader'
        ]
      }
    ]
  },

  // 插件配置
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].[contenthash:8].css',
      chunkFilename: '[name].[contenthash:8].chunk.css'
    })
  ]
};
```

### 2. Vite优化配置

```javascript
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  // 构建配置
  build: {
    // 输出目录
    outDir: 'dist',
    
    // 资源内联阈值
    assetsInlineLimit: 4096,
    
    // CSS代码分割
    cssCodeSplit: true,
    
    // 生成source map
    sourcemap: false,
    
    // 压缩配置
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true,
        drop_debugger: true
      }
    },
    
    // Rollup配置
    rollupOptions: {
      // 入口点
      input: {
        main: resolve(__dirname, 'index.html'),
        admin: resolve(__dirname, 'admin.html')
      },
      
      // 输出配置
      output: {
        // 手动分包
        manualChunks: {
          vue: ['vue', 'vue-router'],
          utils: ['lodash-es', 'dayjs'],
          ui: ['element-plus']
        }
      }
    }
  },

  // 开发服务器配置
  server: {
    // 预热常用文件
    warmup: {
      clientFiles: ['./src/components/*.vue', './src/utils/*.js']
    }
  },

  // 依赖优化
  optimizeDeps: {
    include: ['vue', 'vue-router', 'element-plus'],
    exclude: ['@vueuse/core']
  }
});
```

## 🔄 缓存策略

### 1. HTTP缓存

```nginx
# Nginx配置示例
server {
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        add_header Vary Accept-Encoding;
    }
    
    location ~* \.(html)$ {
        expires -1;
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
    }
    
    # 启用Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;
}
```

### 2. Service Worker缓存

```javascript
// sw.js
const CACHE_NAME = 'my-app-v1';
const urlsToCache = [
  '/',
  '/css/main.css',
  '/js/main.js',
  '/images/logo.png'
];

// 安装事件
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        return cache.addAll(urlsToCache);
      })
  );
});

// 获取事件
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // 缓存命中，返回缓存资源
        if (response) {
          return response;
        }
        
        // 网络请求
        return fetch(event.request)
          .then(response => {
            // 检查是否为有效响应
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // 克隆响应
            const responseToCache = response.clone();
            
            // 添加到缓存
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          });
      })
  );
});
```

### 3. 浏览器缓存

```javascript
// 本地存储缓存
class LocalCache {
  constructor(prefix = 'cache_') {
    this.prefix = prefix;
  }

  set(key, data, ttl = 3600000) { // 默认1小时
    const item = {
      data,
      timestamp: Date.now(),
      ttl
    };
    localStorage.setItem(this.prefix + key, JSON.stringify(item));
  }

  get(key) {
    const item = localStorage.getItem(this.prefix + key);
    if (!item) return null;

    const parsed = JSON.parse(item);
    const now = Date.now();

    // 检查是否过期
    if (now - parsed.timestamp > parsed.ttl) {
      this.remove(key);
      return null;
    }

    return parsed.data;
  }

  remove(key) {
    localStorage.removeItem(this.prefix + key);
  }

  clear() {
    const keys = Object.keys(localStorage);
    keys.forEach(key => {
      if (key.startsWith(this.prefix)) {
        localStorage.removeItem(key);
      }
    });
  }
}

// 使用示例
const cache = new LocalCache('api_');

// 缓存API响应
async function fetchWithCache(url) {
  const cached = cache.get(url);
  if (cached) {
    return cached;
  }

  const response = await fetch(url);
  const data = await response.json();
  
  cache.set(url, data, 300000); // 缓存5分钟
  return data;
}
```

## 📊 性能监控

### 1. 性能指标收集

```javascript
// 性能监控类
class PerformanceMonitor {
  constructor() {
    this.metrics = {};
    this.init();
  }

  init() {
    // 监听页面加载完成
    window.addEventListener('load', () => {
      this.collectLoadMetrics();
    });

    // 监听资源加载
    this.observeResources();
    
    // 监听用户交互
    this.observeInteractions();
  }

  // 收集加载指标
  collectLoadMetrics() {
    const navigation = performance.getEntriesByType('navigation')[0];
    const paint = performance.getEntriesByType('paint');

    this.metrics = {
      // DNS查询时间
      dnsTime: navigation.domainLookupEnd - navigation.domainLookupStart,
      
      // TCP连接时间
      tcpTime: navigation.connectEnd - navigation.connectStart,
      
      // 请求响应时间
      requestTime: navigation.responseEnd - navigation.requestStart,
      
      // DOM解析时间
      domParseTime: navigation.domContentLoadedEventEnd - navigation.domLoading,
      
      // 资源加载时间
      resourceTime: navigation.loadEventEnd - navigation.domContentLoadedEventEnd,
      
      // 首次绘制时间
      fcp: paint.find(p => p.name === 'first-contentful-paint')?.startTime,
      
      // 总加载时间
      totalTime: navigation.loadEventEnd - navigation.navigationStart
    };

    this.reportMetrics();
  }

  // 监听资源加载
  observeResources() {
    const observer = new PerformanceObserver(list => {
      list.getEntries().forEach(entry => {
        if (entry.duration > 1000) { // 超过1秒的资源
          console.warn(`Slow resource: ${entry.name} took ${entry.duration}ms`);
        }
      });
    });

    observer.observe({ entryTypes: ['resource'] });
  }

  // 监听用户交互
  observeInteractions() {
    const observer = new PerformanceObserver(list => {
      list.getEntries().forEach(entry => {
        if (entry.processingStart - entry.startTime > 100) {
          console.warn(`Slow interaction: ${entry.name} took ${entry.duration}ms`);
        }
      });
    });

    observer.observe({ entryTypes: ['event'] });
  }

  // 上报指标
  reportMetrics() {
    // 发送到分析服务
    fetch('/api/performance', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(this.metrics)
    });
  }
}

// 启动监控
new PerformanceMonitor();
```

### 2. 资源加载分析

```javascript
// 资源加载分析器
class ResourceAnalyzer {
  analyze() {
    const resources = performance.getEntriesByType('resource');
    const analysis = {
      total: resources.length,
      byType: {},
      slowResources: [],
      totalSize: 0,
      totalTime: 0
    };

    resources.forEach(resource => {
      const type = this.getResourceType(resource);
      
      // 按类型统计
      if (!analysis.byType[type]) {
        analysis.byType[type] = { count: 0, size: 0, time: 0 };
      }
      
      analysis.byType[type].count++;
      analysis.byType[type].size += resource.transferSize || 0;
      analysis.byType[type].time += resource.duration;
      
      // 统计慢资源
      if (resource.duration > 1000) {
        analysis.slowResources.push({
          name: resource.name,
          duration: resource.duration,
          size: resource.transferSize
        });
      }
      
      analysis.totalSize += resource.transferSize || 0;
      analysis.totalTime += resource.duration;
    });

    return analysis;
  }

  getResourceType(resource) {
    const url = resource.name;
    if (url.includes('.js')) return 'script';
    if (url.includes('.css')) return 'stylesheet';
    if (url.match(/\.(png|jpg|jpeg|gif|webp|svg)$/)) return 'image';
    if (url.match(/\.(woff|woff2|ttf|eot)$/)) return 'font';
    return 'other';
  }

  generateReport() {
    const analysis = this.analyze();
    
    console.group('📊 Resource Loading Analysis');
    console.log(`Total resources: ${analysis.total}`);
    console.log(`Total size: ${(analysis.totalSize / 1024).toFixed(2)} KB`);
    console.log(`Total time: ${analysis.totalTime.toFixed(2)}ms`);
    
    console.group('By type:');
    Object.entries(analysis.byType).forEach(([type, stats]) => {
      console.log(`${type}: ${stats.count} files, ${(stats.size / 1024).toFixed(2)} KB, ${stats.time.toFixed(2)}ms`);
    });
    console.groupEnd();
    
    if (analysis.slowResources.length > 0) {
      console.group('⚠️ Slow resources:');
      analysis.slowResources.forEach(resource => {
        console.log(`${resource.name}: ${resource.duration.toFixed(2)}ms, ${(resource.size / 1024).toFixed(2)} KB`);
      });
      console.groupEnd();
    }
    
    console.groupEnd();
    
    return analysis;
  }
}

// 使用
const analyzer = new ResourceAnalyzer();
window.addEventListener('load', () => {
  setTimeout(() => analyzer.generateReport(), 1000);
});
```

## 🎯 最佳实践总结

### 1. 资源优化清单
- ✅ 启用Gzip/Brotli压缩
- ✅ 使用CDN分发静态资源
- ✅ 优化图片格式和大小
- ✅ 合并和压缩CSS/JS文件
- ✅ 移除未使用的代码
- ✅ 使用现代图片格式(WebP, AVIF)
- ✅ 实现懒加载
- ✅ 配置合适的缓存策略

### 2. 加载策略清单
- ✅ 关键资源优先加载
- ✅ 非关键资源延迟加载
- ✅ 使用预加载和预连接
- ✅ 实现代码分割
- ✅ 优化资源加载顺序
- ✅ 避免阻塞渲染的资源

### 3. 监控和分析
- ✅ 设置性能监控
- ✅ 定期分析加载性能
- ✅ 监控关键性能指标
- ✅ 建立性能预算
- ✅ 持续优化改进

通过系统性的资源加载优化，可以显著提升网站的性能表现和用户体验！🚀 