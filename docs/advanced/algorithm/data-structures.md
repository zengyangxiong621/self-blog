# 数据结构详解

数据结构是计算机科学的基础，也是前端开发中不可或缺的知识。本文将详细介绍常用的数据结构及其在JavaScript中的实现。

## 🏗️ 基础数据结构

### 1. 数组 (Array)
数组是最基本的数据结构，在JavaScript中是动态的。

```javascript
// 数组的基本操作
const arr = [1, 2, 3, 4, 5];

// 访问元素 - O(1)
console.log(arr[0]); // 1

// 添加元素
arr.push(6);        // 末尾添加 - O(1)
arr.unshift(0);     // 开头添加 - O(n)

// 删除元素
arr.pop();          // 末尾删除 - O(1)
arr.shift();        // 开头删除 - O(n)

// 查找元素
arr.indexOf(3);     // 线性查找 - O(n)
arr.includes(4);    // 包含检查 - O(n)
```

**应用场景：**
- 存储有序数据
- 实现其他数据结构的基础
- 缓存和临时存储

### 2. 链表 (Linked List)
链表是一种线性数据结构，元素在内存中不连续存储。

```javascript
// 链表节点
class ListNode {
  constructor(val, next = null) {
    this.val = val;
    this.next = next;
  }
}

// 单向链表
class LinkedList {
  constructor() {
    this.head = null;
    this.size = 0;
  }

  // 添加元素到头部 - O(1)
  prepend(val) {
    this.head = new ListNode(val, this.head);
    this.size++;
  }

  // 添加元素到尾部 - O(n)
  append(val) {
    if (!this.head) {
      this.head = new ListNode(val);
    } else {
      let current = this.head;
      while (current.next) {
        current = current.next;
      }
      current.next = new ListNode(val);
    }
    this.size++;
  }

  // 删除指定值 - O(n)
  delete(val) {
    if (!this.head) return false;

    if (this.head.val === val) {
      this.head = this.head.next;
      this.size--;
      return true;
    }

    let current = this.head;
    while (current.next && current.next.val !== val) {
      current = current.next;
    }

    if (current.next) {
      current.next = current.next.next;
      this.size--;
      return true;
    }

    return false;
  }

  // 查找元素 - O(n)
  find(val) {
    let current = this.head;
    while (current) {
      if (current.val === val) return current;
      current = current.next;
    }
    return null;
  }
}
```

**应用场景：**
- 实现栈和队列
- 浏览器的前进后退功能
- 音乐播放器的播放列表

### 3. 栈 (Stack)
栈是一种后进先出(LIFO)的数据结构。

```javascript
class Stack {
  constructor() {
    this.items = [];
  }

  // 入栈 - O(1)
  push(item) {
    this.items.push(item);
  }

  // 出栈 - O(1)
  pop() {
    return this.items.pop();
  }

  // 查看栈顶元素 - O(1)
  peek() {
    return this.items[this.items.length - 1];
  }

  // 检查是否为空 - O(1)
  isEmpty() {
    return this.items.length === 0;
  }

  // 获取栈大小 - O(1)
  size() {
    return this.items.length;
  }
}

// 使用示例：括号匹配
function isValidParentheses(s) {
  const stack = new Stack();
  const pairs = { '(': ')', '[': ']', '{': '}' };

  for (let char of s) {
    if (pairs[char]) {
      stack.push(char);
    } else if (Object.values(pairs).includes(char)) {
      if (stack.isEmpty() || pairs[stack.pop()] !== char) {
        return false;
      }
    }
  }

  return stack.isEmpty();
}
```

**应用场景：**
- 函数调用栈
- 浏览器历史记录
- 表达式求值
- 语法解析

### 4. 队列 (Queue)
队列是一种先进先出(FIFO)的数据结构。

```javascript
class Queue {
  constructor() {
    this.items = [];
  }

  // 入队 - O(1)
  enqueue(item) {
    this.items.push(item);
  }

  // 出队 - O(n) 使用数组实现
  dequeue() {
    return this.items.shift();
  }

  // 查看队首元素 - O(1)
  front() {
    return this.items[0];
  }

  // 检查是否为空 - O(1)
  isEmpty() {
    return this.items.length === 0;
  }

  // 获取队列大小 - O(1)
  size() {
    return this.items.length;
  }
}

// 优化版本：使用双端队列
class OptimizedQueue {
  constructor() {
    this.items = {};
    this.front = 0;
    this.rear = 0;
  }

  enqueue(item) {
    this.items[this.rear] = item;
    this.rear++;
  }

  dequeue() {
    if (this.isEmpty()) return undefined;
    
    const item = this.items[this.front];
    delete this.items[this.front];
    this.front++;
    return item;
  }

  isEmpty() {
    return this.rear === this.front;
  }

  size() {
    return this.rear - this.front;
  }
}
```

**应用场景：**
- 任务调度
- 广度优先搜索
- 缓冲区管理
- 异步处理队列

## 🌳 树形数据结构

### 1. 二叉树 (Binary Tree)
二叉树是每个节点最多有两个子树的树结构。

```javascript
// 二叉树节点
class TreeNode {
  constructor(val, left = null, right = null) {
    this.val = val;
    this.left = left;
    this.right = right;
  }
}

class BinaryTree {
  constructor() {
    this.root = null;
  }

  // 前序遍历 (根-左-右)
  preorderTraversal(node = this.root, result = []) {
    if (node) {
      result.push(node.val);
      this.preorderTraversal(node.left, result);
      this.preorderTraversal(node.right, result);
    }
    return result;
  }

  // 中序遍历 (左-根-右)
  inorderTraversal(node = this.root, result = []) {
    if (node) {
      this.inorderTraversal(node.left, result);
      result.push(node.val);
      this.inorderTraversal(node.right, result);
    }
    return result;
  }

  // 后序遍历 (左-右-根)
  postorderTraversal(node = this.root, result = []) {
    if (node) {
      this.postorderTraversal(node.left, result);
      this.postorderTraversal(node.right, result);
      result.push(node.val);
    }
    return result;
  }

  // 层序遍历 (广度优先)
  levelOrderTraversal() {
    if (!this.root) return [];
    
    const result = [];
    const queue = [this.root];

    while (queue.length > 0) {
      const node = queue.shift();
      result.push(node.val);

      if (node.left) queue.push(node.left);
      if (node.right) queue.push(node.right);
    }

    return result;
  }

  // 计算树的高度
  getHeight(node = this.root) {
    if (!node) return 0;
    return 1 + Math.max(
      this.getHeight(node.left),
      this.getHeight(node.right)
    );
  }
}
```

### 2. 二叉搜索树 (BST)
二叉搜索树是一种有序的二叉树。

```javascript
class BST extends BinaryTree {
  // 插入节点 - 平均O(log n)，最坏O(n)
  insert(val) {
    this.root = this._insertNode(this.root, val);
  }

  _insertNode(node, val) {
    if (!node) return new TreeNode(val);

    if (val < node.val) {
      node.left = this._insertNode(node.left, val);
    } else if (val > node.val) {
      node.right = this._insertNode(node.right, val);
    }

    return node;
  }

  // 查找节点 - 平均O(log n)，最坏O(n)
  search(val) {
    return this._searchNode(this.root, val);
  }

  _searchNode(node, val) {
    if (!node || node.val === val) return node;

    if (val < node.val) {
      return this._searchNode(node.left, val);
    } else {
      return this._searchNode(node.right, val);
    }
  }

  // 删除节点
  delete(val) {
    this.root = this._deleteNode(this.root, val);
  }

  _deleteNode(node, val) {
    if (!node) return null;

    if (val < node.val) {
      node.left = this._deleteNode(node.left, val);
    } else if (val > node.val) {
      node.right = this._deleteNode(node.right, val);
    } else {
      // 找到要删除的节点
      if (!node.left && !node.right) {
        return null;
      } else if (!node.left) {
        return node.right;
      } else if (!node.right) {
        return node.left;
      } else {
        // 有两个子节点，找到右子树的最小值
        const minRight = this._findMin(node.right);
        node.val = minRight.val;
        node.right = this._deleteNode(node.right, minRight.val);
      }
    }

    return node;
  }

  _findMin(node) {
    while (node.left) {
      node = node.left;
    }
    return node;
  }
}
```

## 📊 哈希表 (Hash Table)
JavaScript的对象和Map都是哈希表的实现。

```javascript
// 简单哈希表实现
class HashTable {
  constructor(size = 10) {
    this.size = size;
    this.buckets = new Array(size).fill(null).map(() => []);
  }

  // 哈希函数
  _hash(key) {
    let hash = 0;
    for (let i = 0; i < key.length; i++) {
      hash = (hash + key.charCodeAt(i) * i) % this.size;
    }
    return hash;
  }

  // 设置键值对 - 平均O(1)
  set(key, value) {
    const index = this._hash(key);
    const bucket = this.buckets[index];

    // 检查是否已存在
    for (let i = 0; i < bucket.length; i++) {
      if (bucket[i][0] === key) {
        bucket[i][1] = value;
        return;
      }
    }

    // 添加新的键值对
    bucket.push([key, value]);
  }

  // 获取值 - 平均O(1)
  get(key) {
    const index = this._hash(key);
    const bucket = this.buckets[index];

    for (let i = 0; i < bucket.length; i++) {
      if (bucket[i][0] === key) {
        return bucket[i][1];
      }
    }

    return undefined;
  }

  // 删除键值对 - 平均O(1)
  delete(key) {
    const index = this._hash(key);
    const bucket = this.buckets[index];

    for (let i = 0; i < bucket.length; i++) {
      if (bucket[i][0] === key) {
        bucket.splice(i, 1);
        return true;
      }
    }

    return false;
  }
}

// 使用Map的现代方式
const map = new Map();
map.set('key1', 'value1');
map.set('key2', 'value2');

console.log(map.get('key1')); // 'value1'
console.log(map.has('key2')); // true
map.delete('key1');
```

## 🔗 图 (Graph)
图是由顶点和边组成的数据结构。

```javascript
// 邻接表实现
class Graph {
  constructor() {
    this.vertices = new Map();
  }

  // 添加顶点
  addVertex(vertex) {
    if (!this.vertices.has(vertex)) {
      this.vertices.set(vertex, []);
    }
  }

  // 添加边
  addEdge(vertex1, vertex2) {
    this.addVertex(vertex1);
    this.addVertex(vertex2);
    
    this.vertices.get(vertex1).push(vertex2);
    this.vertices.get(vertex2).push(vertex1); // 无向图
  }

  // 深度优先搜索
  dfs(startVertex, visited = new Set()) {
    visited.add(startVertex);
    console.log(startVertex);

    const neighbors = this.vertices.get(startVertex);
    for (let neighbor of neighbors) {
      if (!visited.has(neighbor)) {
        this.dfs(neighbor, visited);
      }
    }
  }

  // 广度优先搜索
  bfs(startVertex) {
    const visited = new Set();
    const queue = [startVertex];
    visited.add(startVertex);

    while (queue.length > 0) {
      const vertex = queue.shift();
      console.log(vertex);

      const neighbors = this.vertices.get(vertex);
      for (let neighbor of neighbors) {
        if (!visited.has(neighbor)) {
          visited.add(neighbor);
          queue.push(neighbor);
        }
      }
    }
  }
}
```

## 🎯 实际应用场景

### 前端开发中的数据结构应用

1. **虚拟DOM树** - 使用树结构表示DOM
2. **路由系统** - 使用图结构管理路由关系
3. **状态管理** - 使用哈希表存储应用状态
4. **事件队列** - 使用队列处理异步事件
5. **撤销/重做** - 使用栈管理操作历史

### 性能优化建议

1. **选择合适的数据结构**
   - 频繁查找：使用哈希表
   - 有序数据：使用数组或BST
   - LIFO操作：使用栈
   - FIFO操作：使用队列

2. **空间时间权衡**
   - 哈希表：空间换时间
   - 数组：内存连续，缓存友好
   - 链表：动态大小，插入删除高效

3. **避免常见陷阱**
   - 数组频繁插入删除开头元素
   - 对象作为哈希表时的原型链污染
   - 递归深度过大导致栈溢出

掌握这些数据结构将大大提升你的编程能力和算法思维！🚀 