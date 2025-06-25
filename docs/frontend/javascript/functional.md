# JavaScript 函数式编程

## 函数式编程基础

### 什么是函数式编程？

函数式编程是一种编程范式，它将计算视为数学函数的求值，避免状态改变和可变数据。

### 核心概念
- **纯函数**：相同输入总是产生相同输出，无副作用
- **不可变性**：数据一旦创建就不能修改
- **高阶函数**：接受或返回函数的函数
- **函数组合**：将多个函数组合成新函数

## 纯函数

### 什么是纯函数？
```javascript
// 纯函数示例
function add(a, b) {
    return a + b;
}

function multiply(a, b) {
    return a * b;
}

// 非纯函数示例
let count = 0;
function impureIncrement() {
    count++; // 修改外部状态
    return count;
}

function impureRandom() {
    return Math.random(); // 输出不确定
}
```

### 纯函数的优势
```javascript
// 可预测性
console.log(add(2, 3)); // 总是返回 5
console.log(add(2, 3)); // 总是返回 5

// 可测试性
function calculateTax(price, rate) {
    return price * rate;
}

// 容易测试
console.log(calculateTax(100, 0.1) === 10); // true
```

## 高阶函数

### 接受函数作为参数
```javascript
function applyOperation(a, b, operation) {
    return operation(a, b);
}

const add = (x, y) => x + y;
const multiply = (x, y) => x * y;

console.log(applyOperation(5, 3, add)); // 8
console.log(applyOperation(5, 3, multiply)); // 15
```

### 返回函数
```javascript
function createMultiplier(factor) {
    return function(number) {
        return number * factor;
    };
}

const double = createMultiplier(2);
const triple = createMultiplier(3);

console.log(double(5)); // 10
console.log(triple(4)); // 12
```

## 常用的高阶函数

### map() - 转换数组
```javascript
const numbers = [1, 2, 3, 4, 5];

// 平方
const squares = numbers.map(n => n * n);
console.log(squares); // [1, 4, 9, 16, 25]

// 转换对象
const users = [
    { name: '张三', age: 25 },
    { name: '李四', age: 30 }
];

const names = users.map(user => user.name);
console.log(names); // ['张三', '李四']
```

### filter() - 过滤数组
```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// 过滤偶数
const evenNumbers = numbers.filter(n => n % 2 === 0);
console.log(evenNumbers); // [2, 4, 6, 8, 10]

// 过滤对象
const adults = users.filter(user => user.age >= 18);
```

### reduce() - 归约数组
```javascript
const numbers = [1, 2, 3, 4, 5];

// 求和
const sum = numbers.reduce((acc, curr) => acc + curr, 0);
console.log(sum); // 15

// 求最大值
const max = numbers.reduce((acc, curr) => Math.max(acc, curr));
console.log(max); // 5

// 计数
const fruits = ['apple', 'banana', 'apple', 'orange', 'banana'];
const count = fruits.reduce((acc, fruit) => {
    acc[fruit] = (acc[fruit] || 0) + 1;
    return acc;
}, {});
console.log(count); // { apple: 2, banana: 2, orange: 1 }
```

## 函数组合

### 基本组合
```javascript
const add = x => y => x + y;
const multiply = x => y => x * y;
const square = x => x * x;

// 函数组合
function compose(f, g) {
    return function(x) {
        return f(g(x));
    };
}

const addThenSquare = compose(square, add(5));
console.log(addThenSquare(3)); // (3 + 5)² = 64
```

### 管道操作
```javascript
function pipe(...functions) {
    return function(value) {
        return functions.reduce((acc, fn) => fn(acc), value);
    };
}

const pipeline = pipe(
    x => x + 1,
    x => x * 2,
    x => x - 3
);

console.log(pipeline(5)); // ((5 + 1) * 2) - 3 = 9
```

## 柯里化

### 什么是柯里化？
```javascript
// 普通函数
function add(a, b, c) {
    return a + b + c;
}

// 柯里化函数
function curriedAdd(a) {
    return function(b) {
        return function(c) {
            return a + b + c;
        };
    };
}

// 使用箭头函数简化
const curriedAddArrow = a => b => c => a + b + c;

console.log(curriedAdd(1)(2)(3)); // 6
console.log(curriedAddArrow(1)(2)(3)); // 6
```

### 柯里化的实际应用
```javascript
// 通用柯里化工具
function curry(fn) {
    return function curried(...args) {
        if (args.length >= fn.length) {
            return fn.apply(this, args);
        }
        return function(...nextArgs) {
            return curried(...args, ...nextArgs);
        };
    };
}

// 应用示例
const multiply = (a, b, c) => a * b * c;
const curriedMultiply = curry(multiply);

const multiplyBy2 = curriedMultiply(2);
const multiplyBy2And3 = multiplyBy2(3);

console.log(multiplyBy2And3(4)); // 24
```

## 不可变性

### 避免数组变异
```javascript
const numbers = [1, 2, 3];

// 错误方式 - 变异原数组
// numbers.push(4);

// 正确方式 - 创建新数组
const newNumbers = [...numbers, 4];
const filtered = numbers.filter(n => n > 1);
const mapped = numbers.map(n => n * 2);

console.log(numbers); // [1, 2, 3] - 原数组未改变
console.log(newNumbers); // [1, 2, 3, 4]
```

### 避免对象变异
```javascript
const user = { name: '张三', age: 25 };

// 错误方式 - 变异原对象
// user.age = 26;

// 正确方式 - 创建新对象
const updatedUser = { ...user, age: 26 };
const userWithEmail = { ...user, email: 'zhang@example.com' };

console.log(user); // { name: '张三', age: 25 } - 原对象未改变
console.log(updatedUser); // { name: '张三', age: 26 }
```

## 递归

### 基础递归
```javascript
// 阶乘
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

console.log(factorial(5)); // 120

// 斐波那契数列
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

console.log(fibonacci(10)); // 55
```

### 尾递归优化
```javascript
// 尾递归阶乘
function tailFactorial(n, acc = 1) {
    if (n <= 1) return acc;
    return tailFactorial(n - 1, acc * n);
}

console.log(tailFactorial(5)); // 120
```

## 实际应用示例

### 数据处理管道
```javascript
const students = [
    { name: '张三', age: 20, grade: 85 },
    { name: '李四', age: 19, grade: 92 },
    { name: '王五', age: 21, grade: 78 },
    { name: '赵六', age: 20, grade: 88 }
];

// 函数式数据处理
const result = students
    .filter(student => student.grade >= 80)  // 筛选成绩 >= 80
    .map(student => ({                       // 转换数据结构
        ...student,
        level: student.grade >= 90 ? '优秀' : '良好'
    }))
    .sort((a, b) => b.grade - a.grade)      // 按成绩降序排列
    .map(student => student.name);          // 只取姓名

console.log(result); // ['李四', '赵六', '张三']
```

### 函数组合工具
```javascript
// 通用工具函数
const isEven = x => x % 2 === 0;
const isPositive = x => x > 0;
const square = x => x * x;
const double = x => x * 2;

// 组合条件检查
const isEvenAndPositive = x => isEven(x) && isPositive(x);

// 数据处理
const numbers = [-2, -1, 0, 1, 2, 3, 4, 5];

const processedNumbers = numbers
    .filter(isEvenAndPositive)
    .map(square)
    .map(double);

console.log(processedNumbers); // [8, 32, 72]
```

### 异步函数组合
```javascript
// Promise 组合
const fetchUser = id => Promise.resolve({ id, name: `用户${id}` });
const fetchUserPosts = user => Promise.resolve([
    { id: 1, title: '文章1' },
    { id: 2, title: '文章2' }
]);

// 函数式异步处理
const getUserWithPosts = async (userId) => {
    const user = await fetchUser(userId);
    const posts = await fetchUserPosts(user);
    return { ...user, posts };
};

// 或使用函数组合
const composeAsync = (...fns) => (value) =>
    fns.reduce(async (acc, fn) => fn(await acc), value);

const processUser = composeAsync(
    fetchUser,
    fetchUserPosts
);
```

## 总结

函数式编程的核心要点：

1. **纯函数**：保证函数的可预测性和可测试性
2. **不可变性**：避免数据变异，创建新数据结构
3. **高阶函数**：map、filter、reduce 等数组方法
4. **函数组合**：将小函数组合成复杂功能
5. **柯里化**：函数参数的部分应用
6. **递归**：函数式的循环替代方案

函数式编程让代码更加简洁、可维护和可测试。 