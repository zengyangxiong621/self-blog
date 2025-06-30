# JavaScript 数据类型

JavaScript 的数据类型是编程的基础，理解不同数据类型的特性和使用场景对于编写高质量的代码至关重要。

## 📚 数据类型分类

### 基本数据类型（原始类型）
- **Number** - 数字类型
- **String** - 字符串类型
- **Boolean** - 布尔类型
- **Undefined** - 未定义类型
- **Null** - 空值类型
- **Symbol** - 符号类型（ES6）
- **BigInt** - 大整数类型（ES2020）

### 引用数据类型（对象类型）
- **Object** - 对象类型
- **Array** - 数组类型
- **Function** - 函数类型
- **Date** - 日期类型
- **RegExp** - 正则表达式类型

## 🎯 学习路径

### 1. 基础概念
- [数据类型检测](./type-detection.md)
- [类型转换](./type-conversion.md)
- [Symbol 详解](./symbol/index.md)

### 2. 深入理解
- [值类型与引用类型](./value-vs-reference.md)
- [包装对象](./wrapper-objects.md)
- [类型判断最佳实践](./type-checking.md)

## 🔍 类型检测方法

```javascript
// typeof 操作符
typeof 42;          // "number"
typeof "hello";     // "string"
typeof true;        // "boolean"
typeof undefined;   // "undefined"
typeof null;        // "object" (历史遗留问题)
typeof {};          // "object"
typeof [];          // "object"
typeof function(){}; // "function"

// instanceof 操作符
[] instanceof Array;        // true
{} instanceof Object;       // true
new Date() instanceof Date; // true

// Object.prototype.toString
Object.prototype.toString.call([]);        // "[object Array]"
Object.prototype.toString.call({});        // "[object Object]"
Object.prototype.toString.call(null);      // "[object Null]"
Object.prototype.toString.call(undefined); // "[object Undefined]"
```

## ⚡ 类型转换

### 显式转换
```javascript
// 转换为数字
Number("123");    // 123
parseInt("123");  // 123
parseFloat("123.45"); // 123.45

// 转换为字符串
String(123);      // "123"
(123).toString(); // "123"

// 转换为布尔值
Boolean(1);       // true
Boolean(0);       // false
Boolean("");      // false
Boolean("hello"); // true
```

### 隐式转换
```javascript
// 算术运算
"5" - 3;    // 2 (字符串转数字)
"5" + 3;    // "53" (数字转字符串)
true + 1;   // 2 (布尔值转数字)

// 比较运算
"10" > 9;   // true (字符串转数字)
null == 0;  // false
null >= 0;  // true
```

## 💡 最佳实践

### 1. 类型检测
```javascript
// 推荐的类型检测函数
function getType(value) {
  return Object.prototype.toString.call(value).slice(8, -1).toLowerCase();
}

getType([]);        // "array"
getType({});        // "object"
getType(null);      // "null"
getType(undefined); // "undefined"
```

### 2. 安全的类型转换
```javascript
// 安全的数字转换
function toNumber(value) {
  const num = Number(value);
  return isNaN(num) ? 0 : num;
}

// 安全的字符串转换
function toString(value) {
  if (value === null || value === undefined) {
    return '';
  }
  return String(value);
}
```

### 3. 类型守卫
```javascript
// TypeScript 风格的类型守卫
function isString(value) {
  return typeof value === 'string';
}

function isArray(value) {
  return Array.isArray(value);
}

function isObject(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}
```

## 🎨 Symbol 类型详解

Symbol 是 ES6 引入的新的原始数据类型，表示独一无二的标识符。

```javascript
// 创建 Symbol
const sym1 = Symbol();
const sym2 = Symbol('description');
const sym3 = Symbol('description');

console.log(sym2 === sym3); // false，每个 Symbol 都是唯一的

// Symbol 作为对象属性
const obj = {
  [Symbol('name')]: 'Alice',
  age: 25
};

// Symbol 属性不会被常规方法遍历
Object.keys(obj);           // ['age']
Object.getOwnPropertyNames(obj); // ['age']
Object.getOwnPropertySymbols(obj); // [Symbol(name)]
```

## 🔧 实用工具函数

```javascript
// 深度类型检测
function deepTypeOf(obj) {
  const type = Object.prototype.toString.call(obj).slice(8, -1);
  
  if (type === 'Object') {
    // 检测是否是普通对象
    if (obj.constructor === Object) {
      return 'PlainObject';
    }
    return obj.constructor.name || 'Object';
  }
  
  return type;
}

// 类型断言
function assert(condition, message) {
  if (!condition) {
    throw new Error(message || 'Assertion failed');
  }
}

function assertType(value, expectedType, message) {
  const actualType = typeof value;
  assert(
    actualType === expectedType,
    message || `Expected ${expectedType}, got ${actualType}`
  );
}

// 使用示例
assertType("hello", "string"); // 通过
assertType(123, "string");     // 抛出错误
```

通过深入理解 JavaScript 的数据类型系统，你将能够写出更加健壮和可维护的代码！🚀 