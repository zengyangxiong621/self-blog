# 首屏渲染时间优化（FP、FCP、LCP）

首屏渲染时间是衡量用户首次看到页面内容的关键性能指标，直接影响用户体验和页面转化率。

## 核心指标详解

### 1. FP（First Paint，首次绘制）
- **定义**：浏览器首次在屏幕上绘制像素的时间点，通常是背景色、边框等非内容元素
- **意义**：反映页面开始有视觉反馈的时间
- **获取方式**：
```javascript
// 获取 FP 时间
const fpEntry = performance.getEntriesByType('paint')
  .find(entry => entry.name === 'first-paint');
console.log('FP时间:', fpEntry?.startTime);
```

### 2. FCP（First Contentful Paint，首次内容绘制）
- **定义**：浏览器首次绘制出内容（如文本、图片、SVG等）的时间点
- **意义**：用户首次看到实际内容的时间，比 FP 更有意义
- **获取方式**：
```javascript
// 获取 FCP 时间
const fcpEntry = performance.getEntriesByType('paint')
  .find(entry => entry.name === 'first-contentful-paint');
console.log('FCP时间:', fcpEntry?.startTime);
```

### 3. LCP（Largest Contentful Paint，最大内容绘制）
- **定义**：页面主视区内最大内容元素（如大图、主标题）渲染完成的时间点
- **意义**：衡量页面主要内容对用户可见的速度，是核心 Web Vitals 指标
- **获取方式**：
```javascript
// 监听 LCP
const observer = new PerformanceObserver((entryList) => {
  for (const entry of entryList.getEntries()) {
    if (entry.entryType === 'largest-contentful-paint') {
      console.log('LCP时间:', entry.startTime);
      console.log('LCP元素:', entry.element);
    }
  }
});
observer.observe({ type: 'largest-contentful-paint', buffered: true });
```

## 性能标准

### Google 推荐标准
```javascript
const performanceStandards = {
  FCP: {
    good: '< 1.8s',
    needsImprovement: '1.8s - 3.0s',
    poor: '> 3.0s'
  },
  LCP: {
    good: '< 2.5s',
    needsImprovement: '2.5s - 4.0s', 
    poor: '> 4.0s'
  }
};
```

## 优化策略

### 1. 减少阻塞渲染的资源

#### CSS 优化
```html
<!-- ❌ 阻塞渲染的 CSS -->
<link rel="stylesheet" href="large-styles.css">

<!-- ✅ 优化后的 CSS -->
<link rel="stylesheet" href="critical.css">
<link rel="preload" href="non-critical.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="non-critical.css"></noscript>
```

#### JavaScript 优化
```html
<!-- ❌ 阻塞渲染的 JS -->
<script src="large-script.js"></script>

<!-- ✅ 优化后的 JS -->
<script src="critical.js"></script>
<script src="non-critical.js" defer></script>
<script src="analytics.js" async></script>
```

### 2. 关键路径 CSS 内联
```html
<!DOCTYPE html>
<html>
<head>
  <!-- 内联关键 CSS -->
  <style>
    /* 首屏关键样式 */
    .header { background: #fff; height: 60px; }
    .hero { min-height: 400px; background: #f5f5f5; }
    .loading { display: flex; justify-content: center; }
  </style>
  
  <!-- 非关键 CSS 异步加载 -->
  <link rel="preload" href="/css/non-critical.css" as="style" onload="this.rel='stylesheet'">
</head>
</html>
```

### 3. 图片优化

#### 响应式图片
```html
<!-- 响应式图片 -->
<picture>
  <source media="(max-width: 768px)" srcset="hero-mobile.webp" type="image/webp">
  <source media="(max-width: 768px)" srcset="hero-mobile.jpg">
  <source srcset="hero-desktop.webp" type="image/webp">
  <img src="hero-desktop.jpg" alt="Hero Image" loading="lazy">
</picture>
```

#### 图片预加载
```javascript
// 预加载关键图片
const preloadImage = (src) => {
  const link = document.createElement('link');
  link.rel = 'preload';
  link.as = 'image';
  link.href = src;
  document.head.appendChild(link);
};

// 预加载首屏关键图片
preloadImage('/images/hero-banner.jpg');
preloadImage('/images/logo.png');
```

### 4. 资源优先级控制

#### Resource Hints
```html
<!-- DNS 预解析 -->
<link rel="dns-prefetch" href="//fonts.googleapis.com">
<link rel="dns-prefetch" href="//api.example.com">

<!-- 预连接 -->
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- 预加载关键资源 -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/css/critical.css" as="style">

<!-- 预获取下一页资源 -->
<link rel="prefetch" href="/page2.html">
```

### 5. 服务端渲染优化

#### SSR 示例（Next.js）
```javascript
// pages/index.js
import { GetServerSideProps } from 'next';

export default function HomePage({ data }) {
  return (
    <div>
      <h1>首页</h1>
      <div>{data.content}</div>
    </div>
  );
}

// 服务端预渲染数据
export const getServerSideProps: GetServerSideProps = async () => {
  const data = await fetchCriticalData();
  
  return {
    props: {
      data
    }
  };
};
```

### 6. 代码分割与懒加载

#### 动态导入
```javascript
// 路由级别的代码分割
const HomePage = lazy(() => import('./pages/HomePage'));
const AboutPage = lazy(() => import('./pages/AboutPage'));

function App() {
  return (
    <Router>
      <Suspense fallback={<div>加载中...</div>}>
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/about" element={<AboutPage />} />
        </Routes>
      </Suspense>
    </Router>
  );
}
```

#### 组件懒加载
```javascript
// 非关键组件懒加载
const LazyComponent = lazy(() => 
  import('./components/HeavyComponent')
);

function App() {
  const [showHeavyComponent, setShowHeavyComponent] = useState(false);
  
  return (
    <div>
      <h1>首屏内容</h1>
      
      {showHeavyComponent && (
        <Suspense fallback={<div>加载中...</div>}>
          <LazyComponent />
        </Suspense>
      )}
      
      <button onClick={() => setShowHeavyComponent(true)}>
        加载更多内容
      </button>
    </div>
  );
}
```

## 性能监控

### 1. 实时监控代码
```javascript
// 性能监控工具
class PerformanceMonitor {
  constructor() {
    this.metrics = {};
    this.init();
  }
  
  init() {
    // 监控 FCP
    this.observeFCP();
    // 监控 LCP
    this.observeLCP();
    // 监控 CLS
    this.observeCLS();
  }
  
  observeFCP() {
    const observer = new PerformanceObserver((entryList) => {
      for (const entry of entryList.getEntries()) {
        if (entry.name === 'first-contentful-paint') {
          this.metrics.fcp = entry.startTime;
          this.reportMetric('FCP', entry.startTime);
        }
      }
    });
    observer.observe({ type: 'paint', buffered: true });
  }
  
  observeLCP() {
    const observer = new PerformanceObserver((entryList) => {
      const entries = entryList.getEntries();
      const lastEntry = entries[entries.length - 1];
      
      this.metrics.lcp = lastEntry.startTime;
      this.reportMetric('LCP', lastEntry.startTime);
    });
    observer.observe({ type: 'largest-contentful-paint', buffered: true });
  }
  
  reportMetric(name, value) {
    // 上报性能数据
    console.log(`${name}: ${value}ms`);
    
    // 发送到分析服务
    fetch('/api/performance', {
      method: 'POST',
      body: JSON.stringify({
        metric: name,
        value: value,
        url: window.location.href,
        userAgent: navigator.userAgent
      })
    });
  }
}

// 初始化监控
const monitor = new PerformanceMonitor();
```

### 2. 性能预算设置
```javascript
// 性能预算配置
const performanceBudget = {
  FCP: 1800, // 1.8s
  LCP: 2500, // 2.5s
  CLS: 0.1,  // 0.1
  FID: 100   // 100ms
};

// 检查性能是否超出预算
function checkPerformanceBudget(metrics) {
  const violations = [];
  
  Object.keys(performanceBudget).forEach(metric => {
    if (metrics[metric] > performanceBudget[metric]) {
      violations.push({
        metric,
        actual: metrics[metric],
        budget: performanceBudget[metric]
      });
    }
  });
  
  if (violations.length > 0) {
    console.warn('性能预算超标:', violations);
  }
  
  return violations;
}
```

## 分析工具

### 1. Chrome DevTools
```javascript
// 在控制台中分析性能
function analyzePerformance() {
  const navigation = performance.getEntriesByType('navigation')[0];
  const paint = performance.getEntriesByType('paint');
  
  console.log('页面加载时间:', navigation.loadEventEnd - navigation.fetchStart);
  console.log('DNS查询时间:', navigation.domainLookupEnd - navigation.domainLookupStart);
  console.log('TCP连接时间:', navigation.connectEnd - navigation.connectStart);
  console.log('请求响应时间:', navigation.responseEnd - navigation.requestStart);
  console.log('DOM解析时间:', navigation.domContentLoadedEventEnd - navigation.responseEnd);
  
  paint.forEach(entry => {
    console.log(`${entry.name}: ${entry.startTime}ms`);
  });
}

// 运行分析
analyzePerformance();
```

### 2. Lighthouse 自动化
```javascript
// lighthouse-config.js
module.exports = {
  extends: 'lighthouse:default',
  settings: {
    onlyAudits: [
      'first-contentful-paint',
      'largest-contentful-paint',
      'cumulative-layout-shift',
      'first-input-delay'
    ]
  },
  audits: [
    'first-contentful-paint',
    'largest-contentful-paint'
  ]
};
```

## 最佳实践总结

### 🎯 优先级排序
1. **关键渲染路径优化** - 减少阻塞资源
2. **关键 CSS 内联** - 避免额外的网络请求
3. **图片优化** - 使用现代格式和响应式加载
4. **资源预加载** - 提前获取关键资源
5. **代码分割** - 减少初始包大小

### 📊 监控指标
- **FCP < 1.8s** - 良好的首次内容绘制时间
- **LCP < 2.5s** - 良好的最大内容绘制时间
- **CLS < 0.1** - 良好的累积布局偏移
- **FID < 100ms** - 良好的首次输入延迟

### 🔧 持续优化
- 定期进行性能审计
- 监控真实用户数据（RUM）
- 设置性能预算和告警
- 在 CI/CD 中集成性能检查

通过系统性的首屏渲染优化，可以显著提升用户体验和页面转化率。 