# 算法思想总结

算法是解决问题的方法和步骤。掌握常见的算法思想，能够帮助我们更好地分析和解决复杂问题。本文总结了前端开发中常用的算法思想和实现方法。

## 🎯 算法复杂度分析

### 时间复杂度
用来评估算法执行时间随输入规模增长的趋势。

```javascript
// O(1) - 常数时间
function getFirst(arr) {
  return arr[0];
}

// O(n) - 线性时间
function findMax(arr) {
  let max = arr[0];
  for (let i = 1; i < arr.length; i++) {
    if (arr[i] > max) {
      max = arr[i];
    }
  }
  return max;
}

// O(n²) - 平方时间
function bubbleSort(arr) {
  for (let i = 0; i < arr.length; i++) {
    for (let j = 0; j < arr.length - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
      }
    }
  }
  return arr;
}

// O(log n) - 对数时间
function binarySearch(arr, target) {
  let left = 0, right = arr.length - 1;
  
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    if (arr[mid] === target) return mid;
    if (arr[mid] < target) left = mid + 1;
    else right = mid - 1;
  }
  
  return -1;
}
```

### 空间复杂度
用来评估算法使用的额外空间随输入规模增长的趋势。

```javascript
// O(1) - 常数空间
function swap(a, b) {
  [a, b] = [b, a];
  return [a, b];
}

// O(n) - 线性空间
function createCopy(arr) {
  return [...arr];
}

// O(n) - 递归调用栈
function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}
```

## 🔍 搜索算法

### 1. 线性搜索
最简单的搜索算法，逐个检查每个元素。

```javascript
function linearSearch(arr, target) {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] === target) {
      return i;
    }
  }
  return -1;
}

// 时间复杂度: O(n)
// 空间复杂度: O(1)
```

### 2. 二分搜索
在有序数组中快速查找元素。

```javascript
function binarySearch(arr, target) {
  let left = 0;
  let right = arr.length - 1;
  
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    
    if (arr[mid] === target) {
      return mid;
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }
  
  return -1;
}

// 时间复杂度: O(log n)
// 空间复杂度: O(1)

// 递归版本
function binarySearchRecursive(arr, target, left = 0, right = arr.length - 1) {
  if (left > right) return -1;
  
  const mid = Math.floor((left + right) / 2);
  
  if (arr[mid] === target) return mid;
  if (arr[mid] < target) return binarySearchRecursive(arr, target, mid + 1, right);
  return binarySearchRecursive(arr, target, left, mid - 1);
}
```

## 📊 排序算法

### 1. 冒泡排序
重复地遍历数组，比较相邻元素并交换。

```javascript
function bubbleSort(arr) {
  const n = arr.length;
  
  for (let i = 0; i < n; i++) {
    let swapped = false;
    
    for (let j = 0; j < n - i - 1; j++) {
      if (arr[j] > arr[j + 1]) {
        [arr[j], arr[j + 1]] = [arr[j + 1], arr[j]];
        swapped = true;
      }
    }
    
    // 如果没有交换，说明已经有序
    if (!swapped) break;
  }
  
  return arr;
}

// 时间复杂度: O(n²)
// 空间复杂度: O(1)
```

### 2. 选择排序
每次找到最小元素放到已排序部分的末尾。

```javascript
function selectionSort(arr) {
  const n = arr.length;
  
  for (let i = 0; i < n - 1; i++) {
    let minIndex = i;
    
    for (let j = i + 1; j < n; j++) {
      if (arr[j] < arr[minIndex]) {
        minIndex = j;
      }
    }
    
    if (minIndex !== i) {
      [arr[i], arr[minIndex]] = [arr[minIndex], arr[i]];
    }
  }
  
  return arr;
}

// 时间复杂度: O(n²)
// 空间复杂度: O(1)
```

### 3. 插入排序
构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。

```javascript
function insertionSort(arr) {
  for (let i = 1; i < arr.length; i++) {
    let key = arr[i];
    let j = i - 1;
    
    while (j >= 0 && arr[j] > key) {
      arr[j + 1] = arr[j];
      j--;
    }
    
    arr[j + 1] = key;
  }
  
  return arr;
}

// 时间复杂度: O(n²)
// 空间复杂度: O(1)
```

### 4. 快速排序
分治法的典型应用，选择基准元素，将数组分为两部分。

```javascript
function quickSort(arr, low = 0, high = arr.length - 1) {
  if (low < high) {
    const pivotIndex = partition(arr, low, high);
    quickSort(arr, low, pivotIndex - 1);
    quickSort(arr, pivotIndex + 1, high);
  }
  return arr;
}

function partition(arr, low, high) {
  const pivot = arr[high];
  let i = low - 1;
  
  for (let j = low; j < high; j++) {
    if (arr[j] <= pivot) {
      i++;
      [arr[i], arr[j]] = [arr[j], arr[i]];
    }
  }
  
  [arr[i + 1], arr[high]] = [arr[high], arr[i + 1]];
  return i + 1;
}

// 平均时间复杂度: O(n log n)
// 最坏时间复杂度: O(n²)
// 空间复杂度: O(log n)
```

### 5. 归并排序
分治法的另一个典型应用，将数组分成两半，递归排序后合并。

```javascript
function mergeSort(arr) {
  if (arr.length <= 1) return arr;
  
  const mid = Math.floor(arr.length / 2);
  const left = mergeSort(arr.slice(0, mid));
  const right = mergeSort(arr.slice(mid));
  
  return merge(left, right);
}

function merge(left, right) {
  const result = [];
  let i = 0, j = 0;
  
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) {
      result.push(left[i]);
      i++;
    } else {
      result.push(right[j]);
      j++;
    }
  }
  
  return result.concat(left.slice(i)).concat(right.slice(j));
}

// 时间复杂度: O(n log n)
// 空间复杂度: O(n)
```

## 🔄 递归算法

### 基本概念
递归是一种解决问题的方法，其中函数调用自身。

```javascript
// 斐波那契数列
function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// 优化版本：记忆化递归
function fibonacciMemo(n, memo = {}) {
  if (n in memo) return memo[n];
  if (n <= 1) return n;
  
  memo[n] = fibonacciMemo(n - 1, memo) + fibonacciMemo(n - 2, memo);
  return memo[n];
}

// 阶乘
function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

// 汉诺塔问题
function hanoi(n, from, to, aux) {
  if (n === 1) {
    console.log(`Move disk 1 from ${from} to ${to}`);
    return;
  }
  
  hanoi(n - 1, from, aux, to);
  console.log(`Move disk ${n} from ${from} to ${to}`);
  hanoi(n - 1, aux, to, from);
}
```

## 🧠 动态规划

### 基本思想
通过把原问题分解为相对简单的子问题的方式求解复杂问题。

```javascript
// 爬楼梯问题
function climbStairs(n) {
  if (n <= 2) return n;
  
  const dp = new Array(n + 1);
  dp[1] = 1;
  dp[2] = 2;
  
  for (let i = 3; i <= n; i++) {
    dp[i] = dp[i - 1] + dp[i - 2];
  }
  
  return dp[n];
}

// 最长公共子序列
function longestCommonSubsequence(text1, text2) {
  const m = text1.length;
  const n = text2.length;
  const dp = Array(m + 1).fill().map(() => Array(n + 1).fill(0));
  
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      if (text1[i - 1] === text2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
      }
    }
  }
  
  return dp[m][n];
}

// 背包问题
function knapsack(weights, values, capacity) {
  const n = weights.length;
  const dp = Array(n + 1).fill().map(() => Array(capacity + 1).fill(0));
  
  for (let i = 1; i <= n; i++) {
    for (let w = 1; w <= capacity; w++) {
      if (weights[i - 1] <= w) {
        dp[i][w] = Math.max(
          dp[i - 1][w],
          dp[i - 1][w - weights[i - 1]] + values[i - 1]
        );
      } else {
        dp[i][w] = dp[i - 1][w];
      }
    }
  }
  
  return dp[n][capacity];
}
```

## 🌳 贪心算法

### 基本思想
在每一步选择中都采取在当前状态下最好或最优的选择。

```javascript
// 活动选择问题
function activitySelection(start, end) {
  const n = start.length;
  const activities = [];
  
  for (let i = 0; i < n; i++) {
    activities.push({ start: start[i], end: end[i], index: i });
  }
  
  // 按结束时间排序
  activities.sort((a, b) => a.end - b.end);
  
  const result = [activities[0]];
  let lastEnd = activities[0].end;
  
  for (let i = 1; i < n; i++) {
    if (activities[i].start >= lastEnd) {
      result.push(activities[i]);
      lastEnd = activities[i].end;
    }
  }
  
  return result;
}

// 硬币找零问题
function coinChange(coins, amount) {
  coins.sort((a, b) => b - a); // 降序排列
  let count = 0;
  
  for (let coin of coins) {
    while (amount >= coin) {
      amount -= coin;
      count++;
    }
  }
  
  return amount === 0 ? count : -1;
}

// 分发糖果问题
function candy(ratings) {
  const n = ratings.length;
  const candies = new Array(n).fill(1);
  
  // 从左到右
  for (let i = 1; i < n; i++) {
    if (ratings[i] > ratings[i - 1]) {
      candies[i] = candies[i - 1] + 1;
    }
  }
  
  // 从右到左
  for (let i = n - 2; i >= 0; i--) {
    if (ratings[i] > ratings[i + 1]) {
      candies[i] = Math.max(candies[i], candies[i + 1] + 1);
    }
  }
  
  return candies.reduce((sum, candy) => sum + candy, 0);
}
```

## 🔙 回溯算法

### 基本思想
通过尝试所有可能的候选解来找出所有的解。

```javascript
// N皇后问题
function solveNQueens(n) {
  const result = [];
  const board = Array(n).fill().map(() => Array(n).fill('.'));
  
  function isValid(row, col) {
    // 检查列
    for (let i = 0; i < row; i++) {
      if (board[i][col] === 'Q') return false;
    }
    
    // 检查左上对角线
    for (let i = row - 1, j = col - 1; i >= 0 && j >= 0; i--, j--) {
      if (board[i][j] === 'Q') return false;
    }
    
    // 检查右上对角线
    for (let i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++) {
      if (board[i][j] === 'Q') return false;
    }
    
    return true;
  }
  
  function backtrack(row) {
    if (row === n) {
      result.push(board.map(row => row.join('')));
      return;
    }
    
    for (let col = 0; col < n; col++) {
      if (isValid(row, col)) {
        board[row][col] = 'Q';
        backtrack(row + 1);
        board[row][col] = '.';
      }
    }
  }
  
  backtrack(0);
  return result;
}

// 全排列
function permute(nums) {
  const result = [];
  
  function backtrack(current) {
    if (current.length === nums.length) {
      result.push([...current]);
      return;
    }
    
    for (let num of nums) {
      if (!current.includes(num)) {
        current.push(num);
        backtrack(current);
        current.pop();
      }
    }
  }
  
  backtrack([]);
  return result;
}

// 子集
function subsets(nums) {
  const result = [];
  
  function backtrack(start, current) {
    result.push([...current]);
    
    for (let i = start; i < nums.length; i++) {
      current.push(nums[i]);
      backtrack(i + 1, current);
      current.pop();
    }
  }
  
  backtrack(0, []);
  return result;
}
```

## 🔗 图算法

### 深度优先搜索 (DFS)
```javascript
function dfs(graph, start, visited = new Set()) {
  visited.add(start);
  console.log(start);
  
  for (let neighbor of graph[start]) {
    if (!visited.has(neighbor)) {
      dfs(graph, neighbor, visited);
    }
  }
}

// 检测环
function hasCycle(graph) {
  const visited = new Set();
  const recStack = new Set();
  
  function dfsHelper(node) {
    visited.add(node);
    recStack.add(node);
    
    for (let neighbor of graph[node]) {
      if (!visited.has(neighbor)) {
        if (dfsHelper(neighbor)) return true;
      } else if (recStack.has(neighbor)) {
        return true;
      }
    }
    
    recStack.delete(node);
    return false;
  }
  
  for (let node in graph) {
    if (!visited.has(node)) {
      if (dfsHelper(node)) return true;
    }
  }
  
  return false;
}
```

### 广度优先搜索 (BFS)
```javascript
function bfs(graph, start) {
  const visited = new Set();
  const queue = [start];
  visited.add(start);
  
  while (queue.length > 0) {
    const node = queue.shift();
    console.log(node);
    
    for (let neighbor of graph[node]) {
      if (!visited.has(neighbor)) {
        visited.add(neighbor);
        queue.push(neighbor);
      }
    }
  }
}

// 最短路径
function shortestPath(graph, start, end) {
  const queue = [[start, [start]]];
  const visited = new Set([start]);
  
  while (queue.length > 0) {
    const [node, path] = queue.shift();
    
    if (node === end) {
      return path;
    }
    
    for (let neighbor of graph[node]) {
      if (!visited.has(neighbor)) {
        visited.add(neighbor);
        queue.push([neighbor, [...path, neighbor]]);
      }
    }
  }
  
  return null;
}
```

## 🎯 前端实际应用

### 1. 防抖和节流
```javascript
// 防抖
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// 节流
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
```

### 2. 虚拟滚动
```javascript
class VirtualScroll {
  constructor(container, itemHeight, items) {
    this.container = container;
    this.itemHeight = itemHeight;
    this.items = items;
    this.visibleCount = Math.ceil(container.clientHeight / itemHeight);
    this.startIndex = 0;
    
    this.render();
    this.bindEvents();
  }
  
  render() {
    const endIndex = Math.min(
      this.startIndex + this.visibleCount,
      this.items.length
    );
    
    const visibleItems = this.items.slice(this.startIndex, endIndex);
    
    this.container.innerHTML = visibleItems
      .map((item, index) => `
        <div style="height: ${this.itemHeight}px; position: absolute; top: ${(this.startIndex + index) * this.itemHeight}px;">
          ${item}
        </div>
      `)
      .join('');
  }
  
  bindEvents() {
    this.container.addEventListener('scroll', () => {
      const newStartIndex = Math.floor(this.container.scrollTop / this.itemHeight);
      if (newStartIndex !== this.startIndex) {
        this.startIndex = newStartIndex;
        this.render();
      }
    });
  }
}
```

### 3. LRU缓存
```javascript
class LRUCache {
  constructor(capacity) {
    this.capacity = capacity;
    this.cache = new Map();
  }
  
  get(key) {
    if (this.cache.has(key)) {
      const value = this.cache.get(key);
      this.cache.delete(key);
      this.cache.set(key, value);
      return value;
    }
    return -1;
  }
  
  put(key, value) {
    if (this.cache.has(key)) {
      this.cache.delete(key);
    } else if (this.cache.size >= this.capacity) {
      const firstKey = this.cache.keys().next().value;
      this.cache.delete(firstKey);
    }
    this.cache.set(key, value);
  }
}
```

## 📈 算法优化技巧

### 1. 时间优化
- 使用哈希表减少查找时间
- 预处理数据避免重复计算
- 使用双指针技术
- 分治法降低复杂度

### 2. 空间优化
- 原地算法减少额外空间
- 滚动数组优化动态规划
- 位运算节省空间
- 懒加载减少内存占用

### 3. 常见陷阱
- 整数溢出问题
- 边界条件处理
- 时间复杂度退化
- 递归栈溢出

掌握这些算法思想和技巧，将大大提升你解决复杂问题的能力！🚀 