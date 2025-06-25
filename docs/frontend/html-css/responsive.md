# 响应式设计

## 响应式设计概述

响应式设计是一种网页设计方法，使网页能够在不同设备和屏幕尺寸上提供最佳的浏览体验。

### 核心原则
- **流式布局**：使用相对单位而非固定像素
- **弹性图片**：图片能够缩放适应容器
- **媒体查询**：根据设备特性应用不同样式

## 视口 (Viewport)

### 设置视口
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### 视口属性
```html
<!-- 完整的视口设置 -->
<meta name="viewport" content="
    width=device-width,
    initial-scale=1.0,
    maximum-scale=5.0,
    minimum-scale=1.0,
    user-scalable=yes
">
```

## 流式布局

### 弹性容器
```css
/* 使用百分比宽度 */
.container {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

/* 弹性列布局 */
.column {
    float: left;
    padding: 0 15px;
}

.col-1 { width: 8.33%; }
.col-2 { width: 16.66%; }
.col-3 { width: 25%; }
.col-4 { width: 33.33%; }
.col-6 { width: 50%; }
.col-8 { width: 66.66%; }
.col-12 { width: 100%; }
```

### 现代弹性布局
```css
/* 使用 Flexbox */
.flex-container {
    display: flex;
    flex-wrap: wrap;
    margin: 0 -15px;
}

.flex-item {
    flex: 1;
    padding: 0 15px;
    min-width: 0; /* 防止内容溢出 */
}

/* 使用 Grid */
.grid-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}
```

## 媒体查询

### 基本语法
```css
/* 基本媒体查询 */
@media screen and (max-width: 768px) {
    /* 平板和手机样式 */
}

@media screen and (min-width: 769px) {
    /* 桌面样式 */
}
```

### 常用断点
```css
/* 移动设备 */
@media screen and (max-width: 480px) {
    .mobile-only {
        display: block;
    }
}

/* 平板设备 */
@media screen and (min-width: 481px) and (max-width: 768px) {
    .tablet-only {
        display: block;
    }
}

/* 小型桌面 */
@media screen and (min-width: 769px) and (max-width: 1024px) {
    .small-desktop {
        display: block;
    }
}

/* 大型桌面 */
@media screen and (min-width: 1025px) {
    .large-desktop {
        display: block;
    }
}
```

### 媒体特性
```css
/* 屏幕宽度 */
@media (min-width: 768px) { /* ... */ }
@media (max-width: 767px) { /* ... */ }

/* 屏幕高度 */
@media (min-height: 600px) { /* ... */ }

/* 设备像素比 */
@media (-webkit-min-device-pixel-ratio: 2) { /* ... */ }
@media (min-resolution: 2dppx) { /* ... */ }

/* 设备方向 */
@media (orientation: portrait) { /* 竖屏 */ }
@media (orientation: landscape) { /* 横屏 */ }

/* 悬停能力 */
@media (hover: hover) {
    .button:hover {
        background-color: #007bff;
    }
}

@media (hover: none) {
    .button:active {
        background-color: #007bff;
    }
}
```

### 复杂媒体查询
```css
/* 组合条件 */
@media screen and (min-width: 768px) and (max-width: 1024px) {
    /* 平板横屏 */
}

/* 多个条件 */
@media (min-width: 768px), (orientation: landscape) {
    /* 宽屏或横屏 */
}

/* 否定条件 */
@media not screen and (max-width: 480px) {
    /* 不是小屏幕 */
}
```

## 弹性图片和媒体

### 响应式图片
```css
/* 基本响应式图片 */
img {
    max-width: 100%;
    height: auto;
}

/* 高级响应式图片 */
.responsive-img {
    width: 100%;
    height: auto;
    object-fit: cover; /* 保持比例并填充 */
}
```

### HTML 响应式图片
```html
<!-- 使用 srcset -->
<img src="small.jpg" 
     srcset="small.jpg 480w, 
             medium.jpg 768w, 
             large.jpg 1200w"
     sizes="(max-width: 480px) 100vw,
            (max-width: 768px) 50vw,
            33vw"
     alt="响应式图片">

<!-- 使用 picture 元素 -->
<picture>
    <source media="(max-width: 480px)" srcset="mobile.jpg">
    <source media="(max-width: 768px)" srcset="tablet.jpg">
    <img src="desktop.jpg" alt="不同设备的图片">
</picture>
```

### 响应式视频
```css
.video-container {
    position: relative;
    width: 100%;
    height: 0;
    padding-bottom: 56.25%; /* 16:9 比例 */
}

.video-container iframe,
.video-container video {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}
```

## 响应式字体

### 流式字体
```css
/* 使用相对单位 */
body {
    font-size: 16px;
}

h1 {
    font-size: 2em; /* 32px */
}

h2 {
    font-size: 1.5em; /* 24px */
}

/* 使用 rem */
html {
    font-size: 16px;
}

.title {
    font-size: 2rem; /* 32px */
}
```

### 媒体查询字体
```css
/* 基础字体大小 */
html {
    font-size: 14px;
}

/* 平板 */
@media (min-width: 768px) {
    html {
        font-size: 16px;
    }
}

/* 桌面 */
@media (min-width: 1024px) {
    html {
        font-size: 18px;
    }
}
```

### CSS clamp() 函数
```css
/* 响应式字体大小 */
.responsive-text {
    font-size: clamp(1rem, 2.5vw, 2rem);
    /* 最小 1rem，理想 2.5vw，最大 2rem */
}

.hero-title {
    font-size: clamp(2rem, 5vw + 1rem, 4rem);
}
```

## 响应式间距

### 流式间距
```css
/* 使用视口单位 */
.section {
    padding: 5vw 5vw;
    margin-bottom: 3vw;
}

/* 结合 clamp */
.container {
    padding: clamp(1rem, 5vw, 3rem);
}
```

### 媒体查询间距
```css
.section {
    padding: 20px 15px;
}

@media (min-width: 768px) {
    .section {
        padding: 40px 30px;
    }
}

@media (min-width: 1024px) {
    .section {
        padding: 60px 50px;
    }
}
```

## 响应式导航

### 移动优先导航
```css
/* 移动导航 */
.nav-menu {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100vh;
    background: white;
    z-index: 1000;
}

.nav-menu.active {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.nav-toggle {
    display: block;
    background: none;
    border: none;
    font-size: 1.5rem;
}

/* 桌面导航 */
@media (min-width: 768px) {
    .nav-menu {
        display: flex !important;
        position: static;
        height: auto;
        flex-direction: row;
        background: none;
    }
    
    .nav-toggle {
        display: none;
    }
}
```

### 汉堡菜单动画
```css
.hamburger {
    display: flex;
    flex-direction: column;
    width: 30px;
    height: 20px;
    cursor: pointer;
}

.hamburger span {
    width: 100%;
    height: 3px;
    background: #333;
    margin: 2px 0;
    transition: all 0.3s ease;
}

.hamburger.active span:nth-child(1) {
    transform: rotate(45deg) translate(5px, 5px);
}

.hamburger.active span:nth-child(2) {
    opacity: 0;
}

.hamburger.active span:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -6px);
}
```

## 响应式表格

### 横向滚动表格
```css
.table-container {
    overflow-x: auto;
}

.responsive-table {
    min-width: 600px;
    width: 100%;
    border-collapse: collapse;
}
```

### 堆叠表格
```css
@media (max-width: 768px) {
    .responsive-table,
    .responsive-table thead,
    .responsive-table tbody,
    .responsive-table th,
    .responsive-table td,
    .responsive-table tr {
        display: block;
    }
    
    .responsive-table thead tr {
        position: absolute;
        top: -9999px;
        left: -9999px;
    }
    
    .responsive-table tr {
        border: 1px solid #ccc;
        margin-bottom: 10px;
    }
    
    .responsive-table td {
        border: none;
        position: relative;
        padding-left: 50%;
    }
    
    .responsive-table td:before {
        content: attr(data-label) ": ";
        position: absolute;
        left: 6px;
        width: 45%;
        padding-right: 10px;
        white-space: nowrap;
        font-weight: bold;
    }
}
```

## 响应式表单

### 流式表单
```css
.form-group {
    margin-bottom: 1rem;
}

.form-control {
    width: 100%;
    padding: 0.5rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

/* 响应式按钮 */
.btn {
    padding: 0.75rem 1.5rem;
    font-size: 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

@media (max-width: 480px) {
    .btn {
        width: 100%;
        padding: 1rem;
        font-size: 1.1rem;
    }
}
```

## 实用工具类

### 响应式显示/隐藏
```css
/* 移动设备显示 */
.show-mobile {
    display: block;
}

.hide-mobile {
    display: none;
}

/* 桌面设备 */
@media (min-width: 768px) {
    .show-mobile {
        display: none;
    }
    
    .hide-mobile {
        display: block;
    }
    
    .show-desktop {
        display: block;
    }
    
    .hide-desktop {
        display: none;
    }
}
```

### 响应式文本对齐
```css
.text-center { text-align: center; }
.text-left { text-align: left; }
.text-right { text-align: right; }

@media (max-width: 768px) {
    .text-center-mobile { text-align: center; }
    .text-left-mobile { text-align: left; }
}
```

## 性能优化

### 懒加载图片
```css
.lazy-img {
    opacity: 0;
    transition: opacity 0.3s;
}

.lazy-img.loaded {
    opacity: 1;
}
```

### 关键 CSS
```css
/* 首屏关键样式 */
.header,
.hero,
.main-content {
    /* 关键样式写在这里 */
}

/* 其他样式可以异步加载 */
```

### 媒体查询优化
```css
/* 避免重复的媒体查询 */
/* 将相同断点的样式组织在一起 */
@media (max-width: 768px) {
    .nav { /* ... */ }
    .header { /* ... */ }
    .content { /* ... */ }
}
```

## 测试和调试

### 常见断点
```css
/* 常用设备断点 */
/* 超小设备 (手机, 小于 576px) */
@media (max-width: 575.98px) { }

/* 小设备 (手机横屏, 576px 及以上) */
@media (min-width: 576px) { }

/* 中等设备 (平板, 768px 及以上) */
@media (min-width: 768px) { }

/* 大设备 (桌面, 992px 及以上) */
@media (min-width: 992px) { }

/* 超大设备 (大桌面, 1200px 及以上) */
@media (min-width: 1200px) { }
```

### 调试工具
```css
/* 调试边框 */
* {
    outline: 1px solid red;
}

/* 显示断点信息 */
body::before {
    content: "Mobile";
    position: fixed;
    top: 0;
    right: 0;
    background: red;
    color: white;
    padding: 5px;
    z-index: 9999;
}

@media (min-width: 768px) {
    body::before {
        content: "Tablet";
        background: orange;
    }
}

@media (min-width: 1024px) {
    body::before {
        content: "Desktop";
        background: green;
    }
}
```

## 最佳实践

### 移动优先
```css
/* 从移动端开始 */
.container {
    padding: 15px;
}

/* 逐步增强到更大屏幕 */
@media (min-width: 768px) {
    .container {
        padding: 30px;
    }
}

@media (min-width: 1024px) {
    .container {
        padding: 50px;
    }
}
```

### 内容优先
```css
/* 确保内容在所有设备上都可读 */
body {
    font-size: 16px;
    line-height: 1.6;
}

@media (max-width: 480px) {
    body {
        font-size: 14px;
        line-height: 1.5;
    }
}
```

## 总结

响应式设计的关键要点：

1. **移动优先**：从小屏幕开始设计
2. **弹性布局**：使用相对单位和现代CSS布局
3. **合理断点**：基于内容而非设备选择断点
4. **性能考虑**：优化图片和关键渲染路径
5. **渐进增强**：确保基本功能在所有设备上可用
6. **用户体验**：考虑触摸交互和可访问性

掌握响应式设计让网页在所有设备上都能提供优秀的用户体验。 