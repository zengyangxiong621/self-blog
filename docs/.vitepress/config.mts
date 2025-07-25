import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "From zyx技术博客",
  description: "分享前端开发技术与经验",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: '首页', link: '/' },
      { text: '前端基础', 
        items: [
          { text: 'HTML/CSS', link: '/frontend/html-css/' },
          { text: 'JavaScript', link: '/frontend/javascript/' },
          { text: '浏览器原理', link: '/frontend/browser/' }
        ]
      },
      { text: '框架', 
        items: [
          { text: 'Vue', link: '/framework/vue/' },
          { text: 'React', link: '/framework/react/' },
          { text: '工程化', link: '/framework/engineering/' },
          { text: '性能优化', link: '/framework/performance/' }
        ]
      },
      { text: '工程化', link: '/engineering/' },
      { text: '高级进阶',
        items: [
          { text: '前端安全', link: '/advanced/security/' },
          { text: '设计模式', link: '/advanced/design-pattern/' },
          { text: '算法与数据结构', link: '/advanced/algorithm/' },
          { text: '网络协议', link: '/advanced/network/' }
        ]
      },
      { text: '实战项目', link: '/projects/' },
      { text: '学习笔记', link: '/notes/' }
    ],

    sidebar: {
      '/frontend/html-css/': [
        {
          text: 'HTML/CSS',
          items: [
            { text: 'HTML基础', link: '/frontend/html-css/html-basics' },
            { text: 'CSS基础', link: '/frontend/html-css/css-basics' },
            { text: 'CSS布局', link: '/frontend/html-css/layout' },
            { text: 'CSS动画', link: '/frontend/html-css/animation' },
            { text: '响应式设计', link: '/frontend/html-css/responsive' }
          ]
        }
      ],
      '/frontend/javascript/': [
        {
          text: 'JavaScript',
          items: [
            { text: 'JS基础概念', link: '/frontend/javascript/basics' },
            { text: 'JavaScript 基础大全', link: '/frontend/javascript/fundamentals' },
            { text: '数据类型', link: '/frontend/javascript/data-types/' },
            { text: '内存管理', link: '/frontend/javascript/memory/' },
            { text: '异步编程', link: '/frontend/javascript/async' },
            { text: '面向对象', link: '/frontend/javascript/oop' },
            { text: '函数式编程', link: '/frontend/javascript/functional' },
            { text: 'ES6+特性', link: '/frontend/javascript/es6' },
            { text: '迭代器详解', link: '/frontend/javascript/iterator' }
          ]
        }
      ],
      '/frontend/javascript/data-types/': [
        {
          text: 'JavaScript 数据类型',
          items: [
            { text: '数据类型概览', link: '/frontend/javascript/data-types/' },
            { text: 'Symbol 详解', link: '/frontend/javascript/data-types/symbol/' }
          ]
        }
      ],
      '/frontend/javascript/memory/': [
        {
          text: 'JavaScript 内存管理',
          items: [
            { text: '内存管理概览', link: '/frontend/javascript/memory/' },
            { text: '内存介绍', link: '/frontend/javascript/memory/memory-introduction' }
          ]
        }
      ],
      '/frontend/browser/': [
        {
          text: '浏览器原理',
          items: [
            { text: '渲染过程', link: '/frontend/browser/rendering' },
            { text: '事件机制', link: '/frontend/browser/events' },
            { text: '存储机制', link: '/frontend/browser/storage' },
            { text: '事件循环机制', link: '/frontend/browser/event-loop' }
          ]
        }
      ],
      '/framework/vue/': [
        {
          text: 'Vue开发',
          items: [
            { text: 'Vue基础', link: '/framework/vue/basics' },
            { text: '组件开发', link: '/framework/vue/components' },
            { text: '状态管理', link: '/framework/vue/state' },
            { text: '路由管理', link: '/framework/vue/router' }
          ]
        }
      ],
      '/framework/react/': [
        {
          text: 'React开发',
          items: [
            { text: 'React基础', link: '/framework/react/basics' },
            { text: 'Hooks使用', link: '/framework/react/hooks' },
            { text: '状态管理', link: '/framework/react/state' },
            { text: '性能优化', link: '/framework/react/optimization' }
          ]
        }
      ],
      '/framework/engineering/': [
        {
          text: '工程化实践',
          items: [
            { text: '构建工具', link: '/framework/engineering/build' },
            { text: '包管理', link: '/framework/engineering/package' },
            { text: '代码规范', link: '/framework/engineering/standards' },
            { text: '自动化测试', link: '/framework/engineering/testing' }
          ]
        }
      ],
      '/framework/performance/': [
        {
          text: '性能优化',
          items: [
            { text: '首屏渲染优化', link: '/framework/performance/first-paint-metrics' },
            { text: '资源加载优化', link: '/framework/performance/resource-loading' },
            { text: '运行时性能', link: '/framework/performance/runtime' }
          ]
        }
      ],
      '/advanced/security/': [
        {
          text: '前端安全',
          items: [
            { text: 'XSS防御', link: '/advanced/security/xss' },
            { text: 'CSRF防护', link: '/advanced/security/csrf' },
            { text: '加密算法', link: '/advanced/security/encryption' }
          ]
        }
      ],
      '/advanced/design-pattern/': [
        {
          text: '设计模式',
          items: [
            { text: '创建型模式', link: '/advanced/design-pattern/creational' },
            { text: '结构型模式', link: '/advanced/design-pattern/structural' },
            { text: '行为型模式', link: '/advanced/design-pattern/behavioral' }
          ]
        }
      ],
      '/advanced/algorithm/': [
        {
          text: '算法与数据结构',
          items: [
            { text: '经典算法100题', link: '/advanced/algorithm/classic-100' },
            { text: '数据结构详解', link: '/advanced/algorithm/data-structures' },
            { text: '算法思想总结', link: '/advanced/algorithm/algorithms' }
          ]
        }
      ],
      '/engineering/': [
        {
          text: '前端工程化',
          items: [
            { text: 'Docker容器化', link: '/engineering/docker/' }
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com' }
    ],

    footer: {
      message: '用心记录前端开发点滴',
      copyright: '© 2024 前端技术博客'
    }
  }
})
