# 值类型与引用类型

理解 JavaScript 中值类型和引用类型的区别，是掌握变量赋值、函数参数传递和对象操作的关键。

## 🎯 基本概念

### 值类型（Primitive Types）
- 数据直接存储在栈内存中
- 变量赋值时复制值本身
- 修改不会影响原变量

### 引用类型（Reference Types）
- 数据存储在堆内存中，变量存储指向数据的引用
- 变量赋值时复制引用地址
- 通过引用修改会影响所有指向该数据的变量

## 📊 内存存储差异

```javascript
// 值类型存储
let a = 10;
let b = a;  // 复制值
b = 20;     // 修改 b 不影响 a

console.log(a); // 10
console.log(b); // 20

// 引用类型存储
let obj1 = { value: 10 };
let obj2 = obj1;  // 复制引用
obj2.value = 20;  // 通过引用修改

console.log(obj1.value); // 20 (被影响)
console.log(obj2.value); // 20
```

## 🔄 赋值行为对比

### 值类型赋值
```javascript
let num1 = 42;
let num2 = num1;  // 创建新的副本

num2 = 100;       // 只修改 num2

console.log(num1); // 42 (不变)
console.log(num2); // 100
```

### 引用类型赋值
```javascript
let arr1 = [1, 2, 3];
let arr2 = arr1;  // 复制引用，指向同一个数组

arr2.push(4);     // 通过 arr2 修改数组

console.log(arr1); // [1, 2, 3, 4] (被修改)
console.log(arr2); // [1, 2, 3, 4]
console.log(arr1 === arr2); // true (指向同一个对象)
```

## 🔍 函数参数传递

### 值类型参数传递
```javascript
function modifyPrimitive(x) {
  x = x * 2;
  console.log('函数内 x:', x); // 20
}

let num = 10;
modifyPrimitive(num);
console.log('函数外 num:', num); // 10 (不变)
```

### 引用类型参数传递
```javascript
function modifyObject(obj) {
  obj.value = obj.value * 2;
  console.log('函数内 obj:', obj); // { value: 20 }
}

let myObj = { value: 10 };
modifyObject(myObj);
console.log('函数外 myObj:', myObj); // { value: 20 } (被修改)
```

### 重新赋值 vs 修改属性
```javascript
function reassignObject(obj) {
  obj = { value: 999 };  // 重新赋值，不影响原对象
  console.log('函数内重新赋值:', obj); // { value: 999 }
}

function modifyProperty(obj) {
  obj.value = 999;       // 修改属性，影响原对象
  console.log('函数内修改属性:', obj); // { value: 999 }
}

let original = { value: 10 };

// 测试重新赋值
let test1 = { ...original };
reassignObject(test1);
console.log('重新赋值后:', test1); // { value: 10 } (不变)

// 测试修改属性
let test2 = { ...original };
modifyProperty(test2);
console.log('修改属性后:', test2); // { value: 999 } (被修改)
```

## 📋 比较操作

### 值类型比较
```javascript
let a = 5;
let b = 5;
let c = a;

console.log(a == b);  // true (值相等)
console.log(a === b); // true (值和类型都相等)
console.log(a === c); // true (值相等)
```

### 引用类型比较
```javascript
let obj1 = { name: 'Alice' };
let obj2 = { name: 'Alice' };
let obj3 = obj1;

console.log(obj1 == obj2);  // false (不同的引用)
console.log(obj1 === obj2); // false (不同的引用)
console.log(obj1 === obj3); // true (相同的引用)

// 内容相同但引用不同
let arr1 = [1, 2, 3];
let arr2 = [1, 2, 3];
console.log(arr1 === arr2); // false
```

## 🔧 深拷贝与浅拷贝

### 浅拷贝
```javascript
// Object.assign
let original = { a: 1, b: { c: 2 } };
let copy1 = Object.assign({}, original);

// 扩展运算符
let copy2 = { ...original };

// 修改嵌套对象
copy1.b.c = 999;
console.log(original.b.c); // 999 (被影响)
console.log(copy2.b.c);    // 999 (被影响)
```

### 深拷贝
```javascript
// JSON 方法 (有限制)
let original = { a: 1, b: { c: 2 } };
let deepCopy1 = JSON.parse(JSON.stringify(original));

deepCopy1.b.c = 999;
console.log(original.b.c); // 2 (不受影响)

// 递归深拷贝
function deepClone(obj) {
  if (obj === null || typeof obj !== 'object') return obj;
  if (obj instanceof Date) return new Date(obj);
  if (obj instanceof Array) return obj.map(item => deepClone(item));
  
  const cloned = {};
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      cloned[key] = deepClone(obj[key]);
    }
  }
  return cloned;
}

let deepCopy2 = deepClone(original);
deepCopy2.b.c = 888;
console.log(original.b.c); // 2 (不受影响)
```

## ⚠️ 常见陷阱

### 循环引用
```javascript
let obj = { name: 'test' };
obj.self = obj;  // 循环引用

// JSON.stringify 会报错
try {
  JSON.stringify(obj);
} catch (error) {
  console.log('循环引用错误:', error.message);
}

// 需要特殊处理
function deepCloneWithCircular(obj, visited = new WeakMap()) {
  if (obj === null || typeof obj !== 'object') return obj;
  if (visited.has(obj)) return visited.get(obj);
  
  const cloned = Array.isArray(obj) ? [] : {};
  visited.set(obj, cloned);
  
  for (let key in obj) {
    if (obj.hasOwnProperty(key)) {
      cloned[key] = deepCloneWithCircular(obj[key], visited);
    }
  }
  
  return cloned;
}
```

### 数组操作陷阱
```javascript
function processArray(arr) {
  arr.push('new item');  // 修改原数组
  return arr;
}

function safeProcessArray(arr) {
  const newArr = [...arr];  // 创建副本
  newArr.push('new item');
  return newArr;
}

let original = ['a', 'b', 'c'];

// 不安全的操作
let result1 = processArray(original);
console.log(original); // ['a', 'b', 'c', 'new item'] (被修改)

// 安全的操作
original = ['a', 'b', 'c'];  // 重置
let result2 = safeProcessArray(original);
console.log(original); // ['a', 'b', 'c'] (不变)
console.log(result2);  // ['a', 'b', 'c', 'new item']
```

## 🛠️ 实用工具函数

### 类型检测工具
```javascript
function isPrimitive(value) {
  return value !== Object(value);
}

function isReference(value) {
  return value === Object(value);
}

// 测试
console.log(isPrimitive(42));       // true
console.log(isPrimitive('hello'));  // true
console.log(isPrimitive({}));       // false
console.log(isPrimitive([]));       // false

console.log(isReference({}));       // true
console.log(isReference([]));       // true
console.log(isReference(42));       // false
```

### 安全的对象操作
```javascript
// 安全的属性设置
function safeSet(obj, key, value) {
  const newObj = { ...obj };
  newObj[key] = value;
  return newObj;
}

// 安全的数组操作
function safeArrayPush(arr, item) {
  return [...arr, item];
}

function safeArrayRemove(arr, index) {
  return arr.filter((_, i) => i !== index);
}

// 使用示例
let obj = { a: 1, b: 2 };
let newObj = safeSet(obj, 'c', 3);
console.log(obj);    // { a: 1, b: 2 } (不变)
console.log(newObj); // { a: 1, b: 2, c: 3 }

let arr = [1, 2, 3];
let newArr = safeArrayPush(arr, 4);
console.log(arr);    // [1, 2, 3] (不变)
console.log(newArr); // [1, 2, 3, 4]
```

### 对象冻结和密封
```javascript
// 冻结对象 (不可修改)
let frozenObj = Object.freeze({ a: 1, b: 2 });
frozenObj.a = 999;  // 无效
console.log(frozenObj.a); // 1

// 密封对象 (可修改值，不可添加/删除属性)
let sealedObj = Object.seal({ a: 1, b: 2 });
sealedObj.a = 999;  // 有效
sealedObj.c = 3;    // 无效
console.log(sealedObj); // { a: 999, b: 2 }

// 检测对象状态
console.log(Object.isFrozen(frozenObj)); // true
console.log(Object.isSealed(sealedObj));  // true
```

## 🎯 最佳实践

### 1. 避免意外修改
```javascript
// ❌ 直接操作参数
function badFunction(obj) {
  obj.modified = true;
  return obj;
}

// ✅ 创建副本后操作
function goodFunction(obj) {
  const copy = { ...obj };
  copy.modified = true;
  return copy;
}
```

### 2. 使用不可变数据结构
```javascript
// 使用 Immutable.js 或类似库
// 或者手动实现不可变操作

const ImmutableArray = {
  push: (arr, item) => [...arr, item],
  pop: (arr) => arr.slice(0, -1),
  shift: (arr) => arr.slice(1),
  unshift: (arr, item) => [item, ...arr],
  splice: (arr, start, deleteCount, ...items) => [
    ...arr.slice(0, start),
    ...items,
    ...arr.slice(start + deleteCount)
  ]
};

let arr = [1, 2, 3];
let newArr = ImmutableArray.push(arr, 4);
console.log(arr);    // [1, 2, 3] (不变)
console.log(newArr); // [1, 2, 3, 4]
```

### 3. 函数式编程风格
```javascript
// 纯函数：不修改输入，总是返回新值
function addProperty(obj, key, value) {
  return { ...obj, [key]: value };
}

function updateProperty(obj, key, updater) {
  return { ...obj, [key]: updater(obj[key]) };
}

// 使用示例
let user = { name: 'Alice', age: 25 };
let updatedUser = updateProperty(user, 'age', age => age + 1);

console.log(user);        // { name: 'Alice', age: 25 } (不变)
console.log(updatedUser); // { name: 'Alice', age: 26 }
```

## 📊 性能考虑

### 值类型性能
```javascript
// 值类型操作很快
let start = performance.now();
for (let i = 0; i < 1000000; i++) {
  let a = 42;
  let b = a;
  b = b * 2;
}
let end = performance.now();
console.log('值类型操作时间:', end - start, 'ms');
```

### 引用类型性能
```javascript
// 对象创建相对较慢
let start = performance.now();
for (let i = 0; i < 1000000; i++) {
  let obj1 = { value: 42 };
  let obj2 = { ...obj1 };
  obj2.value = obj2.value * 2;
}
let end = performance.now();
console.log('对象操作时间:', end - start, 'ms');
```

通过深入理解值类型和引用类型的差异，你将能够避免常见的编程陷阱，编写更加可靠和高效的代码！🚀 