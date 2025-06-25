# CSS 基础

## CSS 简介

CSS (Cascading Style Sheets) 是一种用来描述 HTML 或 XML 文档样式的样式表语言。

### CSS 的作用
- 控制页面布局
- 设置字体、颜色、间距
- 添加动画和交互效果
- 实现响应式设计

## CSS 语法

### 基本语法结构
```css
选择器 {
    属性: 值;
    属性: 值;
}
```

### 示例
```css
h1 {
    color: blue;
    font-size: 24px;
    text-align: center;
}
```

## CSS 选择器

### 基础选择器
```css
/* 元素选择器 */
p { color: red; }

/* 类选择器 */
.highlight { background-color: yellow; }

/* ID选择器 */
#header { font-size: 20px; }

/* 通用选择器 */
* { margin: 0; padding: 0; }
```

### 组合选择器
```css
/* 后代选择器 */
div p { color: blue; }

/* 子元素选择器 */
div > p { font-weight: bold; }

/* 相邻兄弟选择器 */
h1 + p { margin-top: 0; }

/* 通用兄弟选择器 */
h1 ~ p { color: gray; }
```

### 属性选择器
```css
/* 存在属性 */
[title] { border: 1px solid red; }

/* 属性值完全匹配 */
[type="text"] { border: 1px solid blue; }

/* 属性值包含 */
[class~="nav"] { font-weight: bold; }

/* 属性值开头匹配 */
[href^="https"] { color: green; }

/* 属性值结尾匹配 */
[src$=".jpg"] { border: 2px solid red; }
```

### 伪类选择器
```css
/* 链接伪类 */
a:link { color: blue; }
a:visited { color: purple; }
a:hover { color: red; }
a:active { color: orange; }

/* 结构伪类 */
p:first-child { font-weight: bold; }
p:last-child { margin-bottom: 0; }
p:nth-child(2n) { background-color: #f0f0f0; }

/* 表单伪类 */
input:focus { border: 2px solid blue; }
input:disabled { background-color: #ccc; }
```

### 伪元素选择器
```css
/* 首字母和首行 */
p::first-letter { font-size: 2em; }
p::first-line { font-weight: bold; }

/* 前后插入内容 */
blockquote::before { content: '"'; }
blockquote::after { content: '"'; }
```

## 盒模型

### 标准盒模型
```css
.box {
    width: 200px;
    height: 100px;
    padding: 20px;
    border: 5px solid black;
    margin: 10px;
}
/* 总宽度 = 200 + 20*2 + 5*2 + 10*2 = 270px */
```

### 边框盒模型
```css
.box {
    box-sizing: border-box;
    width: 200px;
    height: 100px;
    padding: 20px;
    border: 5px solid black;
    margin: 10px;
}
/* 总宽度 = 200px (包含padding和border) */
```

## 文本样式

### 字体属性
```css
.text {
    font-family: "Arial", "Helvetica", sans-serif;
    font-size: 16px;
    font-weight: bold;
    font-style: italic;
    line-height: 1.5;
    
    /* 简写 */
    font: italic bold 16px/1.5 Arial, sans-serif;
}
```

### 文本属性
```css
.text {
    color: #333;
    text-align: center;
    text-decoration: underline;
    text-transform: uppercase;
    letter-spacing: 2px;
    word-spacing: 5px;
    text-indent: 2em;
    white-space: nowrap;
}
```

## 背景样式

### 背景属性
```css
.background {
    background-color: #f0f0f0;
    background-image: url('image.jpg');
    background-repeat: no-repeat;
    background-position: center center;
    background-size: cover;
    background-attachment: fixed;
    
    /* 简写 */
    background: #f0f0f0 url('image.jpg') no-repeat center/cover fixed;
}
```

### 渐变背景
```css
/* 线性渐变 */
.linear-gradient {
    background: linear-gradient(45deg, red, blue);
    background: linear-gradient(to bottom, #ff0000, #0000ff);
}

/* 径向渐变 */
.radial-gradient {
    background: radial-gradient(circle at center, red, blue);
}
```

## 边框样式

### 边框属性
```css
.border {
    border-width: 2px;
    border-style: solid;
    border-color: red;
    
    /* 简写 */
    border: 2px solid red;
    
    /* 单独边框 */
    border-top: 1px solid blue;
    border-right: 2px dashed green;
    border-bottom: 3px dotted orange;
    border-left: 4px double purple;
}
```

### 圆角边框
```css
.rounded {
    border-radius: 10px;
    border-radius: 10px 20px; /* 对角 */
    border-radius: 10px 20px 30px 40px; /* 四个角 */
}
```

## 内外边距

### 边距设置
```css
.spacing {
    /* 内边距 */
    padding: 10px; /* 四边相同 */
    padding: 10px 20px; /* 上下 左右 */
    padding: 10px 20px 30px 40px; /* 上 右 下 左 */
    
    /* 外边距 */
    margin: 10px;
    margin: 10px auto; /* 水平居中 */
    margin: 10px 20px 30px 40px;
}
```

### 边距合并
```css
/* 垂直边距会合并，取较大值 */
.box1 { margin-bottom: 20px; }
.box2 { margin-top: 30px; }
/* 实际间距为 30px，不是 50px */
```

## 显示和定位

### display 属性
```css
.display-examples {
    display: block;    /* 块级元素 */
    display: inline;   /* 内联元素 */
    display: inline-block; /* 内联块级 */
    display: none;     /* 隐藏元素 */
    display: flex;     /* 弹性布局 */
    display: grid;     /* 网格布局 */
}
```

### position 属性
```css
/* 静态定位（默认） */
.static { position: static; }

/* 相对定位 */
.relative {
    position: relative;
    top: 10px;
    left: 20px;
}

/* 绝对定位 */
.absolute {
    position: absolute;
    top: 0;
    right: 0;
}

/* 固定定位 */
.fixed {
    position: fixed;
    bottom: 20px;
    right: 20px;
}

/* 粘性定位 */
.sticky {
    position: sticky;
    top: 0;
}
```

## 浮动

### float 属性
```css
.float-left { float: left; }
.float-right { float: right; }
.no-float { float: none; }

/* 清除浮动 */
.clearfix::after {
    content: "";
    display: table;
    clear: both;
}
```

## 颜色和单位

### 颜色表示法
```css
.colors {
    color: red;                    /* 关键字 */
    color: #ff0000;               /* 十六进制 */
    color: #f00;                  /* 简写 */
    color: rgb(255, 0, 0);        /* RGB */
    color: rgba(255, 0, 0, 0.5);  /* RGBA */
    color: hsl(0, 100%, 50%);     /* HSL */
    color: hsla(0, 100%, 50%, 0.5); /* HSLA */
}
```

### 长度单位
```css
.units {
    /* 绝对单位 */
    width: 100px;    /* 像素 */
    width: 2cm;      /* 厘米 */
    width: 1in;      /* 英寸 */
    
    /* 相对单位 */
    width: 50%;      /* 百分比 */
    width: 2em;      /* 相对于字体大小 */
    width: 1.5rem;   /* 相对于根元素字体大小 */
    width: 50vw;     /* 视口宽度的50% */
    width: 100vh;    /* 视口高度的100% */
}
```

## CSS 继承和层叠

### 继承
```css
/* 可继承的属性 */
body {
    font-family: Arial;  /* 子元素会继承 */
    color: #333;         /* 子元素会继承 */
}

/* 不可继承的属性 */
div {
    border: 1px solid black;  /* 子元素不会继承 */
    margin: 10px;             /* 子元素不会继承 */
}
```

### 特殊性（优先级）
```css
/* 优先级从高到低 */
#id { color: red; }           /* ID选择器: 100 */
.class { color: blue; }       /* 类选择器: 10 */
p { color: green; }           /* 元素选择器: 1 */

/* !important 最高优先级 */
p { color: yellow !important; }
```

## 实用技巧

### 水平居中
```css
/* 文本居中 */
.text-center { text-align: center; }

/* 块级元素居中 */
.center-block {
    width: 200px;
    margin: 0 auto;
}

/* 使用 flexbox */
.flex-center {
    display: flex;
    justify-content: center;
}
```

### 垂直居中
```css
/* 使用 flexbox */
.vertical-center {
    display: flex;
    align-items: center;
    height: 100vh;
}

/* 使用绝对定位 */
.absolute-center {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
```

### 隐藏元素
```css
/* 完全隐藏 */
.hidden { display: none; }

/* 保留空间但不可见 */
.invisible { visibility: hidden; }

/* 透明 */
.transparent { opacity: 0; }
```

## 总结

CSS 基础知识包括：
- 选择器的使用
- 盒模型的理解
- 文本和背景样式
- 定位和布局
- 颜色和单位
- 继承和层叠规则

掌握这些基础知识是学习高级 CSS 特性的前提。 