# 包装对象

JavaScript 中的包装对象是基本数据类型的对象版本，了解它们的工作原理对于理解类型系统至关重要。

## 🎯 什么是包装对象

包装对象是 JavaScript 为基本数据类型提供的对象形式，包括：
- `String` - 字符串包装对象
- `Number` - 数字包装对象  
- `Boolean` - 布尔值包装对象
- `Symbol` - 符号包装对象

## 🔄 自动装箱和拆箱

```javascript
// 自动装箱：基本类型调用方法时临时包装为对象
let str = 'hello';
console.log(str.toUpperCase()); // 'HELLO'
// 等价于：new String(str).toUpperCase()

// 自动拆箱：包装对象在需要基本类型时自动转换
let strObj = new String('hello');
console.log(strObj + ' world'); // 'hello world'
```

## 📊 基本类型 vs 包装对象

```javascript
// 基本类型
let primitive = 'hello';
console.log(typeof primitive);        // 'string'
console.log(primitive instanceof String); // false

// 包装对象
let wrapper = new String('hello');
console.log(typeof wrapper);          // 'object'
console.log(wrapper instanceof String); // true

// 值比较
console.log(primitive == wrapper);    // true (自动拆箱)
console.log(primitive === wrapper);   // false (类型不同)
```

## 🛠️ 实际应用

### 临时方法调用
```javascript
// 基本类型可以调用方法（临时包装）
let num = 42;
console.log(num.toString());     // '42'
console.log(num.toFixed(2));     // '42.00'

let bool = true;
console.log(bool.toString());    // 'true'
```

### 属性添加尝试
```javascript
// 基本类型无法添加属性
let str = 'hello';
str.customProp = 'test';
console.log(str.customProp);     // undefined

// 包装对象可以添加属性
let strObj = new String('hello');
strObj.customProp = 'test';
console.log(strObj.customProp);  // 'test'
```

## ⚠️ 注意事项

### 布尔值包装对象陷阱
```javascript
let falseObj = new Boolean(false);
console.log(!!falseObj);         // true (对象总是真值)

if (falseObj) {
  console.log('这会执行！');      // 会执行
}

// 正确的布尔值检测
console.log(falseObj.valueOf()); // false
```

## 🎯 最佳实践

一般情况下应该使用基本类型而不是包装对象：

```javascript
// ✅ 推荐
let str = 'hello';
let num = 42;
let bool = true;

// ❌ 不推荐
let str = new String('hello');
let num = new Number(42);
let bool = new Boolean(true);
```

通过理解包装对象的机制，你将能够更好地理解 JavaScript 的类型系统！🚀 