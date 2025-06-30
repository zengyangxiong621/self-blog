# JavaScript 内存管理

深入理解 JavaScript 的内存管理机制，包括内存分配、垃圾回收、内存泄漏防范等核心概念。

## 📚 内容概览

### 基础概念
- [内存介绍](./memory-introduction.md) - 内存的基本概念和分类
- [内存存储位置](./memory-storage.md) - 栈内存与堆内存的区别
- [可达性概念](./reachability.md) - 垃圾回收的核心原理

### 垃圾回收机制
- [内存回收机制](./garbage-collection.md) - 详解各种垃圾回收算法
- [标记清除算法](./mark-and-sweep.md) - 现代浏览器的主要回收策略
- [三色标记算法](./tricolor-marking.md) - 高效的并发垃圾回收

### 实践应用
- [函数作用域与内存](./function-scope-memory.md) - 函数执行与内存释放
- [内存泄漏防范](./memory-leak-prevention.md) - 常见内存泄漏场景及解决方案
- [主动内存管理](./manual-memory-management.md) - 何时需要手动释放内存

## 🎯 学习路径

### 第一阶段：基础理解
1. 了解内存的基本概念和分类
2. 掌握栈内存和堆内存的区别
3. 理解可达性的概念

### 第二阶段：深入机制
1. 学习垃圾回收的工作原理
2. 了解不同垃圾回收算法的特点
3. 掌握现代浏览器的内存管理策略

### 第三阶段：实践应用
1. 识别和解决内存泄漏问题
2. 优化代码的内存使用
3. 使用开发者工具进行内存分析

## 🔧 内存管理工具

### 浏览器开发者工具
- **Memory 面板** - 内存快照和堆分析
- **Performance 面板** - 内存使用时间线
- **Console** - 手动触发垃圾回收

### 代码示例
```javascript
// 监控内存使用
if (performance.memory) {
  console.log('已使用内存:', performance.memory.usedJSHeapSize);
  console.log('总内存限制:', performance.memory.totalJSHeapSize);
  console.log('内存限制:', performance.memory.jsHeapSizeLimit);
}

// 手动触发垃圾回收（仅在开发环境）
if (window.gc) {
  window.gc();
}
```

## 💡 最佳实践

### 1. 避免内存泄漏
```javascript
// ❌ 可能导致内存泄漏
function createLeak() {
  const largeData = new Array(1000000).fill('data');
  
  return function() {
    console.log(largeData.length); // 闭包引用大数据
  };
}

// ✅ 正确的内存管理
function createOptimized() {
  const largeData = new Array(1000000).fill('data');
  const length = largeData.length; // 只保存需要的数据
  
  return function() {
    console.log(length);
  };
}
```

### 2. 及时清理引用
```javascript
// ✅ 及时清理事件监听器
class Component {
  constructor() {
    this.handleClick = this.handleClick.bind(this);
  }
  
  mount() {
    document.addEventListener('click', this.handleClick);
  }
  
  unmount() {
    document.removeEventListener('click', this.handleClick);
  }
  
  handleClick() {
    // 处理点击事件
  }
}
```

### 3. 使用 WeakMap 和 WeakSet
```javascript
// ✅ 使用 WeakMap 避免内存泄漏
const privateData = new WeakMap();

class User {
  constructor(name) {
    privateData.set(this, { name, secret: 'password' });
  }
  
  getName() {
    return privateData.get(this).name;
  }
}

// 当 User 实例被回收时，WeakMap 中的数据也会被自动清理
```

## 🚀 性能优化技巧

### 1. 对象池模式
```javascript
class ObjectPool {
  constructor(createFn, resetFn) {
    this.createFn = createFn;
    this.resetFn = resetFn;
    this.pool = [];
  }
  
  acquire() {
    return this.pool.length > 0 ? this.pool.pop() : this.createFn();
  }
  
  release(obj) {
    this.resetFn(obj);
    this.pool.push(obj);
  }
}
```

### 2. 延迟加载
```javascript
// 延迟创建大对象
class LazyData {
  constructor() {
    this._data = null;
  }
  
  get data() {
    if (!this._data) {
      this._data = this.createLargeData();
    }
    return this._data;
  }
  
  createLargeData() {
    return new Array(1000000).fill(0).map((_, i) => ({ id: i, value: i * 2 }));
  }
}
```

通过系统学习 JavaScript 的内存管理，你将能够编写更高效、更稳定的代码！🎯 