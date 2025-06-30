# JavaScript 类型检测

掌握各种类型检测方法，准确判断数据类型，是 JavaScript 开发中的重要技能。

## 🔍 类型检测方法对比

| 方法 | 适用场景 | 优点 | 缺点 |
|------|----------|------|------|
| `typeof` | 基本类型检测 | 简单快速 | 对象类型区分不准确 |
| `instanceof` | 对象类型检测 | 准确判断构造函数 | 跨框架问题 |
| `Object.prototype.toString` | 精确类型检测 | 最准确 | 写法较长 |
| `Array.isArray()` | 数组检测 | 专门针对数组 | 只能检测数组 |

## 📊 typeof 操作符

### 基本用法
```javascript
// 基本数据类型
console.log(typeof 42);          // "number"
console.log(typeof 'hello');     // "string"
console.log(typeof true);        // "boolean"
console.log(typeof undefined);   // "undefined"
console.log(typeof Symbol(''));  // "symbol"
console.log(typeof 123n);        // "bigint"

// 引用数据类型
console.log(typeof {});          // "object"
console.log(typeof []);          // "object"
console.log(typeof null);        // "object" (历史遗留问题)
console.log(typeof function(){}); // "function"
console.log(typeof new Date());  // "object"
console.log(typeof /regex/);     // "object"
```

### typeof 的局限性
```javascript
// 无法区分具体的对象类型
console.log(typeof []);          // "object"
console.log(typeof {});          // "object"
console.log(typeof new Date());  // "object"
console.log(typeof null);        // "object" (这是一个已知的bug)

// 函数是唯一能被 typeof 正确识别的对象类型
console.log(typeof function(){}); // "function"
console.log(typeof class {});     // "function"
console.log(typeof (() => {}));   // "function"
```

## 🎯 instanceof 操作符

### 基本用法
```javascript
// 检测对象的构造函数
console.log([] instanceof Array);        // true
console.log({} instanceof Object);       // true
console.log(new Date() instanceof Date); // true
console.log(/regex/ instanceof RegExp);  // true

// 检测继承关系
class Animal {}
class Dog extends Animal {}
const dog = new Dog();

console.log(dog instanceof Dog);     // true
console.log(dog instanceof Animal);  // true
console.log(dog instanceof Object);  // true
```

### instanceof 的原理
```javascript
// instanceof 检查原型链
function myInstanceof(obj, Constructor) {
  let proto = Object.getPrototypeOf(obj);
  
  while (proto !== null) {
    if (proto === Constructor.prototype) {
      return true;
    }
    proto = Object.getPrototypeOf(proto);
  }
  
  return false;
}

// 测试自定义 instanceof
const arr = [];
console.log(myInstanceof(arr, Array));  // true
console.log(myInstanceof(arr, Object)); // true
```

### instanceof 的局限性
```javascript
// 跨框架/窗口问题
// 不同iframe中的Array构造函数不同
const iframe = document.createElement('iframe');
document.body.appendChild(iframe);
const iframeArray = iframe.contentWindow.Array;

const arr1 = [];
const arr2 = new iframeArray();

console.log(arr1 instanceof Array);        // true
console.log(arr2 instanceof Array);        // false
console.log(arr2 instanceof iframeArray);  // true

// 基本类型的包装对象
console.log('hello' instanceof String);    // false
console.log(new String('hello') instanceof String); // true
```

## 🎨 Object.prototype.toString

### 最准确的类型检测
```javascript
const toString = Object.prototype.toString;

// 基本类型
console.log(toString.call(42));         // "[object Number]"
console.log(toString.call('hello'));    // "[object String]"
console.log(toString.call(true));       // "[object Boolean]"
console.log(toString.call(undefined));  // "[object Undefined]"
console.log(toString.call(null));       // "[object Null]"
console.log(toString.call(Symbol(''))); // "[object Symbol]"
console.log(toString.call(123n));       // "[object BigInt]"

// 引用类型
console.log(toString.call({}));         // "[object Object]"
console.log(toString.call([]));         // "[object Array]"
console.log(toString.call(function(){})); // "[object Function]"
console.log(toString.call(new Date())); // "[object Date]"
console.log(toString.call(/regex/));    // "[object RegExp]"
console.log(toString.call(new Error())); // "[object Error]"
```

### 封装通用类型检测函数
```javascript
function getType(value) {
  return Object.prototype.toString.call(value).slice(8, -1).toLowerCase();
}

// 使用示例
console.log(getType(42));           // "number"
console.log(getType('hello'));      // "string"
console.log(getType([]));           // "array"
console.log(getType({}));           // "object"
console.log(getType(null));         // "null"
console.log(getType(undefined));    // "undefined"
console.log(getType(new Date()));   // "date"
console.log(getType(/regex/));      // "regexp"
```

## 🔧 专门的检测方法

### Array.isArray()
```javascript
// 最可靠的数组检测方法
console.log(Array.isArray([]));           // true
console.log(Array.isArray([1, 2, 3]));    // true
console.log(Array.isArray({}));           // false
console.log(Array.isArray('hello'));      // false

// 跨框架也能正确工作
const iframe = document.createElement('iframe');
document.body.appendChild(iframe);
const iframeArray = new iframe.contentWindow.Array();
console.log(Array.isArray(iframeArray));  // true
```

### Number.isNaN()
```javascript
// 更严格的 NaN 检测
console.log(Number.isNaN(NaN));      // true
console.log(Number.isNaN('hello'));  // false
console.log(Number.isNaN(undefined)); // false

// 对比全局 isNaN
console.log(isNaN(NaN));             // true
console.log(isNaN('hello'));         // true (会先转换为数字)
console.log(isNaN(undefined));       // true (会先转换为数字)
```

### Number.isInteger()
```javascript
// 检测是否为整数
console.log(Number.isInteger(42));     // true
console.log(Number.isInteger(42.0));   // true
console.log(Number.isInteger(42.5));   // false
console.log(Number.isInteger('42'));   // false
console.log(Number.isInteger(NaN));    // false
console.log(Number.isInteger(Infinity)); // false
```

## 🛠️ 实用工具函数

### 完整的类型检测库
```javascript
const TypeChecker = {
  // 获取精确类型
  getType(value) {
    return Object.prototype.toString.call(value).slice(8, -1).toLowerCase();
  },
  
  // 基本类型检测
  isString(value) { return typeof value === 'string'; },
  isNumber(value) { return typeof value === 'number' && !isNaN(value); },
  isBoolean(value) { return typeof value === 'boolean'; },
  isUndefined(value) { return typeof value === 'undefined'; },
  isNull(value) { return value === null; },
  isSymbol(value) { return typeof value === 'symbol'; },
  isBigInt(value) { return typeof value === 'bigint'; },
  
  // 引用类型检测
  isObject(value) {
    return value !== null && typeof value === 'object' && !Array.isArray(value);
  },
  isArray(value) { return Array.isArray(value); },
  isFunction(value) { return typeof value === 'function'; },
  isDate(value) { return value instanceof Date && !isNaN(value); },
  isRegExp(value) { return value instanceof RegExp; },
  isError(value) { return value instanceof Error; },
  
  // 特殊检测
  isNaN(value) { return Number.isNaN(value); },
  isInteger(value) { return Number.isInteger(value); },
  isFinite(value) { return Number.isFinite(value); },
  
  // 空值检测
  isEmpty(value) {
    if (this.isNull(value) || this.isUndefined(value)) return true;
    if (this.isString(value) || this.isArray(value)) return value.length === 0;
    if (this.isObject(value)) return Object.keys(value).length === 0;
    return false;
  },
  
  // 原始类型检测
  isPrimitive(value) {
    return value !== Object(value);
  },
  
  // 类数组对象检测
  isArrayLike(value) {
    return value != null && 
           typeof value !== 'function' && 
           typeof value.length === 'number' && 
           value.length >= 0 && 
           value.length <= Number.MAX_SAFE_INTEGER;
  }
};

// 使用示例
console.log(TypeChecker.isString('hello'));     // true
console.log(TypeChecker.isArray([1, 2, 3]));    // true
console.log(TypeChecker.isEmpty({}));           // true
console.log(TypeChecker.isPrimitive(42));       // true
console.log(TypeChecker.isArrayLike('hello'));  // true
console.log(TypeChecker.isArrayLike({length: 3})); // true
```

### 类型断言函数
```javascript
function assert(condition, message) {
  if (!condition) {
    throw new Error(message || 'Assertion failed');
  }
}

function assertType(value, expectedType, message) {
  const actualType = TypeChecker.getType(value);
  assert(
    actualType === expectedType.toLowerCase(),
    message || `Expected ${expectedType}, got ${actualType}`
  );
}

// 使用示例
try {
  assertType('hello', 'String');  // 通过
  assertType(42, 'String');       // 抛出错误
} catch (error) {
  console.error(error.message);   // "Expected string, got number"
}
```

## 🎯 最佳实践

### 1. 选择合适的检测方法
```javascript
// ✅ 基本类型用 typeof
if (typeof value === 'string') {
  // 处理字符串
}

// ✅ 数组用 Array.isArray
if (Array.isArray(value)) {
  // 处理数组
}

// ✅ 精确类型用 Object.prototype.toString
function getExactType(value) {
  return Object.prototype.toString.call(value).slice(8, -1);
}

// ✅ 自定义类型用 instanceof
if (value instanceof MyClass) {
  // 处理自定义类型
}
```

### 2. 处理边界情况
```javascript
function safeTypeCheck(value) {
  // 处理 null
  if (value === null) return 'null';
  
  // 处理 NaN
  if (Number.isNaN(value)) return 'nan';
  
  // 处理 Infinity
  if (!Number.isFinite(value) && typeof value === 'number') {
    return 'infinity';
  }
  
  // 其他情况
  return typeof value;
}
```

### 3. 类型守卫（TypeScript风格）
```javascript
// 类型守卫函数
function isString(value) {
  return typeof value === 'string';
}

function isNumber(value) {
  return typeof value === 'number' && !isNaN(value);
}

function isValidUser(obj) {
  return obj && 
         typeof obj === 'object' &&
         isString(obj.name) &&
         isNumber(obj.age);
}

// 使用类型守卫
function processUser(user) {
  if (isValidUser(user)) {
    console.log(`用户: ${user.name}, 年龄: ${user.age}`);
  } else {
    console.error('无效的用户对象');
  }
}
```

通过掌握这些类型检测方法，你将能够编写更加健壮和可靠的 JavaScript 代码！🚀 