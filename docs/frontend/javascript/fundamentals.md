# JavaScript 基础知识大全

JavaScript 是一门动态的、弱类型的解释性编程语言，是前端开发的核心技术。本文将系统性地介绍 JavaScript 的基础知识点。

## 基础语法

### 变量声明
```javascript
// var：函数作用域，存在变量提升
var name = 'JavaScript';

// let：块级作用域，不存在变量提升
let age = 25;

// const：块级作用域，声明时必须初始化，不能重新赋值
const PI = 3.14159;
```

### 数据类型

#### 原始类型（Primitive Types）
```javascript
// 1. undefined - 未定义
let undefinedVar;
console.log(typeof undefinedVar); // "undefined"

// 2. null - 空值
let nullVar = null;
console.log(typeof nullVar); // "object" (这是一个历史遗留问题)

// 3. boolean - 布尔值
let isTrue = true;
let isFalse = false;

// 4. number - 数字
let integer = 42;
let float = 3.14;
let scientific = 1e5; // 100000

// 5. string - 字符串
let singleQuote = 'Hello';
let doubleQuote = "World";
let templateString = `Hello ${singleQuote}`;

// 6. symbol - 符号（ES6+）
let symbol1 = Symbol('description');
let symbol2 = Symbol('description');
console.log(symbol1 === symbol2); // false

// 7. bigint - 大整数（ES2020+）
let bigNumber = 1234567890123456789012345678901234567890n;
```

#### 引用类型（Reference Types）
```javascript
// Object - 对象
let person = {
  name: 'John',
  age: 30,
  greet: function() {
    console.log('Hello!');
  }
};

// Array - 数组
let numbers = [1, 2, 3, 4, 5];
let mixed = [1, 'hello', true, null, { key: 'value' }];

// Function - 函数
function add(a, b) {
  return a + b;
}

// Date - 日期
let now = new Date();
let specificDate = new Date('2024-01-01');

// RegExp - 正则表达式
let pattern = /hello/gi;
let regex = new RegExp('hello', 'gi');
```

### 类型检测
```javascript
// typeof 操作符
console.log(typeof 42);          // "number"
console.log(typeof 'hello');     // "string"
console.log(typeof true);        // "boolean"
console.log(typeof undefined);   // "undefined"
console.log(typeof null);        // "object" (历史问题)
console.log(typeof {});          // "object"
console.log(typeof []);          // "object"
console.log(typeof function(){}); // "function"

// instanceof 操作符
console.log([] instanceof Array);        // true
console.log({} instanceof Object);       // true
console.log(new Date() instanceof Date); // true

// 更精确的类型检测
function getType(value) {
  return Object.prototype.toString.call(value).slice(8, -1);
}

console.log(getType([]));        // "Array"
console.log(getType({}));        // "Object"
console.log(getType(null));      // "Null"
console.log(getType(new Date())); // "Date"
```

## 函数

### 函数声明与表达式
```javascript
// 函数声明 - 存在函数提升
function declaration() {
  return 'I am a function declaration';
}

// 函数表达式 - 不存在函数提升
const expression = function() {
  return 'I am a function expression';
};

// 箭头函数（ES6+）
const arrow = () => 'I am an arrow function';
const arrowWithParams = (a, b) => a + b;
const arrowWithBlock = (x) => {
  const result = x * 2;
  return result;
};
```

### 函数参数
```javascript
// 默认参数
function greet(name = 'World') {
  return `Hello, ${name}!`;
}

// 剩余参数
function sum(...numbers) {
  return numbers.reduce((total, num) => total + num, 0);
}

// 解构参数
function createUser({ name, age, email }) {
  return { name, age, email, id: Date.now() };
}

const user = createUser({ name: 'John', age: 30, email: 'john@example.com' });
```

### 作用域与闭包
```javascript
// 作用域示例
var globalVar = 'I am global';

function outerFunction() {
  var outerVar = 'I am outer';
  
  function innerFunction() {
    var innerVar = 'I am inner';
    console.log(globalVar); // 可以访问
    console.log(outerVar);  // 可以访问
    console.log(innerVar);  // 可以访问
  }
  
  innerFunction();
  // console.log(innerVar); // 错误：不能访问内部变量
}

// 闭包示例
function createCounter() {
  let count = 0;
  
  return function() {
    count++;
    return count;
  };
}

const counter = createCounter();
console.log(counter()); // 1
console.log(counter()); // 2
console.log(counter()); // 3
```

## 对象

### 对象创建与操作
```javascript
// 对象字面量
const person = {
  name: 'John',
  age: 30,
  city: 'New York',
  
  // 方法
  greet() {
    return `Hello, I'm ${this.name}`;
  },
  
  // 计算属性名
  ['full' + 'Name']: 'John Doe'
};

// 属性访问
console.log(person.name);        // 点语法
console.log(person['age']);      // 方括号语法
console.log(person.greet());     // 方法调用

// 属性操作
person.email = 'john@example.com'; // 添加属性
delete person.city;                // 删除属性

// 属性枚举
for (let key in person) {
  console.log(key, person[key]);
}

Object.keys(person).forEach(key => {
  console.log(key, person[key]);
});
```

### this 关键字
```javascript
const obj = {
  name: 'Object',
  
  regularFunction: function() {
    console.log(this.name); // 'Object'
  },
  
  arrowFunction: () => {
    console.log(this.name); // undefined (箭头函数没有自己的 this)
  },
  
  nestedFunction: function() {
    const inner = function() {
      console.log(this.name); // undefined (普通函数中的 this)
    };
    
    const innerArrow = () => {
      console.log(this.name); // 'Object' (继承外层的 this)
    };
    
    inner();
    innerArrow();
  }
};

// call、apply、bind
function introduce(greeting, punctuation) {
  return `${greeting}, I'm ${this.name}${punctuation}`;
}

const person = { name: 'John' };

console.log(introduce.call(person, 'Hello', '!'));
console.log(introduce.apply(person, ['Hi', '.']));

const boundIntroduce = introduce.bind(person, 'Hey');
console.log(boundIntroduce('?'));
```

## 数组

### 数组操作方法
```javascript
const numbers = [1, 2, 3, 4, 5];

// 变更方法（会修改原数组）
numbers.push(6);           // 末尾添加
numbers.pop();             // 末尾删除
numbers.unshift(0);        // 开头添加
numbers.shift();           // 开头删除
numbers.splice(2, 1, 'x'); // 从索引2开始删除1个元素，插入'x'

// 非变更方法（返回新数组）
const doubled = numbers.map(x => x * 2);
const evens = numbers.filter(x => x % 2 === 0);
const sum = numbers.reduce((acc, x) => acc + x, 0);

// 查找方法
const found = numbers.find(x => x > 3);
const foundIndex = numbers.findIndex(x => x > 3);
const hasEven = numbers.some(x => x % 2 === 0);
const allPositive = numbers.every(x => x > 0);

// 迭代方法
numbers.forEach((value, index, array) => {
  console.log(`Index ${index}: ${value}`);
});

// 数组解构
const [first, second, ...rest] = numbers;
console.log(first, second, rest);
```

## 原型与继承

### 原型链
```javascript
// 构造函数
function Person(name, age) {
  this.name = name;
  this.age = age;
}

// 原型方法
Person.prototype.greet = function() {
  return `Hello, I'm ${this.name}`;
};

Person.prototype.getAge = function() {
  return this.age;
};

// 创建实例
const john = new Person('John', 30);
console.log(john.greet()); // "Hello, I'm John"

// 原型链查找
console.log(john.hasOwnProperty('name')); // true
console.log(john.hasOwnProperty('greet')); // false
console.log('greet' in john); // true

// 继承
function Student(name, age, school) {
  Person.call(this, name, age); // 调用父构造函数
  this.school = school;
}

// 设置原型链
Student.prototype = Object.create(Person.prototype);
Student.prototype.constructor = Student;

// 添加子类方法
Student.prototype.study = function() {
  return `${this.name} is studying at ${this.school}`;
};

const student = new Student('Alice', 20, 'MIT');
console.log(student.greet()); // 继承的方法
console.log(student.study()); // 自己的方法
```

### ES6 类语法
```javascript
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  
  greet() {
    return `Hello, I'm ${this.name}`;
  }
  
  static species() {
    return 'Homo sapiens';
  }
}

class Student extends Person {
  constructor(name, age, school) {
    super(name, age); // 调用父类构造函数
    this.school = school;
  }
  
  study() {
    return `${this.name} is studying at ${this.school}`;
  }
  
  // 重写父类方法
  greet() {
    return `${super.greet()} and I study at ${this.school}`;
  }
}

const student = new Student('Bob', 22, 'Stanford');
console.log(student.greet());
console.log(Person.species());
```

## 异步编程

### Promise
```javascript
// 创建 Promise
const fetchData = (success = true) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (success) {
        resolve('Data fetched successfully');
      } else {
        reject(new Error('Failed to fetch data'));
      }
    }, 1000);
  });
};

// 使用 Promise
fetchData()
  .then(data => {
    console.log(data);
    return 'Processing data';
  })
  .then(result => {
    console.log(result);
  })
  .catch(error => {
    console.error(error.message);
  })
  .finally(() => {
    console.log('Operation completed');
  });

// Promise 静态方法
const promises = [
  fetchData(),
  fetchData(),
  fetchData()
];

Promise.all(promises)
  .then(results => console.log('All succeeded:', results))
  .catch(error => console.log('At least one failed:', error));

Promise.race(promises)
  .then(result => console.log('First completed:', result))
  .catch(error => console.log('First failed:', error));
```

### async/await
```javascript
// async 函数
async function fetchUserData(userId) {
  try {
    const user = await fetch(`/users/${userId}`);
    const userData = await user.json();
    
    const posts = await fetch(`/users/${userId}/posts`);
    const postsData = await posts.json();
    
    return {
      user: userData,
      posts: postsData
    };
  } catch (error) {
    console.error('Error fetching user data:', error);
    throw error;
  }
}

// 使用 async/await
async function main() {
  try {
    const data = await fetchUserData(123);
    console.log(data);
  } catch (error) {
    console.error('Main error:', error);
  }
}

// 并行执行
async function fetchMultipleUsers() {
  const userPromises = [1, 2, 3].map(id => fetchUserData(id));
  const users = await Promise.all(userPromises);
  return users;
}
```

## ES6+ 新特性

### 解构赋值
```javascript
// 数组解构
const [a, b, c] = [1, 2, 3];
const [first, , third] = [1, 2, 3]; // 跳过元素
const [x, y, ...rest] = [1, 2, 3, 4, 5];

// 对象解构
const { name, age } = { name: 'John', age: 30, city: 'NYC' };
const { name: fullName, age: years } = person; // 重命名
const { email = 'N/A' } = person; // 默认值

// 函数参数解构
function greet({ name, age = 0 }) {
  return `Hello ${name}, you are ${age} years old`;
}
```

### 模板字符串
```javascript
const name = 'World';
const greeting = `Hello, ${name}!`;

// 多行字符串
const multiline = `
  This is a
  multiline
  string
`;

// 标签模板
function highlight(strings, ...values) {
  return strings.reduce((result, string, i) => {
    const value = values[i] ? `<mark>${values[i]}</mark>` : '';
    return result + string + value;
  }, '');
}

const user = 'John';
const age = 30;
const message = highlight`User ${user} is ${age} years old`;
```

### Set 和 Map
```javascript
// Set - 唯一值的集合
const uniqueNumbers = new Set([1, 2, 3, 3, 4, 4, 5]);
console.log(uniqueNumbers); // Set {1, 2, 3, 4, 5}

uniqueNumbers.add(6);
uniqueNumbers.delete(1);
console.log(uniqueNumbers.has(2)); // true
console.log(uniqueNumbers.size); // 5

// Map - 键值对集合
const userRoles = new Map();
userRoles.set('john', 'admin');
userRoles.set('jane', 'user');
userRoles.set(123, 'guest'); // 任意类型的键

console.log(userRoles.get('john')); // 'admin'
console.log(userRoles.has('jane')); // true
console.log(userRoles.size); // 3

// 遍历
for (const [key, value] of userRoles) {
  console.log(key, value);
}
```

## 错误处理

### try/catch/finally
```javascript
function divide(a, b) {
  try {
    if (b === 0) {
      throw new Error('Division by zero is not allowed');
    }
    return a / b;
  } catch (error) {
    console.error('Error occurred:', error.message);
    return null;
  } finally {
    console.log('Division operation completed');
  }
}

// 自定义错误类
class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.name = 'ValidationError';
  }
}

function validateEmail(email) {
  if (!email.includes('@')) {
    throw new ValidationError('Invalid email format');
  }
  return true;
}

try {
  validateEmail('invalid-email');
} catch (error) {
  if (error instanceof ValidationError) {
    console.log('Validation failed:', error.message);
  } else {
    console.log('Unexpected error:', error);
  }
}
```

## 性能优化技巧

### 防抖和节流
```javascript
// 防抖 - 延迟执行，如果在延迟期间再次触发，则重新计时
function debounce(func, delay) {
  let timeoutId;
  return function(...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func.apply(this, args), delay);
  };
}

// 节流 - 限制执行频率
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// 使用示例
const searchInput = document.getElementById('search');
const debouncedSearch = debounce((event) => {
  console.log('Searching for:', event.target.value);
}, 300);

searchInput.addEventListener('input', debouncedSearch);
```

### 内存管理
```javascript
// 避免内存泄漏
class EventManager {
  constructor() {
    this.listeners = new Map();
  }
  
  addEventListener(element, event, handler) {
    element.addEventListener(event, handler);
    
    // 记录监听器以便清理
    if (!this.listeners.has(element)) {
      this.listeners.set(element, []);
    }
    this.listeners.get(element).push({ event, handler });
  }
  
  cleanup() {
    // 清理所有事件监听器
    for (const [element, listeners] of this.listeners) {
      listeners.forEach(({ event, handler }) => {
        element.removeEventListener(event, handler);
      });
    }
    this.listeners.clear();
  }
}

// 使用 WeakMap 避免内存泄漏
const elementData = new WeakMap();

function setElementData(element, data) {
  elementData.set(element, data);
}

function getElementData(element) {
  return elementData.get(element);
}
```

## 总结

JavaScript 基础知识涵盖了语法、数据类型、函数、对象、数组、原型、异步编程等核心概念。掌握这些基础知识是成为优秀前端开发者的必要条件。

### 学习建议
1. **循序渐进** - 从基础语法开始，逐步深入
2. **实践为主** - 多写代码，多做练习
3. **理解原理** - 不仅要知道怎么用，还要知道为什么
4. **关注新特性** - 跟上 ECMAScript 标准的发展
5. **代码质量** - 注重代码的可读性和可维护性

通过系统学习和实践，你将能够熟练运用 JavaScript 进行前端开发。 