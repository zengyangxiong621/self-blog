# HTML 基础知识

## HTML 简介

HTML（HyperText Markup Language）是网页的基础，它定义了网页的结构和内容。本文将介绍 HTML 的基本概念和常用元素。

## HTML 文档结构

一个基本的 HTML 文档包含以下结构：

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>网页标题</title>
</head>
<body>
    网页内容
</body>
</html>
```

## 常用 HTML 标签

### 标题标签

HTML 提供六级标题，从 `<h1>` 到 `<h6>`：

```html
<h1>一级标题</h1>
<h2>二级标题</h2>
<h3>三级标题</h3>
```

### 段落和文本

```html
<p>这是一个段落</p>
<strong>粗体文本</strong>
<em>斜体文本</em>
```

### 列表

有序列表：
```html
<ol>
    <li>第一项</li>
    <li>第二项</li>
</ol>
```

无序列表：
```html
<ul>
    <li>项目一</li>
    <li>项目二</li>
</ul>
```

### 链接和图片

```html
<a href="https://example.com">这是一个链接</a>
<img src="image.jpg" alt="图片描述">
```

## 语义化标签

HTML5 引入了许多语义化标签，帮助更好地描述内容结构：

```html
<header>页头</header>
<nav>导航</nav>
<main>主要内容</main>
<article>文章</article>
<footer>页脚</footer>
```

## 最佳实践

1. 始终使用语义化标签
2. 保持代码整洁和缩进
3. 使用有意义的类名和 ID
4. 确保图片有 alt 属性
5. 验证 HTML 代码

## 总结

HTML 是网页开发的基础，掌握好这些基本概念和标签的使用，将为你的前端开发之路打下坚实的基础。在实际开发中，建议多加练习，并保持关注最新的 HTML 规范和最佳实践。