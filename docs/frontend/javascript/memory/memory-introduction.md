# JavaScript 内存详解

深入理解 JavaScript 的内存管理机制，包括内存结构、数据类型存储、垃圾回收等核心概念。

## 🏗️ 内存结构概述

JavaScript 的内存管理分为两个主要区域：

### 栈内存（Stack）
- 存储原始数据类型的值
- 存储引用类型的内存地址
- 遵循后进先出（LIFO）原则
- 访问速度快，但空间有限

### 堆内存（Heap）
- 存储引用类型的实际数据
- 空间较大，但访问速度相对较慢
- 通过引用地址访问

## 📊 数据类型的内存存储

### 原始类型（Primitive Types）

原始类型直接存储在栈内存中：

```javascript
let a = 10;
let b = a;  // 复制值
b = 20;

console.log(a); // 10 - 不受影响
console.log(b); // 20
```

**内存示意图：**
```
栈内存：
┌──────┬──────┐
│ a    │  10  │
├──────┼──────┤
│ b    │  20  │
└──────┴──────┘
```

### 引用类型（Reference Types）

引用类型在栈中存储地址，在堆中存储数据：

```javascript
let obj1 = { name: '张三', age: 25 };
let obj2 = obj1;  // 复制引用地址
obj2.age = 30;

console.log(obj1); // { name: '张三', age: 30 }
console.log(obj2); // { name: '张三', age: 30 }
```

**内存示意图：**
```
栈内存：                    堆内存：
┌──────┬──────────┐         ┌─────────────────────┐
│ obj1 │ 0x001234 │────────→│ { name:'张三',      │
├──────┼──────────┤         │   age: 30 }         │
│ obj2 │ 0x001234 │────────→│                     │
└──────┴──────────┘         └─────────────────────┘
```

## 🔄 函数参数传递

### 值传递（原始类型）

```javascript
function changePrimitive(x) {
    x = 100;
    console.log('函数内部 x =', x); // 100
}

let num = 50;
changePrimitive(num);
console.log('函数外部 num =', num); // 50 - 不受影响
```

### 引用传递（引用类型）

```javascript
function changeReference(obj) {
    obj.value = 200;
}

let myObj = { value: 100 };
changeReference(myObj);
console.log(myObj.value); // 200 - 被修改了
```

## 📋 浅拷贝 vs 深拷贝

### 浅拷贝

只复制对象的第一层属性：

```javascript
let original = {
    name: '李四',
    hobbies: ['读书', '游戏'],
    address: { city: '北京' }
};

// 方法1：Object.assign
let copy1 = Object.assign({}, original);

// 方法2：扩展运算符
let copy2 = { ...original };

// 修改嵌套对象会影响原对象
copy1.hobbies.push('运动');
copy1.address.city = '上海';

console.log(original.hobbies); // ['读书', '游戏', '运动']
console.log(original.address.city); // '上海'
```

### 深拷贝

递归复制所有层级的属性：

```javascript
function deepClone(obj) {
    if (obj === null || typeof obj !== 'object') return obj;
    if (obj instanceof Date) return new Date(obj);
    if (obj instanceof Array) return obj.map(item => deepClone(item));
    
    const clonedObj = {};
    for (let key in obj) {
        if (obj.hasOwnProperty(key)) {
            clonedObj[key] = deepClone(obj[key]);
        }
    }
    return clonedObj;
}

let original = {
    name: '王五',
    hobbies: ['电影', '音乐'],
    address: { city: '广州' }
};

let deepCopy = deepClone(original);
deepCopy.hobbies.push('旅游');
deepCopy.address.city = '深圳';

console.log(original.hobbies); // ['电影', '音乐'] - 不受影响
console.log(original.address.city); // '广州' - 不受影响
```

## 🔍 内存地址比较

```javascript
let arr1 = [1, 2, 3];
let arr2 = [1, 2, 3];
let arr3 = arr1;

console.log(arr1 == arr2);   // false - 不同的内存地址
console.log(arr1 === arr2);  // false - 不同的内存地址
console.log(arr1 === arr3);  // true - 相同的内存地址
```

## ⚠️ 内存泄漏与预防

### 常见内存泄漏场景

#### 1. 全局变量
```javascript
function createLeak() {
    // 忘记声明，创建了全局变量
    globalVar = '内存泄漏';
}
```

#### 2. 闭包引用
```javascript
function createClosure() {
    let largeData = new Array(1000000).fill('数据');
    
    return function() {
        // 闭包持有对largeData的引用
        console.log('闭包调用');
    };
}
```

#### 3. 未清理的事件监听器
```javascript
function addListener() {
    let element = document.getElementById('button');
    let largeObject = { data: new Array(100000) };
    
    element.addEventListener('click', function() {
        console.log(largeObject.data.length);
    });
    
    // 忘记移除监听器
    // element.removeEventListener('click', handler);
}
```

### 预防措施

- ✅ 避免创建全局变量
- ✅ 及时清理事件监听器
- ✅ 注意闭包中的引用
- ✅ 使用WeakMap和WeakSet
- ✅ 手动释放大对象的引用

## 💪 弱引用集合

### WeakMap
```javascript
let wm = new WeakMap();
let key = { id: 1 };
wm.set(key, '关联数据');

// 当key对象没有其他引用时，会被自动回收
key = null;
```

### WeakSet
```javascript
let ws = new WeakSet();
let obj = { name: 'test' };
ws.add(obj);

// 对象被回收时，WeakSet中的引用也会自动清理
obj = null;
```

## 🗑️ 垃圾回收机制概览

### 主要算法

#### 1. 引用计数
- 跟踪每个对象被引用的次数
- 引用次数为0时回收对象
- 无法处理循环引用

#### 2. 标记清除
- 从根对象开始标记所有可达对象
- 清除未标记的对象
- 现代浏览器主要使用此算法

#### 3. 分代回收
- 新生代：存储新创建的对象
- 老生代：存储长期存活的对象

## 🛠️ 内存监控工具

### 浏览器开发者工具
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

### 内存快照分析
```javascript
// 创建内存快照的时机
function analyzeMemoryUsage() {
    // 1. 应用启动时
    console.log('启动时内存:', performance.memory.usedJSHeapSize);
    
    // 2. 执行大量操作后
    performHeavyOperations();
    console.log('操作后内存:', performance.memory.usedJSHeapSize);
    
    // 3. 清理后
    cleanup();
    console.log('清理后内存:', performance.memory.usedJSHeapSize);
}
```

## 📈 性能优化建议

### 1. 减少对象创建
```javascript
// ❌ 频繁创建对象
function inefficient() {
    for (let i = 0; i < 1000; i++) {
        const temp = { index: i, data: 'value' };
        process(temp);
    }
}

// ✅ 重用对象
function efficient() {
    const reusableObj = { index: 0, data: '' };
    for (let i = 0; i < 1000; i++) {
        reusableObj.index = i;
        reusableObj.data = 'value';
        process(reusableObj);
    }
}
```

### 2. 使用对象池
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

// 使用对象池
const vectorPool = new ObjectPool(
    () => ({ x: 0, y: 0 }),
    (vec) => { vec.x = 0; vec.y = 0; }
);
```

### 3. 及时清理引用
```javascript
class Component {
    constructor() {
        this.handlers = [];
        this.timers = [];
    }
    
    destroy() {
        // 清理事件监听器
        this.handlers.forEach(({ element, event, handler }) => {
            element.removeEventListener(event, handler);
        });
        
        // 清理定时器
        this.timers.forEach(timer => clearInterval(timer));
        
        // 清理数组
        this.handlers.length = 0;
        this.timers.length = 0;
    }
}
```

通过深入理解 JavaScript 的内存管理机制，你将能够编写更高效、更稳定的代码！🚀 