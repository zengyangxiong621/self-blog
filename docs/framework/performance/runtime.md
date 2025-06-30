# 运行时性能优化

运行时性能优化关注的是应用程序在用户交互过程中的响应速度和流畅度。通过合理的优化策略，可以显著提升用户体验。

## 🎯 性能目标

### 核心指标
- **响应时间** < 100ms - 用户操作的即时反馈
- **动画帧率** ≥ 60fps - 流畅的视觉体验
- **内存使用** - 避免内存泄漏和过度消耗
- **CPU占用** - 合理的计算资源使用

### 用户感知
- **即时响应** - 点击、输入等操作的快速反馈
- **流畅动画** - 无卡顿的过渡效果
- **稳定运行** - 长时间使用不崩溃

## ⚡ JavaScript 性能优化

### 1. 算法优化

```javascript
// ❌ 低效的嵌套循环
function findCommonElements(arr1, arr2) {
  const result = [];
  for (let i = 0; i < arr1.length; i++) {
    for (let j = 0; j < arr2.length; j++) {
      if (arr1[i] === arr2[j]) {
        result.push(arr1[i]);
      }
    }
  }
  return result;
}

// ✅ 使用 Set 优化查找
function findCommonElementsOptimized(arr1, arr2) {
  const set2 = new Set(arr2);
  return arr1.filter(item => set2.has(item));
}

// ✅ 使用 Map 进行计数
function countFrequency(arr) {
  const frequency = new Map();
  for (const item of arr) {
    frequency.set(item, (frequency.get(item) || 0) + 1);
  }
  return frequency;
}
```

### 2. 防抖和节流

```javascript
// 防抖：延迟执行，适用于搜索输入
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 节流：限制执行频率，适用于滚动事件
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// 使用示例
const searchInput = document.getElementById('search');
const handleSearch = debounce((e) => {
  console.log('搜索:', e.target.value);
}, 300);

searchInput.addEventListener('input', handleSearch);

const handleScroll = throttle(() => {
  console.log('滚动位置:', window.scrollY);
}, 16); // 60fps

window.addEventListener('scroll', handleScroll);
```

### 3. 异步处理优化

```javascript
// ❌ 阻塞主线程的大量计算
function heavyComputation(data) {
  let result = 0;
  for (let i = 0; i < data.length; i++) {
    result += Math.sqrt(data[i]) * Math.sin(data[i]);
  }
  return result;
}

// ✅ 使用 Web Workers 处理重计算
// main.js
const worker = new Worker('worker.js');

function heavyComputationAsync(data) {
  return new Promise((resolve) => {
    worker.postMessage(data);
    worker.onmessage = (e) => resolve(e.data);
  });
}

// worker.js
self.onmessage = function(e) {
  const data = e.data;
  let result = 0;
  for (let i = 0; i < data.length; i++) {
    result += Math.sqrt(data[i]) * Math.sin(data[i]);
  }
  self.postMessage(result);
};

// ✅ 分片处理大数据
function processLargeDataset(data, chunkSize = 1000) {
  return new Promise((resolve) => {
    let index = 0;
    const results = [];

    function processChunk() {
      const chunk = data.slice(index, index + chunkSize);
      
      // 处理当前块
      const chunkResult = chunk.map(item => item * 2);
      results.push(...chunkResult);
      
      index += chunkSize;

      if (index < data.length) {
        // 使用 setTimeout 让出主线程
        setTimeout(processChunk, 0);
      } else {
        resolve(results);
      }
    }

    processChunk();
  });
}
```

## 🎨 DOM 操作优化

### 1. 批量 DOM 操作

```javascript
// ❌ 频繁的 DOM 操作
function updateListSlow(items) {
  const list = document.getElementById('list');
  list.innerHTML = ''; // 触发重排
  
  items.forEach(item => {
    const li = document.createElement('li');
    li.textContent = item;
    list.appendChild(li); // 每次都触发重排
  });
}

// ✅ 使用 DocumentFragment 批量操作
function updateListFast(items) {
  const list = document.getElementById('list');
  const fragment = document.createDocumentFragment();
  
  items.forEach(item => {
    const li = document.createElement('li');
    li.textContent = item;
    fragment.appendChild(li);
  });
  
  list.innerHTML = '';
  list.appendChild(fragment); // 只触发一次重排
}

// ✅ 使用 innerHTML 批量更新
function updateListHTML(items) {
  const list = document.getElementById('list');
  const html = items.map(item => `<li>${item}</li>`).join('');
  list.innerHTML = html; // 只触发一次重排
}
```

### 2. 虚拟滚动

```javascript
class VirtualList {
  constructor(container, items, itemHeight) {
    this.container = container;
    this.items = items;
    this.itemHeight = itemHeight;
    this.containerHeight = container.clientHeight;
    this.visibleCount = Math.ceil(this.containerHeight / itemHeight) + 1;
    this.startIndex = 0;
    
    this.render();
    this.bindEvents();
  }

  render() {
    const endIndex = Math.min(
      this.startIndex + this.visibleCount,
      this.items.length
    );
    
    const visibleItems = this.items.slice(this.startIndex, endIndex);
    
    // 创建可见项目
    const html = visibleItems.map((item, index) => `
      <div class="list-item" style="
        position: absolute;
        top: ${(this.startIndex + index) * this.itemHeight}px;
        height: ${this.itemHeight}px;
        width: 100%;
      ">
        ${item}
      </div>
    `).join('');
    
    // 设置容器高度和内容
    this.container.style.height = `${this.items.length * this.itemHeight}px`;
    this.container.style.position = 'relative';
    this.container.innerHTML = html;
  }

  bindEvents() {
    this.container.addEventListener('scroll', () => {
      const scrollTop = this.container.scrollTop;
      const newStartIndex = Math.floor(scrollTop / this.itemHeight);
      
      if (newStartIndex !== this.startIndex) {
        this.startIndex = newStartIndex;
        this.render();
      }
    });
  }
}

// 使用示例
const items = Array.from({ length: 10000 }, (_, i) => `Item ${i + 1}`);
const virtualList = new VirtualList(
  document.getElementById('virtual-list'),
  items,
  50
);
```

### 3. 事件委托

```javascript
// ❌ 为每个元素绑定事件
function bindEventsToItems() {
  const items = document.querySelectorAll('.list-item');
  items.forEach(item => {
    item.addEventListener('click', handleItemClick);
  });
}

// ✅ 使用事件委托
function bindEventToContainer() {
  const container = document.getElementById('list');
  container.addEventListener('click', (e) => {
    if (e.target.classList.contains('list-item')) {
      handleItemClick(e);
    }
  });
}

function handleItemClick(e) {
  console.log('点击了项目:', e.target.textContent);
}
```

## 🖼️ 渲染性能优化

### 1. CSS 优化

```css
/* ✅ 使用 transform 代替改变位置属性 */
.element {
  /* 避免使用 left/top，会触发重排 */
  /* left: 100px; */
  
  /* 使用 transform，只触发重绘 */
  transform: translateX(100px);
}

/* ✅ 启用硬件加速 */
.accelerated {
  transform: translateZ(0); /* 或 will-change: transform */
  backface-visibility: hidden;
}

/* ✅ 优化动画性能 */
@keyframes slideIn {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0);
  }
}

.slide-animation {
  animation: slideIn 0.3s ease-out;
  will-change: transform; /* 提示浏览器优化 */
}

/* ✅ 避免复杂的选择器 */
/* 避免 */
div > ul > li:nth-child(odd) + li span.highlight {
  color: red;
}

/* 推荐 */
.highlight-span {
  color: red;
}
```

### 2. 重排和重绘优化

```javascript
// ❌ 导致多次重排的代码
function badLayout() {
  const element = document.getElementById('box');
  
  element.style.width = '200px';    // 重排
  element.style.height = '200px';   // 重排
  element.style.padding = '10px';   // 重排
  element.style.margin = '5px';     // 重排
}

// ✅ 批量样式更新
function goodLayout() {
  const element = document.getElementById('box');
  
  // 方法1: 使用 cssText
  element.style.cssText = `
    width: 200px;
    height: 200px;
    padding: 10px;
    margin: 5px;
  `;
  
  // 方法2: 使用 CSS 类
  element.className = 'optimized-box';
}

// ✅ 读写分离
function optimizedDOMAccess() {
  const elements = document.querySelectorAll('.item');
  
  // 先读取所有值
  const widths = Array.from(elements).map(el => el.offsetWidth);
  
  // 再批量写入
  elements.forEach((el, index) => {
    el.style.width = `${widths[index] * 1.1}px`;
  });
}
```

## 💾 内存管理

### 1. 避免内存泄漏

```javascript
// ❌ 可能导致内存泄漏的代码
class ComponentWithLeak {
  constructor() {
    this.data = new Array(1000000).fill('data');
    
    // 未清理的定时器
    this.timer = setInterval(() => {
      console.log('定时执行');
    }, 1000);
    
    // 未清理的事件监听器
    window.addEventListener('resize', this.handleResize);
  }
  
  handleResize = () => {
    console.log('窗口大小改变');
  }
}

// ✅ 正确的内存管理
class ComponentWithoutLeak {
  constructor() {
    this.data = new Array(1000000).fill('data');
    this.timer = null;
    this.handleResize = this.handleResize.bind(this);
  }
  
  init() {
    this.timer = setInterval(() => {
      console.log('定时执行');
    }, 1000);
    
    window.addEventListener('resize', this.handleResize);
  }
  
  handleResize() {
    console.log('窗口大小改变');
  }
  
  destroy() {
    // 清理定时器
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
    
    // 移除事件监听器
    window.removeEventListener('resize', this.handleResize);
    
    // 清理大对象
    this.data = null;
  }
}
```

### 2. 对象池模式

```javascript
// 对象池减少垃圾回收压力
class ObjectPool {
  constructor(createFn, resetFn, initialSize = 10) {
    this.createFn = createFn;
    this.resetFn = resetFn;
    this.pool = [];
    
    // 预创建对象
    for (let i = 0; i < initialSize; i++) {
      this.pool.push(this.createFn());
    }
  }
  
  acquire() {
    if (this.pool.length > 0) {
      return this.pool.pop();
    }
    return this.createFn();
  }
  
  release(obj) {
    this.resetFn(obj);
    this.pool.push(obj);
  }
}

// 使用示例：粒子系统
const particlePool = new ObjectPool(
  () => ({ x: 0, y: 0, vx: 0, vy: 0, life: 0 }),
  (particle) => {
    particle.x = 0;
    particle.y = 0;
    particle.vx = 0;
    particle.vy = 0;
    particle.life = 0;
  },
  100
);

function createParticle(x, y) {
  const particle = particlePool.acquire();
  particle.x = x;
  particle.y = y;
  particle.vx = Math.random() * 4 - 2;
  particle.vy = Math.random() * 4 - 2;
  particle.life = 100;
  return particle;
}

function removeParticle(particle) {
  particlePool.release(particle);
}
```

## 📊 性能监控

### 1. 性能指标收集

```javascript
class PerformanceMonitor {
  constructor() {
    this.metrics = new Map();
    this.observers = [];
    this.init();
  }
  
  init() {
    // 监控长任务
    this.observeLongTasks();
    
    // 监控布局偏移
    this.observeLayoutShift();
    
    // 监控首次输入延迟
    this.observeFirstInputDelay();
  }
  
  observeLongTasks() {
    if ('PerformanceObserver' in window) {
      const observer = new PerformanceObserver((list) => {
        list.getEntries().forEach((entry) => {
          if (entry.duration > 50) {
            console.warn(`长任务检测: ${entry.duration}ms`);
            this.recordMetric('longTask', entry.duration);
          }
        });
      });
      
      observer.observe({ entryTypes: ['longtask'] });
      this.observers.push(observer);
    }
  }
  
  observeLayoutShift() {
    if ('PerformanceObserver' in window) {
      const observer = new PerformanceObserver((list) => {
        let clsValue = 0;
        list.getEntries().forEach((entry) => {
          if (!entry.hadRecentInput) {
            clsValue += entry.value;
          }
        });
        
        if (clsValue > 0) {
          this.recordMetric('cls', clsValue);
        }
      });
      
      observer.observe({ entryTypes: ['layout-shift'] });
      this.observers.push(observer);
    }
  }
  
  observeFirstInputDelay() {
    if ('PerformanceObserver' in window) {
      const observer = new PerformanceObserver((list) => {
        list.getEntries().forEach((entry) => {
          const fid = entry.processingStart - entry.startTime;
          this.recordMetric('fid', fid);
        });
      });
      
      observer.observe({ entryTypes: ['first-input'] });
      this.observers.push(observer);
    }
  }
  
  recordMetric(name, value) {
    if (!this.metrics.has(name)) {
      this.metrics.set(name, []);
    }
    this.metrics.get(name).push({
      value,
      timestamp: Date.now()
    });
  }
  
  getMetrics() {
    const result = {};
    this.metrics.forEach((values, name) => {
      result[name] = {
        count: values.length,
        avg: values.reduce((sum, item) => sum + item.value, 0) / values.length,
        max: Math.max(...values.map(item => item.value)),
        min: Math.min(...values.map(item => item.value))
      };
    });
    return result;
  }
  
  destroy() {
    this.observers.forEach(observer => observer.disconnect());
    this.observers = [];
    this.metrics.clear();
  }
}

// 使用示例
const monitor = new PerformanceMonitor();

// 定期上报性能数据
setInterval(() => {
  const metrics = monitor.getMetrics();
  console.log('性能指标:', metrics);
  
  // 发送到分析服务
  // fetch('/api/performance', {
  //   method: 'POST',
  //   body: JSON.stringify(metrics)
  // });
}, 30000);
```

### 2. 自定义性能标记

```javascript
// 性能标记工具
class PerformanceMarker {
  static mark(name) {
    performance.mark(name);
  }
  
  static measure(name, startMark, endMark) {
    performance.measure(name, startMark, endMark);
    const measure = performance.getEntriesByName(name, 'measure')[0];
    console.log(`${name}: ${measure.duration.toFixed(2)}ms`);
    return measure.duration;
  }
  
  static time(label) {
    console.time(label);
  }
  
  static timeEnd(label) {
    console.timeEnd(label);
  }
  
  static async timeAsync(label, asyncFn) {
    const start = performance.now();
    try {
      const result = await asyncFn();
      const duration = performance.now() - start;
      console.log(`${label}: ${duration.toFixed(2)}ms`);
      return result;
    } catch (error) {
      const duration = performance.now() - start;
      console.log(`${label} (错误): ${duration.toFixed(2)}ms`);
      throw error;
    }
  }
}

// 使用示例
async function fetchUserData() {
  PerformanceMarker.mark('fetch-start');
  
  const data = await PerformanceMarker.timeAsync('API请求', async () => {
    const response = await fetch('/api/user');
    return response.json();
  });
  
  PerformanceMarker.mark('fetch-end');
  PerformanceMarker.measure('总获取时间', 'fetch-start', 'fetch-end');
  
  return data;
}
```

## 🛠️ 性能优化工具

### 1. 性能分析工具
- **Chrome DevTools Performance** - 详细的性能分析
- **Lighthouse** - 综合性能评估
- **WebPageTest** - 网页性能测试
- **React DevTools Profiler** - React 组件性能分析

### 2. 代码分析工具
```javascript
// Bundle 分析
// webpack-bundle-analyzer
npm install --save-dev webpack-bundle-analyzer

// 在 webpack 配置中添加
const BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;

module.exports = {
  plugins: [
    new BundleAnalyzerPlugin({
      analyzerMode: 'static',
      openAnalyzer: false,
      reportFilename: 'bundle-report.html'
    })
  ]
};
```

## 🎯 最佳实践总结

### 1. JavaScript 优化
- ✅ 使用高效的数据结构和算法
- ✅ 避免不必要的计算和重复操作
- ✅ 合理使用防抖和节流
- ✅ 将重计算任务移到 Web Workers
- ✅ 及时清理事件监听器和定时器

### 2. DOM 操作优化
- ✅ 批量 DOM 操作，减少重排重绘
- ✅ 使用事件委托减少事件监听器数量
- ✅ 实现虚拟滚动处理大量数据
- ✅ 使用 DocumentFragment 进行批量插入

### 3. 渲染性能优化
- ✅ 优先使用 transform 和 opacity 进行动画
- ✅ 合理使用 will-change 属性
- ✅ 避免复杂的 CSS 选择器
- ✅ 减少不必要的重排和重绘

### 4. 内存管理
- ✅ 及时清理不再使用的对象引用
- ✅ 使用对象池减少垃圾回收压力
- ✅ 避免闭包中的内存泄漏
- ✅ 定期监控内存使用情况

通过系统性的运行时性能优化，可以显著提升应用的响应速度和用户体验！🚀 