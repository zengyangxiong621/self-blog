# 内存存储位置

深入了解 JavaScript 中不同类型数据的存储位置，理解栈内存和堆内存的区别与应用。

## 🏗️ 内存结构概述

JavaScript 运行时的内存主要分为两个区域：

### 栈内存（Stack Memory）
- **存储内容**：基本数据类型的值、引用类型的地址
- **特点**：后进先出（LIFO）、访问速度快、空间有限
- **管理方式**：自动管理，函数执行完毕自动清理

### 堆内存（Heap Memory）  
- **存储内容**：引用类型的实际数据（对象、数组、函数等）
- **特点**：空间较大、访问速度相对较慢
- **管理方式**：需要垃圾回收机制清理

## 📊 数据类型存储详解

### 基本类型存储
```javascript
// 栈内存存储示例
let a = 10;        // 栈：a -> 10
let b = 'hello';   // 栈：b -> 'hello'  
let c = true;      // 栈：c -> true
let d = null;      // 栈：d -> null
let e = undefined; // 栈：e -> undefined

// 内存示意图
/*
栈内存：
┌──────┬───────────┐
│ a    │    10     │
├──────┼───────────┤
│ b    │  'hello'  │
├──────┼───────────┤
│ c    │   true    │
├──────┼───────────┤
│ d    │   null    │
├──────┼───────────┤
│ e    │ undefined │
└──────┴───────────┘
*/
```

### 引用类型存储
```javascript
// 堆内存存储示例
let obj = { name: 'Alice', age: 25 };
let arr = [1, 2, 3, 4, 5];
let func = function() { return 'hello'; };

// 内存示意图
/*
栈内存：                    堆内存：
┌──────┬──────────┐         ┌─────────────────────┐
│ obj  │ 0x001234 │────────→│ { name: 'Alice',    │
├──────┼──────────┤         │   age: 25 }         │
│ arr  │ 0x005678 │────────→├─────────────────────┤
├──────┼──────────┤         │ [1, 2, 3, 4, 5]     │
│ func │ 0x009ABC │────────→├─────────────────────┤
└──────┴──────────┘         │ function() {...}    │
                             └─────────────────────┘
*/
```

## 🔄 变量赋值过程

### 基本类型赋值
```javascript
let x = 100;
let y = x;  // 复制值到新的栈位置
y = 200;    // 只修改 y 的栈位置

console.log(x); // 100 (不受影响)
console.log(y); // 200

// 内存变化过程
/*
步骤1: let x = 100
栈: [x: 100]

步骤2: let y = x
栈: [x: 100, y: 100]  // 复制值

步骤3: y = 200  
栈: [x: 100, y: 200]  // 只修改 y
*/
```

### 引用类型赋值
```javascript
let obj1 = { value: 100 };
let obj2 = obj1;  // 复制引用地址
obj2.value = 200; // 通过引用修改堆中的数据

console.log(obj1.value); // 200 (被影响)
console.log(obj2.value); // 200

// 内存变化过程
/*
步骤1: let obj1 = { value: 100 }
栈: [obj1: 0x001]
堆: [0x001: { value: 100 }]

步骤2: let obj2 = obj1
栈: [obj1: 0x001, obj2: 0x001]  // 复制地址
堆: [0x001: { value: 100 }]

步骤3: obj2.value = 200
栈: [obj1: 0x001, obj2: 0x001]  // 地址不变
堆: [0x001: { value: 200 }]     // 堆中数据被修改
*/
```

## 🎯 函数调用与内存

### 函数执行栈
```javascript
function outer() {
  let a = 10;
  
  function inner() {
    let b = 20;
    return a + b;
  }
  
  return inner();
}

let result = outer();

// 执行栈变化
/*
1. 全局执行上下文
   栈: [result: undefined]

2. outer() 调用
   栈: [result: undefined] 
       [outer: a=10]

3. inner() 调用  
   栈: [result: undefined]
       [outer: a=10]
       [inner: b=20]

4. inner() 返回
   栈: [result: undefined]
       [outer: a=10]

5. outer() 返回
   栈: [result: 30]
*/
```

### 闭包的内存影响
```javascript
function createCounter() {
  let count = 0;  // 存储在堆中（被闭包引用）
  
  return function() {
    count++;
    return count;
  };
}

let counter = createCounter();

// 内存状态
/*
栈内存：
┌─────────┬──────────┐
│ counter │ 0x001234 │
└─────────┴──────────┘

堆内存：
┌─────────────────────────┐
│ 0x001234: function() {  │
│   // 闭包作用域链       │
│   count: 0              │
│   return ++count;       │
│ }                       │
└─────────────────────────┘
*/
```

## ⚡ 性能影响

### 栈操作性能
```javascript
// 栈操作很快
function stackOperations() {
  let start = performance.now();
  
  for (let i = 0; i < 1000000; i++) {
    let a = i;
    let b = a * 2;
    let c = b + 1;
  }
  
  let end = performance.now();
  console.log('栈操作时间:', end - start, 'ms');
}
```

### 堆操作性能
```javascript
// 堆操作相对较慢
function heapOperations() {
  let start = performance.now();
  
  for (let i = 0; i < 1000000; i++) {
    let obj = { value: i };
    obj.doubled = obj.value * 2;
    obj.incremented = obj.doubled + 1;
  }
  
  let end = performance.now();
  console.log('堆操作时间:', end - start, 'ms');
}
```

## 🔍 内存使用监控

### 监控内存使用
```javascript
function monitorMemory() {
  if (performance.memory) {
    const memory = performance.memory;
    
    console.log('已使用堆内存:', (memory.usedJSHeapSize / 1024 / 1024).toFixed(2), 'MB');
    console.log('总堆内存:', (memory.totalJSHeapSize / 1024 / 1024).toFixed(2), 'MB');
    console.log('堆内存限制:', (memory.jsHeapSizeLimit / 1024 / 1024).toFixed(2), 'MB');
  }
}

// 定期监控
setInterval(monitorMemory, 5000);
```

### 内存泄漏检测
```javascript
function detectMemoryLeak() {
  const initialMemory = performance.memory.usedJSHeapSize;
  
  // 执行可能导致内存泄漏的操作
  const objects = [];
  for (let i = 0; i < 100000; i++) {
    objects.push({ id: i, data: new Array(1000).fill(i) });
  }
  
  const afterMemory = performance.memory.usedJSHeapSize;
  const increase = (afterMemory - initialMemory) / 1024 / 1024;
  
  console.log('内存增长:', increase.toFixed(2), 'MB');
  
  // 清理引用
  objects.length = 0;
  
  // 建议垃圾回收
  if (window.gc) {
    window.gc();
  }
  
  setTimeout(() => {
    const finalMemory = performance.memory.usedJSHeapSize;
    const remaining = (finalMemory - initialMemory) / 1024 / 1024;
    console.log('清理后剩余:', remaining.toFixed(2), 'MB');
  }, 1000);
}
```

## 🛠️ 优化建议

### 减少堆内存分配
```javascript
// ❌ 频繁创建对象
function inefficient() {
  const results = [];
  for (let i = 0; i < 10000; i++) {
    results.push({ index: i, value: i * 2 });
  }
  return results;
}

// ✅ 重用对象
function efficient() {
  const results = [];
  const reusableObj = { index: 0, value: 0 };
  
  for (let i = 0; i < 10000; i++) {
    reusableObj.index = i;
    reusableObj.value = i * 2;
    results.push({ ...reusableObj }); // 只在需要时创建新对象
  }
  return results;
}
```

### 及时清理引用
```javascript
// ✅ 主动清理大对象
function processLargeData() {
  let largeArray = new Array(1000000).fill(0);
  
  // 处理数据
  const result = largeArray.reduce((sum, val) => sum + val, 0);
  
  // 清理引用
  largeArray = null;
  
  return result;
}
```

## 📚 总结

### 存储规则
- **基本类型**：值存储在栈内存
- **引用类型**：引用存储在栈内存，数据存储在堆内存
- **函数参数**：按值传递（包括引用值）

### 性能考虑
- **栈操作**：速度快，自动管理
- **堆操作**：速度较慢，需要垃圾回收
- **内存泄漏**：主要发生在堆内存

### 最佳实践
- 合理使用基本类型和引用类型
- 避免不必要的对象创建
- 及时清理不再使用的引用
- 监控内存使用情况

通过理解内存存储机制，你将能够编写更高效的 JavaScript 代码！🚀 