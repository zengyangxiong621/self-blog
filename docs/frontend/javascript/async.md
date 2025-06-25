# JavaScript 异步编程

## 异步编程基础

### 什么是异步编程？

异步编程是一种编程范式，允许程序在等待某些操作完成时继续执行其他任务，而不是阻塞程序的执行。

### 为什么需要异步编程？

```javascript
// 同步代码示例
console.log("开始");
// 假设这是一个耗时操作
for (let i = 0; i < 1000000000; i++) {
    // 一些计算...
}
console.log("结束");
```

在上面的例子中，程序会等待循环完成后才执行 `console.log("结束")`，这会导致页面无响应。

## 回调函数

### 基本概念
回调函数是作为参数传递给另一个函数的函数。

```javascript
function fetchData(callback) {
    setTimeout(() => {
        const data = "获取到的数据";
        callback(data);
    }, 1000);
}

fetchData((data) => {
    console.log(data); // "获取到的数据"
});
```

### 回调地狱
当多个异步操作需要按顺序执行时，可能会出现回调地狱：

```javascript
fetchData1((data1) => {
    fetchData2(data1, (data2) => {
        fetchData3(data2, (data3) => {
            fetchData4(data3, (data4) => {
                // 这里的嵌套层级太深了...
                console.log(data4);
            });
        });
    });
});
```

## Promise

### Promise 基础
Promise 是处理异步操作的一种更优雅的方式。

```javascript
// 创建 Promise
const promise = new Promise((resolve, reject) => {
    setTimeout(() => {
        const success = true;
        if (success) {
            resolve("操作成功");
        } else {
            reject("操作失败");
        }
    }, 1000);
});

// 使用 Promise
promise
    .then(result => {
        console.log(result); // "操作成功"
    })
    .catch(error => {
        console.log(error);
    });
```

### Promise 状态
Promise 有三种状态：
- **Pending**：待定状态
- **Fulfilled**：已成功
- **Rejected**：已拒绝

### Promise 链式调用
```javascript
fetchData()
    .then(data1 => {
        console.log("第一步:", data1);
        return processData(data1);
    })
    .then(data2 => {
        console.log("第二步:", data2);
        return processData(data2);
    })
    .then(data3 => {
        console.log("第三步:", data3);
    })
    .catch(error => {
        console.log("错误:", error);
    });
```

### Promise 静态方法

#### Promise.all()
```javascript
const promises = [
    fetchData1(),
    fetchData2(),
    fetchData3()
];

Promise.all(promises)
    .then(results => {
        console.log("所有数据:", results);
    })
    .catch(error => {
        console.log("有一个失败了:", error);
    });
```

#### Promise.race()
```javascript
const promises = [
    fetchData1(),
    fetchData2(),
    fetchData3()
];

Promise.race(promises)
    .then(result => {
        console.log("最快的结果:", result);
    })
    .catch(error => {
        console.log("最快的错误:", error);
    });
```

#### Promise.allSettled()
```javascript
Promise.allSettled(promises)
    .then(results => {
        results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
                console.log(`Promise ${index} 成功:`, result.value);
            } else {
                console.log(`Promise ${index} 失败:`, result.reason);
            }
        });
    });
```

## async/await

### 基本语法
```javascript
async function fetchData() {
    try {
        const data = await getData();
        console.log(data);
    } catch (error) {
        console.log("错误:", error);
    }
}
```

### 对比 Promise 和 async/await

```javascript
// 使用 Promise
function fetchUserData() {
    return fetchUser()
        .then(user => {
            return fetchUserPosts(user.id);
        })
        .then(posts => {
            return fetchPostComments(posts[0].id);
        })
        .then(comments => {
            return { user, posts, comments };
        })
        .catch(error => {
            console.log("错误:", error);
        });
}

// 使用 async/await
async function fetchUserData() {
    try {
        const user = await fetchUser();
        const posts = await fetchUserPosts(user.id);
        const comments = await fetchPostComments(posts[0].id);
        return { user, posts, comments };
    } catch (error) {
        console.log("错误:", error);
    }
}
```

### 并行执行
```javascript
// 串行执行（慢）
async function fetchDataSerial() {
    const data1 = await fetchData1(); // 等待 1 秒
    const data2 = await fetchData2(); // 等待 1 秒
    const data3 = await fetchData3(); // 等待 1 秒
    // 总计 3 秒
}

// 并行执行（快）
async function fetchDataParallel() {
    const [data1, data2, data3] = await Promise.all([
        fetchData1(),
        fetchData2(),
        fetchData3()
    ]);
    // 总计 1 秒（最慢的那个）
}
```

## 事件循环机制

### 执行栈和任务队列
```javascript
console.log("1");

setTimeout(() => {
    console.log("2");
}, 0);

Promise.resolve().then(() => {
    console.log("3");
});

console.log("4");

// 输出顺序：1, 4, 3, 2
```

### 宏任务和微任务
- **宏任务**：setTimeout、setInterval、I/O 操作
- **微任务**：Promise.then、queueMicrotask

```javascript
console.log("开始");

setTimeout(() => console.log("宏任务 1"), 0);

Promise.resolve().then(() => {
    console.log("微任务 1");
    return Promise.resolve();
}).then(() => {
    console.log("微任务 2");
});

setTimeout(() => console.log("宏任务 2"), 0);

console.log("结束");

// 输出：开始 -> 结束 -> 微任务 1 -> 微任务 2 -> 宏任务 1 -> 宏任务 2
```

## 实际应用示例

### 网络请求
```javascript
// 使用 fetch API
async function getUserData(userId) {
    try {
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const userData = await response.json();
        return userData;
    } catch (error) {
        console.error("获取用户数据失败:", error);
        throw error;
    }
}

// 使用
getUserData(123)
    .then(user => {
        console.log("用户信息:", user);
    })
    .catch(error => {
        console.log("处理错误:", error);
    });
```

### 文件读取
```javascript
function readFile(filename) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.onerror = () => reject(reader.error);
        reader.readAsText(filename);
    });
}

async function processFile(file) {
    try {
        const content = await readFile(file);
        const processedContent = content.toUpperCase();
        return processedContent;
    } catch (error) {
        console.error("文件处理失败:", error);
    }
}
```

## 错误处理

### Promise 错误处理
```javascript
fetchData()
    .then(data => {
        // 处理数据
        return processData(data);
    })
    .catch(error => {
        // 处理错误
        console.error("操作失败:", error);
        return "默认值"; // 提供默认值
    })
    .finally(() => {
        // 无论成功失败都会执行
        console.log("清理工作");
    });
```

### async/await 错误处理
```javascript
async function handleAsyncOperation() {
    try {
        const data = await fetchData();
        const result = await processData(data);
        return result;
    } catch (error) {
        console.error("操作失败:", error);
        // 可以重新抛出错误或返回默认值
        throw error;
    } finally {
        console.log("清理工作");
    }
}
```

## 总结

异步编程是 JavaScript 的核心概念之一：
- 回调函数是最基础的异步处理方式
- Promise 提供了更好的错误处理和链式调用
- async/await 让异步代码看起来像同步代码
- 理解事件循环机制有助于写出更好的异步代码

掌握异步编程对于现代 JavaScript 开发至关重要。 