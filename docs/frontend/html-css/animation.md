# CSS 动画

## 动画基础

CSS 动画为网页添加生动的交互效果，提升用户体验。

### 动画类型
- **过渡动画 (Transitions)**：状态变化时的平滑过渡
- **关键帧动画 (Keyframes)**：复杂的多阶段动画

## CSS 过渡 (Transitions)

### 基本语法
```css
.element {
    transition: property duration timing-function delay;
}
```

### 过渡属性
```css
.button {
    background-color: blue;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    
    /* 单个属性过渡 */
    transition: background-color 0.3s ease;
}

.button:hover {
    background-color: red;
}

/* 多个属性过渡 */
.card {
    transform: scale(1);
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    
    transition: 
        transform 0.3s ease,
        box-shadow 0.3s ease;
}

.card:hover {
    transform: scale(1.05);
    box-shadow: 0 8px 16px rgba(0,0,0,0.2);
}

/* 所有属性过渡 */
.all-transition {
    transition: all 0.3s ease;
}
```

### 过渡时间函数
```css
.timing-functions {
    /* 预定义函数 */
    transition-timing-function: ease;        /* 默认 */
    transition-timing-function: linear;      /* 匀速 */
    transition-timing-function: ease-in;     /* 加速 */
    transition-timing-function: ease-out;    /* 减速 */
    transition-timing-function: ease-in-out; /* 先加速后减速 */
    
    /* 贝塞尔曲线 */
    transition-timing-function: cubic-bezier(0.25, 0.1, 0.25, 1);
    
    /* 阶跃函数 */
    transition-timing-function: steps(4, end);
}
```

### 实用过渡效果
```css
/* 淡入淡出 */
.fade {
    opacity: 1;
    transition: opacity 0.3s ease;
}

.fade.hidden {
    opacity: 0;
}

/* 滑动效果 */
.slide {
    transform: translateX(0);
    transition: transform 0.3s ease;
}

.slide.moved {
    transform: translateX(100px);
}

/* 旋转效果 */
.rotate {
    transform: rotate(0deg);
    transition: transform 0.5s ease;
}

.rotate:hover {
    transform: rotate(360deg);
}

/* 颜色变化 */
.color-change {
    color: #333;
    background-color: #f0f0f0;
    transition: color 0.3s ease, background-color 0.3s ease;
}

.color-change:hover {
    color: white;
    background-color: #007bff;
}
```

## CSS 关键帧动画 (Keyframes)

### 定义关键帧
```css
/* 从...到... */
@keyframes slideIn {
    from {
        transform: translateX(-100%);
    }
    to {
        transform: translateX(0);
    }
}

/* 百分比定义 */
@keyframes bounce {
    0% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-20px);
    }
    100% {
        transform: translateY(0);
    }
}

/* 复杂动画 */
@keyframes colorWave {
    0% {
        background-color: red;
        transform: scale(1);
    }
    25% {
        background-color: yellow;
        transform: scale(1.1);
    }
    50% {
        background-color: green;
        transform: scale(1.2);
    }
    75% {
        background-color: blue;
        transform: scale(1.1);
    }
    100% {
        background-color: red;
        transform: scale(1);
    }
}
```

### 应用动画
```css
.animated-element {
    animation: slideIn 1s ease-in-out;
}

/* 完整语法 */
.full-animation {
    animation-name: bounce;
    animation-duration: 2s;
    animation-timing-function: ease-in-out;
    animation-delay: 0.5s;
    animation-iteration-count: infinite;
    animation-direction: alternate;
    animation-fill-mode: both;
    animation-play-state: running;
    
    /* 简写 */
    animation: bounce 2s ease-in-out 0.5s infinite alternate both running;
}
```

### 动画属性详解
```css
.animation-properties {
    /* 动画持续时间 */
    animation-duration: 2s;
    
    /* 动画延迟 */
    animation-delay: 1s;
    
    /* 重复次数 */
    animation-iteration-count: 3;      /* 重复3次 */
    animation-iteration-count: infinite; /* 无限重复 */
    
    /* 动画方向 */
    animation-direction: normal;        /* 正常方向 */
    animation-direction: reverse;       /* 反向 */
    animation-direction: alternate;     /* 交替 */
    animation-direction: alternate-reverse; /* 反向交替 */
    
    /* 填充模式 */
    animation-fill-mode: none;         /* 默认 */
    animation-fill-mode: forwards;     /* 保持最后一帧 */
    animation-fill-mode: backwards;    /* 应用第一帧 */
    animation-fill-mode: both;         /* 两者都应用 */
    
    /* 播放状态 */
    animation-play-state: running;     /* 播放 */
    animation-play-state: paused;      /* 暂停 */
}
```

## 常见动画效果

### 加载动画
```css
/* 旋转加载器 */
@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

/* 脉冲效果 */
@keyframes pulse {
    0% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.1);
        opacity: 0.7;
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
}

.pulse {
    animation: pulse 2s ease-in-out infinite;
}

/* 呼吸灯效果 */
@keyframes breathe {
    0%, 100% { opacity: 0.3; }
    50% { opacity: 1; }
}

.breathing {
    animation: breathe 3s ease-in-out infinite;
}
```

### 入场动画
```css
/* 淡入 */
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

.fade-in {
    animation: fadeIn 1s ease-in;
}

/* 从左滑入 */
@keyframes slideInLeft {
    from {
        transform: translateX(-100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

.slide-in-left {
    animation: slideInLeft 0.8s ease-out;
}

/* 放大进入 */
@keyframes zoomIn {
    from {
        transform: scale(0);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

.zoom-in {
    animation: zoomIn 0.5s ease-out;
}

/* 弹跳进入 */
@keyframes bounceIn {
    0% {
        transform: scale(0.3);
        opacity: 0;
    }
    50% {
        transform: scale(1.05);
        opacity: 1;
    }
    70% {
        transform: scale(0.9);
    }
    100% {
        transform: scale(1);
    }
}

.bounce-in {
    animation: bounceIn 0.8s ease-out;
}
```

### 悬停效果
```css
/* 摇摆效果 */
@keyframes wobble {
    0% { transform: rotate(0deg); }
    25% { transform: rotate(-5deg); }
    75% { transform: rotate(5deg); }
    100% { transform: rotate(0deg); }
}

.wobble:hover {
    animation: wobble 0.6s ease-in-out;
}

/* 心跳效果 */
@keyframes heartbeat {
    0%, 100% {
        transform: scale(1);
    }
    14% {
        transform: scale(1.3);
    }
    28% {
        transform: scale(1);
    }
    42% {
        transform: scale(1.3);
    }
    70% {
        transform: scale(1);
    }
}

.heartbeat:hover {
    animation: heartbeat 1.5s ease-in-out;
}
```

## Transform 变换

### 2D 变换
```css
.transform-2d {
    /* 位移 */
    transform: translateX(50px);
    transform: translateY(30px);
    transform: translate(50px, 30px);
    
    /* 缩放 */
    transform: scaleX(1.5);
    transform: scaleY(0.8);
    transform: scale(1.2);
    transform: scale(1.5, 0.8);
    
    /* 旋转 */
    transform: rotate(45deg);
    
    /* 倾斜 */
    transform: skewX(20deg);
    transform: skewY(10deg);
    transform: skew(20deg, 10deg);
    
    /* 组合变换 */
    transform: translate(50px, 30px) rotate(45deg) scale(1.2);
}
```

### 3D 变换
```css
.transform-3d {
    /* 3D 位移 */
    transform: translateZ(50px);
    transform: translate3d(50px, 30px, 20px);
    
    /* 3D 旋转 */
    transform: rotateX(45deg);
    transform: rotateY(60deg);
    transform: rotateZ(30deg);
    transform: rotate3d(1, 1, 0, 45deg);
    
    /* 3D 缩放 */
    transform: scaleZ(2);
    transform: scale3d(1.5, 1.2, 2);
    
    /* 透视 */
    perspective: 1000px;
    transform-style: preserve-3d;
}

/* 3D 翻转卡片 */
.flip-card {
    width: 300px;
    height: 200px;
    perspective: 1000px;
}

.flip-card-inner {
    position: relative;
    width: 100%;
    height: 100%;
    text-align: center;
    transition: transform 0.8s;
    transform-style: preserve-3d;
}

.flip-card:hover .flip-card-inner {
    transform: rotateY(180deg);
}

.flip-card-front, .flip-card-back {
    position: absolute;
    width: 100%;
    height: 100%;
    backface-visibility: hidden;
}

.flip-card-back {
    transform: rotateY(180deg);
}
```

## 性能优化

### 硬件加速
```css
/* 触发硬件加速 */
.hardware-accelerated {
    transform: translateZ(0); /* 或 translate3d(0,0,0) */
    will-change: transform;
}

/* 使用 transform 和 opacity */
.optimized-animation {
    /* 好的做法 - 使用 transform */
    transform: translateX(100px);
    transition: transform 0.3s ease;
    
    /* 避免 - 使用 left/top */
    /* left: 100px;
    transition: left 0.3s ease; */
}
```

### will-change 属性
```css
.will-change-example {
    /* 提前告知浏览器将要变化的属性 */
    will-change: transform, opacity;
}

/* 动画结束后移除 */
.animation-finished {
    will-change: auto;
}
```

## 动画库集成

### 使用 CSS 变量
```css
:root {
    --animation-duration: 1s;
    --animation-easing: ease-in-out;
}

.configurable-animation {
    animation: slideIn var(--animation-duration) var(--animation-easing);
}
```

### 响应式动画
```css
/* 尊重用户的动效偏好 */
@media (prefers-reduced-motion: reduce) {
    * {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
    }
}

/* 根据屏幕尺寸调整动画 */
@media (max-width: 768px) {
    .mobile-optimized {
        animation-duration: 0.5s; /* 移动端使用更短的动画 */
    }
}
```

## 实际应用示例

### 按钮动画
```css
.animated-button {
    background: linear-gradient(45deg, #007bff, #0056b3);
    border: none;
    color: white;
    padding: 12px 24px;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: all 0.3s ease;
}

.animated-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,123,255,0.4);
}

.animated-button:active {
    transform: translateY(0);
}

/* 点击波纹效果 */
.animated-button::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 0;
    height: 0;
    border-radius: 50%;
    background: rgba(255,255,255,0.5);
    transform: translate(-50%, -50%);
    transition: width 0.6s, height 0.6s;
}

.animated-button:active::after {
    width: 300px;
    height: 300px;
}
```

### 导航菜单动画
```css
.nav-menu {
    list-style: none;
    padding: 0;
}

.nav-item {
    position: relative;
    overflow: hidden;
}

.nav-link {
    display: block;
    padding: 15px 20px;
    color: #333;
    text-decoration: none;
    transition: color 0.3s ease;
    position: relative;
    z-index: 1;
}

.nav-link::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transition: left 0.5s ease;
    z-index: -1;
}

.nav-link:hover::before {
    left: 100%;
}

.nav-link:hover {
    color: #007bff;
}
```

## 总结

CSS 动画的关键要点：

1. **选择合适的动画类型**：过渡适合简单状态变化，关键帧适合复杂动画
2. **性能优化**：使用 transform 和 opacity，启用硬件加速
3. **用户体验**：尊重用户的动效偏好设置
4. **适度使用**：避免过度动画影响用户体验
5. **响应式考虑**：根据设备性能调整动画复杂度

合理使用 CSS 动画可以大大提升网页的交互体验和视觉吸引力。 