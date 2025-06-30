# Symbol 详解

Symbol 是 ES6 引入的新的原始数据类型，表示独一无二的标识符。它解决了对象属性名冲突的问题，并提供了创建真正私有属性的能力。

## 🎯 基本概念

### 什么是 Symbol？
Symbol 是一种基本数据类型，每个从 Symbol() 返回的 symbol 值都是唯一的。symbol 值可以用作对象属性的标识符，这是该数据类型仅有的目的。

```javascript
// 基本创建和使用
const s1 = Symbol();
const s2 = Symbol();
console.log(s1 === s2); // false，每个 Symbol 都是唯一的

// 可以添加描述，便于调试
const s3 = Symbol('描述');
console.log(s3.description); // '描述'
console.log(s3.toString()); // 'Symbol(描述)'
```

## 🔧 创建方式

### 1. Symbol() 函数
```javascript
// 不能使用 new 操作符
const sym1 = Symbol();
const sym2 = Symbol('description');

// 错误用法
// const sym3 = new Symbol(); // TypeError
```

### 2. Symbol.for() - 全局注册
```javascript
// 在全局 Symbol 注册表中查找或创建
const s1 = Symbol.for('shared');
const s2 = Symbol.for('shared');
console.log(s1 === s2); // true

// 获取全局 Symbol 的键
console.log(Symbol.keyFor(s1)); // 'shared'
console.log(Symbol.keyFor(Symbol('local'))); // undefined
```

## 🎨 作为对象属性

### 基本用法
```javascript
const MY_KEY = Symbol('myKey');
const obj = {
  [MY_KEY]: 'value',
  'strKey': 'strValue',
  'numKey': 1
};

// 访问 Symbol 属性
console.log(obj[MY_KEY]); // 'value'
console.log(obj.MY_KEY);  // undefined (不能用点语法)
```

### 属性枚举特性
```javascript
const symbolKey = Symbol('symbol');
const obj = {
  [symbolKey]: 'symbolValue',
  normalKey: 'normalValue'
};

// Symbol 属性不会出现在常规的属性枚举中
console.log(Object.keys(obj));                    // ['normalKey']
console.log(Object.getOwnPropertyNames(obj));     // ['normalKey']
console.log(Object.getOwnPropertySymbols(obj));   // [Symbol(symbol)]
console.log(Reflect.ownKeys(obj));                // ['normalKey', Symbol(symbol)]

// for...in 循环也不会遍历 Symbol 属性
for (let key in obj) {
  console.log(key); // 只输出 'normalKey'
}
```

## 🛡️ 实际应用场景

### 1. 创建真正的私有属性

```javascript
// 问题：普通的字符串属性名可能会被外部访问或意外覆盖
class User {
  constructor(name) {
    this.name = name;
    this._password = '123456'; // 约定的私有属性，但仍可被外部访问
  }
}

const user1 = new User('张三');
console.log(user1._password); // 可以访问到
user1._password = 'hacked';   // 可以被修改

// 解决方案：使用 Symbol 创建真正的私有属性
const PASSWORD_KEY = Symbol('password');
const INTERNAL_ID = Symbol('internalId');

class SecureUser {
  constructor(name) {
    this.name = name;
    this[PASSWORD_KEY] = '123456';
    this[INTERNAL_ID] = Math.random();
  }
  
  validatePassword(password) {
    return this[PASSWORD_KEY] === password;
  }
  
  getInternalId() {
    return this[INTERNAL_ID];
  }
}

const user2 = new SecureUser('李四');
console.log(user2.name);                    // 正常访问
console.log(Object.keys(user2));            // 只显示 ['name']
console.log(user2._password);               // undefined
console.log(user2.validatePassword('123456')); // true
```

### 2. 防止第三方库属性名冲突

```javascript
// 防止与其他库的属性名冲突
const REACT_COMPONENT_KEY = Symbol('reactComponent');
const JQUERY_DATA_KEY = Symbol('jqueryData');

function markAsReactComponent(element, component) {
  element[REACT_COMPONENT_KEY] = component;
}

function getReactComponent(element) {
  return element[REACT_COMPONENT_KEY];
}

// 使用
const div = document.createElement('div');
markAsReactComponent(div, 'MyComponent');
console.log(getReactComponent(div)); // 'MyComponent'
console.log(Object.keys(div));       // 不包含我们添加的 Symbol 属性
```

### 3. 实现迭代器协议

```javascript
// 自定义可迭代对象
class NumberRange {
  constructor(start, end) {
    this.start = start;
    this.end = end;
  }
  
  // 实现 Symbol.iterator
  [Symbol.iterator]() {
    let current = this.start;
    const end = this.end;
    
    return {
      next() {
        if (current <= end) {
          return { value: current++, done: false };
        } else {
          return { done: true };
        }
      }
    };
  }
}

const range = new NumberRange(1, 3);
for (const num of range) {
  console.log(num); // 1, 2, 3
}

// 转换为数组
console.log([...range]); // [1, 2, 3]
```

### 4. 定义对象的默认行为

```javascript
class MyClass {
  constructor(value) {
    this.value = value;
  }
  
  // 定义对象转换为原始值时的行为
  [Symbol.toPrimitive](hint) {
    switch (hint) {
      case 'number':
        return this.value;
      case 'string':
        return `MyClass(${this.value})`;
      default:
        return this.value;
    }
  }
  
  // 定义对象的字符串表示
  [Symbol.toStringTag]() {
    return 'MyClass';
  }
}

const obj = new MyClass(42);
console.log(+obj);                    // 42 (转换为数字)
console.log(`${obj}`);                // "MyClass(42)" (转换为字符串)
console.log(Object.prototype.toString.call(obj)); // "[object MyClass]"
```

## 🔍 内置 Symbol

JavaScript 提供了许多内置的 Symbol，用于定义对象的特殊行为：

```javascript
// Symbol.iterator - 定义对象的默认迭代器
const iterableObj = {
  data: [1, 2, 3],
  [Symbol.iterator]() {
    let index = 0;
    return {
      next: () => {
        if (index < this.data.length) {
          return { value: this.data[index++], done: false };
        }
        return { done: true };
      }
    };
  }
};

// Symbol.hasInstance - 自定义 instanceof 行为
class MyArray {
  static [Symbol.hasInstance](instance) {
    return Array.isArray(instance);
  }
}

console.log([] instanceof MyArray); // true

// Symbol.species - 定义创建派生对象时使用的构造函数
class MyArray2 extends Array {
  static get [Symbol.species]() {
    return Array; // 返回普通数组而不是 MyArray2
  }
}

const arr = new MyArray2(1, 2, 3);
const mapped = arr.map(x => x * 2);
console.log(mapped instanceof MyArray2); // false
console.log(mapped instanceof Array);    // true
```

## 🎯 最佳实践

### 1. 使用 Symbol 创建常量

```javascript
// 避免魔法字符串
const Colors = {
  RED: Symbol('red'),
  GREEN: Symbol('green'),
  BLUE: Symbol('blue')
};

function getColorName(color) {
  switch (color) {
    case Colors.RED:
      return '红色';
    case Colors.GREEN:
      return '绿色';
    case Colors.BLUE:
      return '蓝色';
    default:
      return '未知颜色';
  }
}
```

### 2. 创建模块级私有标识符

```javascript
// 模块内部使用的私有 Symbol
const PRIVATE_METHOD = Symbol('privateMethod');
const PRIVATE_PROPERTY = Symbol('privateProperty');

export class PublicClass {
  constructor() {
    this[PRIVATE_PROPERTY] = 'private data';
  }
  
  publicMethod() {
    return this[PRIVATE_METHOD]();
  }
  
  [PRIVATE_METHOD]() {
    return `Accessing: ${this[PRIVATE_PROPERTY]}`;
  }
}
```

### 3. 实现元编程

```javascript
// 使用 Symbol 实现对象的元数据
const METADATA = Symbol('metadata');

class Component {
  constructor(name) {
    this.name = name;
    this[METADATA] = {
      created: new Date(),
      version: '1.0.0'
    };
  }
  
  getMetadata() {
    return this[METADATA];
  }
}

// 工具函数
function hasMetadata(obj) {
  return METADATA in obj;
}

function getMetadata(obj) {
  return obj[METADATA];
}
```

## ⚠️ 注意事项

### 1. Symbol 不能被自动转换为字符串
```javascript
const sym = Symbol('test');

// 错误
// console.log('Symbol: ' + sym); // TypeError

// 正确
console.log('Symbol: ' + sym.toString()); // "Symbol: Symbol(test)"
console.log(`Symbol: ${sym.description}`); // "Symbol: test"
```

### 2. JSON 序列化会忽略 Symbol 属性
```javascript
const obj = {
  [Symbol('key')]: 'value',
  normalKey: 'normalValue'
};

console.log(JSON.stringify(obj)); // {"normalKey":"normalValue"}
```

### 3. Symbol 不是私有的，只是不易访问
```javascript
const PRIVATE_KEY = Symbol('private');
const obj = { [PRIVATE_KEY]: 'secret' };

// 仍然可以通过反射获取
const symbols = Object.getOwnPropertySymbols(obj);
console.log(obj[symbols[0]]); // 'secret'
```

## 📚 总结

Symbol 的主要特点和用途：

### ✅ 优势
- **唯一性**：每个 Symbol 都是独一无二的
- **隐藏性**：不会出现在常规属性枚举中
- **无冲突**：避免属性名冲突
- **元编程**：支持自定义对象行为

### 🎯 适用场景
- 创建对象的私有属性
- 防止第三方库属性名冲突
- 实现迭代器和其他协议
- 定义对象的元数据
- 创建枚举常量

### ⚠️ 限制
- 不能被 JSON 序列化
- 不能自动转换为字符串
- 不是真正的私有（可通过反射访问）

通过合理使用 Symbol，你可以编写更加健壮和安全的 JavaScript 代码！🚀 