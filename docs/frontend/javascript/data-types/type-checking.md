# 类型判断最佳实践

掌握正确的类型判断方法，是编写健壮 JavaScript 代码的基础。

## 🎯 核心原则

1. **选择合适的方法**：不同场景使用不同的类型检测方法
2. **处理边界情况**：考虑 null、undefined、NaN 等特殊值
3. **保持一致性**：在项目中统一类型检测方式
4. **性能考虑**：选择高效的检测方法

## 📊 方法选择指南

```javascript
// ✅ 基本类型检测 - 使用 typeof
function isString(value) {
  return typeof value === 'string';
}

// ✅ 数组检测 - 使用 Array.isArray
function isArray(value) {
  return Array.isArray(value);
}

// ✅ 精确类型检测 - 使用 Object.prototype.toString
function getExactType(value) {
  return Object.prototype.toString.call(value).slice(8, -1).toLowerCase();
}

// ✅ 自定义类型检测 - 使用 instanceof
function isCustomType(value, Constructor) {
  return value instanceof Constructor;
}
```

## 🛠️ 通用类型检测库

```javascript
const TypeValidator = {
  // 基本类型
  isString: (value) => typeof value === 'string',
  isNumber: (value) => typeof value === 'number' && !isNaN(value),
  isBoolean: (value) => typeof value === 'boolean',
  isUndefined: (value) => typeof value === 'undefined',
  isNull: (value) => value === null,
  isSymbol: (value) => typeof value === 'symbol',
  isBigInt: (value) => typeof value === 'bigint',
  
  // 引用类型
  isObject: (value) => value !== null && typeof value === 'object' && !Array.isArray(value),
  isArray: (value) => Array.isArray(value),
  isFunction: (value) => typeof value === 'function',
  isDate: (value) => value instanceof Date && !isNaN(value),
  isRegExp: (value) => value instanceof RegExp,
  isError: (value) => value instanceof Error,
  
  // 特殊值
  isNaN: (value) => Number.isNaN(value),
  isFinite: (value) => Number.isFinite(value),
  isInteger: (value) => Number.isInteger(value),
  
  // 复合检测
  isEmpty: (value) => {
    if (value === null || value === undefined) return true;
    if (typeof value === 'string' || Array.isArray(value)) return value.length === 0;
    if (typeof value === 'object') return Object.keys(value).length === 0;
    return false;
  },
  
  isPrimitive: (value) => value !== Object(value),
  isArrayLike: (value) => value != null && typeof value.length === 'number' && value.length >= 0
};
```

## 🎯 实际应用场景

### 函数参数验证
```javascript
function processUser(user) {
  if (!TypeValidator.isObject(user)) {
    throw new Error('User must be an object');
  }
  
  if (!TypeValidator.isString(user.name)) {
    throw new Error('User name must be a string');
  }
  
  if (!TypeValidator.isNumber(user.age) || user.age < 0) {
    throw new Error('User age must be a positive number');
  }
  
  // 处理用户数据
  return `${user.name} is ${user.age} years old`;
}
```

### 安全的数据处理
```javascript
function safeDataProcessor(data) {
  const result = {
    strings: [],
    numbers: [],
    arrays: [],
    objects: []
  };
  
  if (TypeValidator.isArray(data)) {
    data.forEach(item => {
      if (TypeValidator.isString(item)) {
        result.strings.push(item);
      } else if (TypeValidator.isNumber(item)) {
        result.numbers.push(item);
      } else if (TypeValidator.isArray(item)) {
        result.arrays.push(item);
      } else if (TypeValidator.isObject(item)) {
        result.objects.push(item);
      }
    });
  }
  
  return result;
}
```

## ⚠️ 常见陷阱避免

### 1. null 检测陷阱
```javascript
// ❌ 错误的 null 检测
if (typeof value === 'object') {
  // null 也会通过这个检测
}

// ✅ 正确的对象检测
if (value !== null && typeof value === 'object' && !Array.isArray(value)) {
  // 这才是真正的对象
}
```

### 2. NaN 检测陷阱
```javascript
// ❌ 错误的 NaN 检测
if (value === NaN) {
  // 永远不会为 true
}

// ✅ 正确的 NaN 检测
if (Number.isNaN(value)) {
  // 正确检测 NaN
}
```

### 3. 数组检测陷阱
```javascript
// ❌ 不可靠的数组检测
if (typeof value === 'object' && value.length !== undefined) {
  // 类数组对象也会通过
}

// ✅ 可靠的数组检测
if (Array.isArray(value)) {
  // 只有真正的数组才会通过
}
```

## 🚀 性能优化

### 类型检测性能对比
```javascript
// 性能测试函数
function performanceTest() {
  const testValue = 'hello';
  const iterations = 1000000;
  
  // typeof 检测
  console.time('typeof');
  for (let i = 0; i < iterations; i++) {
    typeof testValue === 'string';
  }
  console.timeEnd('typeof');
  
  // Object.prototype.toString 检测
  console.time('toString');
  for (let i = 0; i < iterations; i++) {
    Object.prototype.toString.call(testValue) === '[object String]';
  }
  console.timeEnd('toString');
}

// typeof 通常是最快的基本类型检测方法
```

## 📚 最佳实践总结

### 1. 选择原则
```javascript
// 基本类型 → typeof
if (typeof value === 'string') { /* ... */ }

// 数组 → Array.isArray
if (Array.isArray(value)) { /* ... */ }

// 精确类型 → Object.prototype.toString
function getType(value) {
  return Object.prototype.toString.call(value).slice(8, -1).toLowerCase();
}

// 自定义类型 → instanceof
if (value instanceof MyClass) { /* ... */ }
```

### 2. 防御性编程
```javascript
function safeFunction(input) {
  // 总是检查输入参数
  if (input === null || input === undefined) {
    return null;
  }
  
  // 根据类型采取不同处理
  if (TypeValidator.isString(input)) {
    return input.trim();
  } else if (TypeValidator.isNumber(input)) {
    return input.toFixed(2);
  } else if (TypeValidator.isArray(input)) {
    return input.filter(Boolean);
  }
  
  // 未知类型的默认处理
  return String(input);
}
```

### 3. 类型断言
```javascript
function assertType(value, type, message) {
  const validators = {
    string: TypeValidator.isString,
    number: TypeValidator.isNumber,
    boolean: TypeValidator.isBoolean,
    array: TypeValidator.isArray,
    object: TypeValidator.isObject,
    function: TypeValidator.isFunction
  };
  
  const validator = validators[type];
  if (!validator || !validator(value)) {
    throw new TypeError(message || `Expected ${type}, got ${typeof value}`);
  }
}

// 使用示例
function divide(a, b) {
  assertType(a, 'number', 'First argument must be a number');
  assertType(b, 'number', 'Second argument must be a number');
  
  if (b === 0) {
    throw new Error('Division by zero');
  }
  
  return a / b;
}
```

通过掌握这些类型判断的最佳实践，你将能够编写更加健壮和可维护的 JavaScript 代码！🚀 