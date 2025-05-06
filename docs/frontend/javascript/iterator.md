# JavaScript 迭代器详解

## 什么是迭代器

迭代器（Iterator）是一种访问集合元素的方式，它提供了一个统一的接口来遍历不同类型的集合。在 JavaScript 中，迭代器是一个对象，它实现了特定的迭代器协议。

## 迭代器协议

迭代器协议定义了产生一系列值的标准方式。一个对象要成为迭代器，必须实现 `next()` 方法：

```javascript
const iterator = {
  next() {
    return {
      value: any,
      done: boolean
    };
  }
};
```

## 可迭代对象

可迭代对象是实现了 `Symbol.iterator` 方法的对象。这个方法返回一个迭代器对象：

```javascript
const iterableObject = {
  [Symbol.iterator]() {
    return {
      current: 0,
      last: 2,
      next() {
        if (this.current <= this.last) {
          return { value: this.current++, done: false };
        }
        return { value: undefined, done: true };
      }
    };
  }
};

for (const value of iterableObject) {
  console.log(value); // 输出：0, 1, 2
}
```

## 生成器函数

生成器函数是一种特殊的函数，它可以通过 `yield` 关键字暂停执行并返回中间值：

```javascript
function* numberGenerator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = numberGenerator();
console.log(gen.next()); // { value: 1, done: false }
console.log(gen.next()); // { value: 2, done: false }
console.log(gen.next()); // { value: 3, done: false }
console.log(gen.next()); // { value: undefined, done: true }
```

## 实际应用场景

### 1. 惰性计算

```javascript
function* fibonacci() {
  let prev = 0, curr = 1;
  while (true) {
    yield curr;
    [prev, curr] = [curr, prev + curr];
  }
}

const fib = fibonacci();
for (let i = 0; i < 5; i++) {
  console.log(fib.next().value);
}
```

### 2. 异步迭代

```javascript
async function* asyncGenerator() {
  const response = await fetch('https://api.example.com/data');
  const data = await response.json();
  for (const item of data) {
    yield item;
  }
}
```

### 3. 自定义集合

```javascript
class Collection {
  constructor(items) {
    this.items = items;
  }

  *[Symbol.iterator]() {
    for (const item of this.items) {
      yield item;
    }
  }
}

const collection = new Collection([1, 2, 3]);
for (const item of collection) {
  console.log(item);
}
```

## 最佳实践

1. 使用迭代器处理大数据集时，可以避免一次性加载所有数据
2. 配合生成器函数实现更优雅的异步操作流程
3. 在需要自定义遍历行为时，实现迭代器协议
4. 使用 `for...of` 循环来遍历可迭代对象

## 注意事项

1. 迭代器是一次性使用的，遍历完成后需要重新获取迭代器
2. 生成器函数的状态会被保存，直到迭代完成
3. 在异步迭代器中要正确处理错误

## 总结

迭代器是 JavaScript 中一个强大的特性，它提供了一种统一的方式来访问各种集合类型的数据。通过合理使用迭代器和生成器，我们可以写出更简洁、更高效的代码。掌握迭代器的使用对于理解现代 JavaScript 的许多特性都很有帮助。