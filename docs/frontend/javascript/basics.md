# JavaScript 基础概念

## 变量与数据类型

### 变量声明
JavaScript 中有三种声明变量的方式：

```javascript
// var：函数作用域，可以重复声明
var name = "张三";

// let：块级作用域，不可重复声明
let age = 25;

// const：块级作用域，不可重复声明，不可重新赋值
const PI = 3.14159;
```

### 数据类型

#### 基本数据类型
- **Number**：数字类型
- **String**：字符串类型
- **Boolean**：布尔类型
- **Undefined**：未定义
- **Null**：空值
- **Symbol**：唯一标识符
- **BigInt**：大整数

#### 引用数据类型
- **Object**：对象类型（包括数组、函数等）

```javascript
// 基本数据类型示例
let num = 42;
let str = "Hello World";
let bool = true;
let undef = undefined;
let nul = null;

// 引用数据类型示例
let obj = { name: "张三", age: 25 };
let arr = [1, 2, 3, 4, 5];
let func = function() { return "Hello"; };
```

## 运算符

### 算术运算符
```javascript
let a = 10, b = 3;
console.log(a + b); // 13 加法
console.log(a - b); // 7  减法
console.log(a * b); // 30 乘法
console.log(a / b); // 3.333... 除法
console.log(a % b); // 1  取模
console.log(a ** b); // 1000 幂运算
```

### 比较运算符
```javascript
console.log(5 == "5");  // true  相等（类型转换）
console.log(5 === "5"); // false 严格相等（不转换类型）
console.log(5 != "5");  // false 不等
console.log(5 !== "5"); // true  严格不等
console.log(5 > 3);     // true  大于
console.log(5 < 3);     // false 小于
```

### 逻辑运算符
```javascript
let x = true, y = false;
console.log(x && y); // false 逻辑与
console.log(x || y); // true  逻辑或
console.log(!x);     // false 逻辑非
```

## 控制流程

### 条件语句
```javascript
// if...else
let score = 85;
if (score >= 90) {
    console.log("优秀");
} else if (score >= 80) {
    console.log("良好");
} else if (score >= 60) {
    console.log("及格");
} else {
    console.log("不及格");
}

// switch
let day = "monday";
switch (day) {
    case "monday":
        console.log("周一");
        break;
    case "tuesday":
        console.log("周二");
        break;
    default:
        console.log("其他日期");
}
```

### 循环语句
```javascript
// for 循环
for (let i = 0; i < 5; i++) {
    console.log(i);
}

// while 循环
let count = 0;
while (count < 3) {
    console.log(count);
    count++;
}

// do...while 循环
let num = 0;
do {
    console.log(num);
    num++;
} while (num < 3);

// for...in 循环（遍历对象属性）
let person = { name: "张三", age: 25 };
for (let key in person) {
    console.log(key, person[key]);
}

// for...of 循环（遍历可迭代对象）
let arr = [1, 2, 3];
for (let value of arr) {
    console.log(value);
}
```

## 函数

### 函数声明
```javascript
// 函数声明
function greet(name) {
    return `Hello, ${name}!`;
}

// 函数表达式
const greet2 = function(name) {
    return `Hello, ${name}!`;
};

// 箭头函数
const greet3 = (name) => `Hello, ${name}!`;
const greet4 = name => `Hello, ${name}!`; // 单个参数可省略括号
```

### 函数参数
```javascript
// 默认参数
function greet(name = "访客") {
    return `Hello, ${name}!`;
}

// 剩余参数
function sum(...numbers) {
    return numbers.reduce((total, num) => total + num, 0);
}

console.log(sum(1, 2, 3, 4)); // 10
```

## 作用域和闭包

### 作用域
```javascript
// 全局作用域
var globalVar = "全局变量";

function outerFunction() {
    // 函数作用域
    var outerVar = "外部变量";
    
    function innerFunction() {
        // 内部函数可以访问外部变量
        console.log(outerVar); // "外部变量"
        console.log(globalVar); // "全局变量"
    }
    
    innerFunction();
}
```

### 闭包
```javascript
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

## 总结

JavaScript 基础概念包括：
- 变量声明和数据类型
- 运算符和表达式
- 控制流程语句
- 函数定义和调用
- 作用域和闭包

掌握这些基础知识是学习 JavaScript 的第一步，为后续的高级概念打下坚实基础。 