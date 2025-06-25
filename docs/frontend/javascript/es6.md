# ES6+ 现代 JavaScript 特性

## let 和 const

### 块级作用域
```javascript
// var 的问题
function varExample() {
    if (true) {
        var x = 1;
    }
    console.log(x); // 1 - var 没有块级作用域
}

// let 和 const 的解决方案
function letConstExample() {
    if (true) {
        let y = 1;
        const z = 2;
    }
    // console.log(y); // ReferenceError
    // console.log(z); // ReferenceError
}
```

### 暂时性死区
```javascript
console.log(a); // undefined (var 变量提升)
// console.log(b); // ReferenceError (暂时性死区)

var a = 1;
let b = 2;
```

## 箭头函数

### 基本语法
```javascript
// 传统函数
function add(a, b) {
    return a + b;
}

// 箭头函数
const add = (a, b) => a + b;
const square = x => x * x;  // 单参数可省略括号
const greet = () => 'Hello'; // 无参数需要括号
```

### this 绑定
```javascript
const obj = {
    name: '张三',
    
    // 传统函数 - this 指向调用者
    traditional: function() {
        console.log(this.name); // '张三'
    },
    
    // 箭头函数 - this 继承外层作用域
    arrow: () => {
        console.log(this.name); // undefined (全局 this)
    },
    
    // 实际使用场景
    methods: function() {
        setTimeout(() => {
            console.log(this.name); // '张三' - 继承外层 this
        }, 1000);
    }
};
```

## 模板字符串

### 基本用法
```javascript
const name = '张三';
const age = 25;

// ES5 字符串拼接
const message1 = '你好，我是' + name + '，今年' + age + '岁';

// ES6 模板字符串
const message2 = `你好，我是${name}，今年${age}岁`;

// 多行字符串
const html = `
    <div>
        <h1>${name}</h1>
        <p>年龄：${age}</p>
    </div>
`;
```

### 标签模板
```javascript
function highlight(strings, ...values) {
    return strings.reduce((result, string, i) => {
        const value = values[i] ? `<strong>${values[i]}</strong>` : '';
        return result + string + value;
    }, '');
}

const name = '张三';
const skill = 'JavaScript';
const message = highlight`我是${name}，擅长${skill}开发`;
// 结果：我是<strong>张三</strong>，擅长<strong>JavaScript</strong>开发
```

## 解构赋值

### 数组解构
```javascript
const arr = [1, 2, 3, 4, 5];

// 基本解构
const [first, second] = arr;
console.log(first, second); // 1, 2

// 跳过元素
const [a, , c] = arr;
console.log(a, c); // 1, 3

// 剩余元素
const [head, ...tail] = arr;
console.log(head, tail); // 1, [2, 3, 4, 5]

// 默认值
const [x, y, z = 10] = [1, 2];
console.log(x, y, z); // 1, 2, 10
```

### 对象解构
```javascript
const user = {
    name: '张三',
    age: 25,
    email: 'zhang@example.com',
    address: {
        city: '北京',
        street: '朝阳区'
    }
};

// 基本解构
const { name, age } = user;
console.log(name, age); // '张三', 25

// 重命名
const { name: userName, age: userAge } = user;
console.log(userName, userAge); // '张三', 25

// 默认值
const { phone = '未提供' } = user;
console.log(phone); // '未提供'

// 嵌套解构
const { address: { city } } = user;
console.log(city); // '北京'

// 函数参数解构
function greet({ name, age }) {
    return `你好，${name}，${age}岁`;
}
console.log(greet(user)); // '你好，张三，25岁'
```

## 扩展运算符

### 数组扩展
```javascript
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];

// 合并数组
const merged = [...arr1, ...arr2];
console.log(merged); // [1, 2, 3, 4, 5, 6]

// 复制数组
const copied = [...arr1];
console.log(copied); // [1, 2, 3]

// 函数参数
function sum(...numbers) {
    return numbers.reduce((a, b) => a + b, 0);
}
console.log(sum(1, 2, 3, 4)); // 10
console.log(sum(...arr1)); // 6
```

### 对象扩展
```javascript
const obj1 = { a: 1, b: 2 };
const obj2 = { c: 3, d: 4 };

// 合并对象
const merged = { ...obj1, ...obj2 };
console.log(merged); // { a: 1, b: 2, c: 3, d: 4 }

// 覆盖属性
const updated = { ...obj1, b: 20, e: 5 };
console.log(updated); // { a: 1, b: 20, e: 5 }
```

## 增强的对象字面量

### 属性简写
```javascript
const name = '张三';
const age = 25;

// ES5
const user1 = {
    name: name,
    age: age
};

// ES6 属性简写
const user2 = { name, age };
```

### 方法简写
```javascript
const obj = {
    // ES5
    sayHello: function() {
        return 'Hello';
    },
    
    // ES6 方法简写
    sayHi() {
        return 'Hi';
    },
    
    // 异步方法
    async fetchData() {
        return await fetch('/api/data');
    }
};
```

### 计算属性名
```javascript
const propertyName = 'dynamic';
const obj = {
    [propertyName]: 'value',
    [`${propertyName}Method`]: function() {
        return 'method result';
    }
};
console.log(obj.dynamic); // 'value'
console.log(obj.dynamicMethod()); // 'method result'
```

## 默认参数

```javascript
// ES5 默认参数
function greet1(name, greeting) {
    name = name || '访客';
    greeting = greeting || '你好';
    return greeting + '，' + name;
}

// ES6 默认参数
function greet2(name = '访客', greeting = '你好') {
    return greeting + '，' + name;
}

// 默认参数可以是表达式
function createUser(name, id = Date.now()) {
    return { name, id };
}
```

## 类 (Class)

### 基本类语法
```javascript
class Person {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
    
    greet() {
        return `你好，我是${this.name}`;
    }
    
    static getSpecies() {
        return '智人';
    }
}

const person = new Person('张三', 25);
console.log(person.greet()); // '你好，我是张三'
console.log(Person.getSpecies()); // '智人'
```

### 继承
```javascript
class Student extends Person {
    constructor(name, age, school) {
        super(name, age);
        this.school = school;
    }
    
    study() {
        return `${this.name}在${this.school}学习`;
    }
    
    greet() {
        return super.greet() + `，在${this.school}上学`;
    }
}

const student = new Student('李四', 18, '清华大学');
console.log(student.study()); // '李四在清华大学学习'
```

## 模块 (Modules)

### 导出
```javascript
// math.js
export const PI = 3.14159;

export function add(a, b) {
    return a + b;
}

export class Calculator {
    multiply(a, b) {
        return a * b;
    }
}

// 默认导出
export default function subtract(a, b) {
    return a - b;
}
```

### 导入
```javascript
// 命名导入
import { PI, add, Calculator } from './math.js';

// 默认导入
import subtract from './math.js';

// 全部导入
import * as math from './math.js';

// 混合导入
import subtract, { PI, add } from './math.js';
```

## Promise 和 async/await

### Promise
```javascript
const fetchData = () => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve('数据获取成功');
        }, 1000);
    });
};

fetchData()
    .then(data => console.log(data))
    .catch(error => console.error(error));
```

### async/await
```javascript
async function getData() {
    try {
        const data = await fetchData();
        console.log(data);
    } catch (error) {
        console.error(error);
    }
}
```

## Map 和 Set

### Map
```javascript
const map = new Map();

// 设置值
map.set('name', '张三');
map.set(1, 'number key');
map.set(true, 'boolean key');

// 获取值
console.log(map.get('name')); // '张三'

// 遍历
for (const [key, value] of map) {
    console.log(key, value);
}
```

### Set
```javascript
const set = new Set([1, 2, 3, 3, 4, 4]);
console.log(set); // Set(4) {1, 2, 3, 4}

// 添加值
set.add(5);

// 检查值
console.log(set.has(3)); // true

// 数组去重
const arr = [1, 2, 2, 3, 3, 4];
const unique = [...new Set(arr)];
console.log(unique); // [1, 2, 3, 4]
```

## Symbol

```javascript
// 创建 Symbol
const sym1 = Symbol();
const sym2 = Symbol('description');
const sym3 = Symbol('description');

console.log(sym2 === sym3); // false - 每个 Symbol 都是唯一的

// 对象属性
const obj = {
    [sym1]: 'value1',
    [sym2]: 'value2'
};

console.log(obj[sym1]); // 'value1'
```

## 总结

ES6+ 带来的主要改进：

1. **变量声明**：let/const 替代 var
2. **函数增强**：箭头函数、默认参数
3. **字符串增强**：模板字符串
4. **解构赋值**：方便的数据提取
5. **扩展运算符**：数组和对象操作
6. **类语法**：面向对象编程
7. **模块系统**：代码组织
8. **异步编程**：Promise/async/await
9. **新数据结构**：Map/Set/Symbol

这些特性让 JavaScript 更现代、更强大、更易用。 