# CSS 布局

## 布局概述

CSS 布局是网页设计的重要组成部分，决定了页面元素的排列和定位方式。

### 常见布局方式
- 普通文档流
- 浮动布局
- 定位布局
- Flexbox 弹性布局
- Grid 网格布局

## 普通文档流

### 块级元素和内联元素
```css
/* 块级元素 - 独占一行 */
div, p, h1-h6, ul, ol, li {
    display: block;
}

/* 内联元素 - 在同一行 */
span, a, strong, em, img {
    display: inline;
}

/* 内联块级元素 - 既可以在同一行，又可以设置宽高 */
.inline-block {
    display: inline-block;
    width: 100px;
    height: 50px;
}
```

## 浮动布局

### 基本浮动
```css
.container {
    width: 100%;
}

.left-column {
    float: left;
    width: 30%;
    background-color: #f0f0f0;
}

.right-column {
    float: right;
    width: 65%;
    background-color: #e0e0e0;
}

/* 清除浮动 */
.clearfix::after {
    content: "";
    display: table;
    clear: both;
}
```

### 三栏布局
```css
.header, .footer {
    width: 100%;
    background-color: #333;
    color: white;
    clear: both;
}

.sidebar {
    float: left;
    width: 200px;
    background-color: #f0f0f0;
}

.main-content {
    margin-left: 220px; /* 为侧边栏留出空间 */
    background-color: white;
}

.right-sidebar {
    float: right;
    width: 200px;
    background-color: #e0e0e0;
}
```

## 定位布局

### 相对定位
```css
.relative-box {
    position: relative;
    top: 20px;
    left: 30px;
    /* 相对于原始位置移动 */
}
```

### 绝对定位
```css
.container {
    position: relative; /* 作为定位上下文 */
    width: 500px;
    height: 300px;
}

.absolute-box {
    position: absolute;
    top: 10px;
    right: 10px;
    width: 100px;
    height: 50px;
    /* 相对于最近的定位祖先元素 */
}
```

### 固定定位
```css
/* 导航栏固定在顶部 */
.fixed-nav {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    background-color: #333;
    z-index: 1000;
}

/* 返回顶部按钮 */
.back-to-top {
    position: fixed;
    bottom: 20px;
    right: 20px;
    width: 50px;
    height: 50px;
}
```

### 粘性定位
```css
.sticky-nav {
    position: sticky;
    top: 0;
    background-color: white;
    border-bottom: 1px solid #ddd;
}
```

## Flexbox 弹性布局

### 基本概念
```css
.flex-container {
    display: flex;
    /* 主轴方向 */
    flex-direction: row; /* row | row-reverse | column | column-reverse */
    
    /* 换行 */
    flex-wrap: nowrap; /* nowrap | wrap | wrap-reverse */
    
    /* 简写 */
    flex-flow: row nowrap;
}
```

### 主轴对齐
```css
.flex-container {
    display: flex;
    
    /* 主轴对齐方式 */
    justify-content: flex-start; /* flex-start | flex-end | center | space-between | space-around | space-evenly */
}

/* 示例 */
.center-content {
    display: flex;
    justify-content: center; /* 水平居中 */
}

.space-between {
    display: flex;
    justify-content: space-between; /* 两端对齐，中间均匀分布 */
}
```

### 交叉轴对齐
```css
.flex-container {
    display: flex;
    height: 200px;
    
    /* 交叉轴对齐方式 */
    align-items: flex-start; /* flex-start | flex-end | center | baseline | stretch */
}

/* 垂直居中 */
.vertical-center {
    display: flex;
    align-items: center;
    height: 100vh;
}

/* 完全居中 */
.center-both {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}
```

### 弹性项目属性
```css
.flex-item {
    /* 弹性增长 */
    flex-grow: 1; /* 默认 0 */
    
    /* 弹性收缩 */
    flex-shrink: 1; /* 默认 1 */
    
    /* 基础大小 */
    flex-basis: auto; /* auto | 具体值 */
    
    /* 简写 */
    flex: 1; /* flex-grow flex-shrink flex-basis */
    
    /* 单独对齐 */
    align-self: center; /* auto | flex-start | flex-end | center | baseline | stretch */
}
```

### 常见 Flexbox 布局

#### 等分布局
```css
.equal-columns {
    display: flex;
}

.equal-columns .column {
    flex: 1; /* 等分空间 */
}
```

#### 圣杯布局
```css
.holy-grail {
    display: flex;
    min-height: 100vh;
    flex-direction: column;
}

.header, .footer {
    background-color: #333;
    color: white;
    padding: 20px;
}

.main {
    display: flex;
    flex: 1;
}

.sidebar {
    width: 200px;
    background-color: #f0f0f0;
}

.content {
    flex: 1;
    padding: 20px;
}
```

## Grid 网格布局

### 基本概念
```css
.grid-container {
    display: grid;
    
    /* 定义网格轨道 */
    grid-template-columns: 1fr 2fr 1fr; /* 三列，中间列占两倍空间 */
    grid-template-rows: 100px auto 50px; /* 三行 */
    
    /* 网格间隙 */
    gap: 20px; /* 统一间隙 */
    grid-column-gap: 20px; /* 列间隙 */
    grid-row-gap: 15px; /* 行间隙 */
}
```

### 网格项目定位
```css
.grid-item {
    /* 指定网格位置 */
    grid-column: 1 / 3; /* 从第1列到第3列 */
    grid-row: 2 / 4; /* 从第2行到第4行 */
    
    /* 简写方式 */
    grid-area: 2 / 1 / 4 / 3; /* row-start / column-start / row-end / column-end */
}
```

### 网格模板区域
```css
.grid-layout {
    display: grid;
    grid-template-areas:
        "header header header"
        "sidebar main main"
        "footer footer footer";
    grid-template-columns: 200px 1fr 1fr;
    grid-template-rows: 60px 1fr 40px;
    gap: 10px;
    height: 100vh;
}

.header { grid-area: header; }
.sidebar { grid-area: sidebar; }
.main { grid-area: main; }
.footer { grid-area: footer; }
```

### 响应式网格
```css
.responsive-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

/* 自动填充网格 */
.auto-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 15px;
}
```

## 常见布局模式

### 两栏布局
```css
/* 使用 Flexbox */
.two-column-flex {
    display: flex;
}

.sidebar {
    width: 250px;
    background-color: #f0f0f0;
}

.main {
    flex: 1;
    padding: 20px;
}

/* 使用 Grid */
.two-column-grid {
    display: grid;
    grid-template-columns: 250px 1fr;
    gap: 20px;
}
```

### 三栏布局
```css
/* 使用 Flexbox */
.three-column {
    display: flex;
}

.left-sidebar,
.right-sidebar {
    width: 200px;
    background-color: #f0f0f0;
}

.main-content {
    flex: 1;
    padding: 20px;
}

/* 使用 Grid */
.three-column-grid {
    display: grid;
    grid-template-columns: 200px 1fr 200px;
    gap: 20px;
}
```

### 卡片布局
```css
.card-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
    padding: 20px;
}

.card {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 20px;
}
```

### 媒体对象布局
```css
.media-object {
    display: flex;
    align-items: flex-start;
    gap: 15px;
}

.media-object img {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    flex-shrink: 0;
}

.media-content {
    flex: 1;
}
```

## 响应式布局

### 媒体查询
```css
/* 移动优先 */
.container {
    width: 100%;
    padding: 10px;
}

/* 平板 */
@media (min-width: 768px) {
    .container {
        max-width: 750px;
        margin: 0 auto;
        padding: 20px;
    }
}

/* 桌面 */
@media (min-width: 1024px) {
    .container {
        max-width: 1200px;
        display: grid;
        grid-template-columns: 250px 1fr 250px;
        gap: 30px;
    }
}
```

### 弹性网格
```css
.responsive-layout {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

/* 在小屏幕上变为单列 */
@media (max-width: 768px) {
    .responsive-layout {
        grid-template-columns: 1fr;
    }
}
```

## 布局调试

### 网格线显示
```css
.debug-grid {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    gap: 10px;
}

.debug-grid > * {
    background-color: rgba(255, 0, 0, 0.1);
    border: 1px solid red;
}
```

### 轮廓显示
```css
* {
    outline: 1px solid red;
}
```

## 最佳实践

### 语义化布局
```css
/* 使用语义化的类名 */
.site-header { /* ... */ }
.main-navigation { /* ... */ }
.page-content { /* ... */ }
.sidebar { /* ... */ }
.site-footer { /* ... */ }
```

### 渐进增强
```css
/* 基础布局 */
.layout {
    /* 简单的块级布局 */
}

/* 支持 Flexbox 的浏览器 */
@supports (display: flex) {
    .layout {
        display: flex;
    }
}

/* 支持 Grid 的浏览器 */
@supports (display: grid) {
    .layout {
        display: grid;
        grid-template-columns: 1fr 2fr 1fr;
    }
}
```

## 总结

现代 CSS 布局的要点：

1. **选择合适的布局方法**：根据需求选择 Flexbox 或 Grid
2. **移动优先**：从小屏幕开始设计
3. **语义化**：使用有意义的类名和结构
4. **渐进增强**：确保在老浏览器中也能正常工作
5. **性能考虑**：避免过度复杂的布局结构

掌握这些布局技术可以创建灵活、响应式的网页布局。 