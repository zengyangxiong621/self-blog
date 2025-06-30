# JavaScript 类型转换

深入理解 JavaScript 的类型转换机制，包括显式转换和隐式转换的规则和最佳实践。

## 🔄 类型转换概述

JavaScript 是动态类型语言，变量可以存储不同类型的值，类型转换分为：

- **显式转换**：程序员主动调用转换函数
- **隐式转换**：JavaScript 引擎自动进行的转换

## 📊 显式类型转换

### 转换为字符串

```javascript
// String() 函数
console.log(String(123));        // "123"
console.log(String(true));       // "true"
console.log(String(null));       // "null"
console.log(String(undefined));  // "undefined"
console.log(String(Symbol('x'))); // "Symbol(x)"

// toString() 方法
console.log((123).toString());   // "123"
console.log(true.toString());    // "true"
console.log([1,2,3].toString()); // "1,2,3"

// 注意：null 和 undefined 没有 toString 方法
// console.log(null.toString());    // TypeError
// console.log(undefined.toString()); // TypeError

// 模板字符串
console.log(`${123}`);           // "123"
console.log(`${true}`);          // "true"
```

### 转换为数字

```javascript
// Number() 函数
console.log(Number("123"));      // 123
console.log(Number("123.45"));   // 123.45
console.log(Number(""));         // 0
console.log(Number(" "));        // 0
console.log(Number("123abc"));    // NaN
console.log(Number(true));       // 1
console.log(Number(false));      // 0
console.log(Number(null));       // 0
console.log(Number(undefined));  // NaN

// parseInt() 和 parseFloat()
console.log(parseInt("123"));     // 123
console.log(parseInt("123.45"));  // 123
console.log(parseInt("123abc"));  // 123
console.log(parseFloat("123.45")); // 123.45
console.log(parseFloat("123.45abc")); // 123.45

// 进制转换
console.log(parseInt("10", 2));   // 2 (二进制)
console.log(parseInt("10", 8));   // 8 (八进制)
console.log(parseInt("10", 16));  // 16 (十六进制)

// 一元加号操作符
console.log(+"123");             // 123
console.log(+"123.45");          // 123.45
console.log(+"");                // 0
console.log(+"abc");             // NaN
```

### 转换为布尔值

```javascript
// Boolean() 函数
console.log(Boolean(1));         // true
console.log(Boolean(0));         // false
console.log(Boolean("hello"));   // true
console.log(Boolean(""));        // false
console.log(Boolean(null));      // false
console.log(Boolean(undefined)); // false
console.log(Boolean(NaN));       // false
console.log(Boolean({}));        // true
console.log(Boolean([]));        // true

// 双重否定操作符
console.log(!!"hello");          // true
console.log(!!"");               // false
console.log(!!0);                // false
console.log(!!1);                // true
```

## 🔀 隐式类型转换

### 算术运算中的转换

```javascript
// 加法运算：有字符串则转换为字符串
console.log(1 + "2");            // "12"
console.log("1" + 2);            // "12"
console.log(1 + 2 + "3");        // "33"
console.log("1" + 2 + 3);        // "123"

// 其他算术运算：转换为数字
console.log("5" - 2);            // 3
console.log("5" * "2");          // 10
console.log("10" / "2");         // 5
console.log("10" % "3");         // 1

// 特殊情况
console.log("5" - "abc");        // NaN
console.log(true + 1);           // 2
console.log(false + 1);          // 1
console.log(null + 1);           // 1
console.log(undefined + 1);      // NaN
```

### 比较运算中的转换

```javascript
// 相等比较 (==)
console.log("5" == 5);           // true
console.log(true == 1);          // true
console.log(false == 0);         // true
console.log(null == undefined);  // true
console.log("" == 0);            // true

// 严格相等比较 (===)
console.log("5" === 5);          // false
console.log(true === 1);         // false
console.log(null === undefined); // false

// 关系比较
console.log("10" > 5);           // true
console.log("10" > "5");         // false (字符串比较)
console.log("a" > "b");          // false
console.log("10" > "9");         // false (字符串比较)
```

### 逻辑运算中的转换

```javascript
// 逻辑与 (&&)
console.log(true && "hello");    // "hello"
console.log(false && "hello");   // false
console.log("" && "hello");      // ""
console.log("hi" && "hello");    // "hello"

// 逻辑或 (||)
console.log(true || "hello");    // true
console.log(false || "hello");   // "hello"
console.log("" || "hello");      // "hello"
console.log("hi" || "hello");    // "hi"

// 逻辑非 (!)
console.log(!true);              // false
console.log(!"hello");           // false
console.log(!"");                // true
console.log(!0);                 // true
```

## 🎯 转换规则详解

### ToPrimitive 抽象操作

```javascript
// 对象到原始值的转换
const obj = {
  valueOf() {
    console.log('valueOf called');
    return 42;
  },
  toString() {
    console.log('toString called');
    return "object";
  }
};

// 数字上下文：优先调用 valueOf
console.log(obj - 0);           // valueOf called, 42

// 字符串上下文：优先调用 toString
console.log(obj + "");          // valueOf called, "42"

// 默认上下文：Date 对象优先 toString，其他优先 valueOf
console.log(String(obj));       // toString called, "object"
```

### Symbol.toPrimitive

```javascript
const obj = {
  [Symbol.toPrimitive](hint) {
    console.log('hint:', hint);
    switch (hint) {
      case 'number':
        return 42;
      case 'string':
        return 'hello';
      case 'default':
        return 'default';
    }
  }
};

console.log(+obj);              // hint: number, 42
console.log(`${obj}`);          // hint: string, "hello"
console.log(obj + "");          // hint: default, "default"
```

### 假值和真值

```javascript
// 假值 (Falsy Values)
const falsyValues = [
  false,
  0,
  -0,
  0n,
  "",
  null,
  undefined,
  NaN
];

falsyValues.forEach(value => {
  console.log(`${value} is falsy:`, !value); // 全部为 true
});

// 真值 (Truthy Values) - 除假值外的所有值
const truthyValues = [
  true,
  1,
  -1,
  "hello",
  " ",
  "0",
  "false",
  {},
  [],
  function() {}
];

truthyValues.forEach(value => {
  console.log(`${value} is truthy:`, !!value); // 全部为 true
});
```

## ⚠️ 常见陷阱

### 字符串连接 vs 数字相加

```javascript
// 意外的字符串连接
function add(a, b) {
  return a + b; // 如果 a 或 b 是字符串，会进行连接
}

console.log(add(1, 2));          // 3
console.log(add("1", 2));        // "12"
console.log(add(1, "2"));        // "12"

// 安全的数字相加
function safeAdd(a, b) {
  return Number(a) + Number(b);
}

console.log(safeAdd("1", "2"));  // 3
```

### 数组的转换

```javascript
// 数组转字符串
console.log([1, 2, 3] + "");     // "1,2,3"
console.log([1] + "");           // "1"
console.log([1, 2] + "");        // "1,2"
console.log([] + "");            // ""

// 数组转数字
console.log(+[]);                // 0
console.log(+[1]);               // 1
console.log(+[1, 2]);            // NaN

// 数组比较
console.log([] == 0);            // true
console.log([1] == 1);           // true
console.log([1, 2] == "1,2");    // true
```

### null 和 undefined 的转换

```javascript
// null 的转换
console.log(Number(null));       // 0
console.log(String(null));       // "null"
console.log(Boolean(null));      // false

// undefined 的转换
console.log(Number(undefined));  // NaN
console.log(String(undefined));  // "undefined"
console.log(Boolean(undefined)); // false

// 比较中的特殊情况
console.log(null == undefined);  // true
console.log(null === undefined); // false
console.log(null == 0);          // false
console.log(null >= 0);          // true (null 转换为 0)
```

## 🛠️ 实用工具函数

### 安全的类型转换

```javascript
const SafeConvert = {
  // 安全转换为数字
  toNumber(value, defaultValue = 0) {
    const num = Number(value);
    return isNaN(num) ? defaultValue : num;
  },
  
  // 安全转换为整数
  toInteger(value, defaultValue = 0) {
    const num = parseInt(value, 10);
    return isNaN(num) ? defaultValue : num;
  },
  
  // 安全转换为字符串
  toString(value, defaultValue = '') {
    if (value === null || value === undefined) {
      return defaultValue;
    }
    return String(value);
  },
  
  // 安全转换为布尔值
  toBoolean(value) {
    return Boolean(value);
  },
  
  // 转换为数组
  toArray(value) {
    if (Array.isArray(value)) return value;
    if (value === null || value === undefined) return [];
    return [value];
  }
};

// 使用示例
console.log(SafeConvert.toNumber("123"));    // 123
console.log(SafeConvert.toNumber("abc"));    // 0
console.log(SafeConvert.toNumber("abc", -1)); // -1
console.log(SafeConvert.toString(null));     // ""
console.log(SafeConvert.toArray("hello"));   // ["hello"]
console.log(SafeConvert.toArray([1, 2]));    // [1, 2]
```

### 类型转换验证

```javascript
function validateConversion(value, targetType) {
  const conversions = {
    number: {
      convert: Number,
      validate: (result) => !isNaN(result)
    },
    string: {
      convert: String,
      validate: (result) => typeof result === 'string'
    },
    boolean: {
      convert: Boolean,
      validate: (result) => typeof result === 'boolean'
    }
  };
  
  const converter = conversions[targetType];
  if (!converter) {
    throw new Error(`Unsupported target type: ${targetType}`);
  }
  
  const result = converter.convert(value);
  const isValid = converter.validate(result);
  
  return {
    original: value,
    converted: result,
    isValid: isValid,
    type: typeof result
  };
}

// 使用示例
console.log(validateConversion("123", "number"));
// { original: "123", converted: 123, isValid: true, type: "number" }

console.log(validateConversion("abc", "number"));
// { original: "abc", converted: NaN, isValid: false, type: "number" }
```

## 🎯 最佳实践

### 1. 优先使用显式转换

```javascript
// ❌ 依赖隐式转换
function calculate(a, b) {
  return a * b; // 如果 a 或 b 是字符串，可能产生意外结果
}

// ✅ 使用显式转换
function calculate(a, b) {
  return Number(a) * Number(b);
}
```

### 2. 使用严格相等比较

```javascript
// ❌ 使用相等比较
if (value == 0) {
  // 可能匹配 "", false, null 等
}

// ✅ 使用严格相等比较
if (value === 0) {
  // 只匹配数字 0
}
```

### 3. 处理边界情况

```javascript
function safeParseInt(value) {
  // 处理 null 和 undefined
  if (value === null || value === undefined) {
    return 0;
  }
  
  // 转换为字符串处理
  const str = String(value).trim();
  
  // 空字符串返回 0
  if (str === '') {
    return 0;
  }
  
  const result = parseInt(str, 10);
  return isNaN(result) ? 0 : result;
}

// 测试
console.log(safeParseInt("123"));    // 123
console.log(safeParseInt("123abc")); // 123
console.log(safeParseInt(""));       // 0
console.log(safeParseInt(null));     // 0
console.log(safeParseInt("abc"));    // 0
```

### 4. 使用类型检查

```javascript
function processValue(value) {
  // 先检查类型，再进行转换
  if (typeof value === 'string') {
    return value.toUpperCase();
  } else if (typeof value === 'number') {
    return value.toFixed(2);
  } else if (Array.isArray(value)) {
    return value.join(', ');
  } else {
    return String(value);
  }
}
```

## 📋 转换对照表

| 原始值 | Number() | String() | Boolean() |
|--------|----------|----------|-----------|
| `undefined` | `NaN` | `"undefined"` | `false` |
| `null` | `0` | `"null"` | `false` |
| `true` | `1` | `"true"` | `true` |
| `false` | `0` | `"false"` | `false` |
| `""` | `0` | `""` | `false` |
| `"123"` | `123` | `"123"` | `true` |
| `"abc"` | `NaN` | `"abc"` | `true` |
| `0` | `0` | `"0"` | `false` |
| `123` | `123` | `"123"` | `true` |
| `NaN` | `NaN` | `"NaN"` | `false` |
| `{}` | `NaN` | `"[object Object]"` | `true` |
| `[]` | `0` | `""` | `true` |
| `[1,2,3]` | `NaN` | `"1,2,3"` | `true` |

通过深入理解类型转换机制，你将能够避免常见的陷阱，编写更加可靠的 JavaScript 代码！🚀 