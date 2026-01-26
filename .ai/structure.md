# Flutter 博客项目架构（MVP 一天内可落地）

## 1. 项目概览与约束
* 目标：个人技术博客，对标 https://daweibayu.fun/ 的 IA/视觉
* 平台：Web 为第一公民，兼顾 Android/iOS/macOS（Flutter 多端）
* 内容：Markdown + Front Matter，图片同仓
* 部署：无后端，GitHub Actions 生成产物发布 GitHub Pages
* 铁律：MVP，一天内完成

## 2. 信息架构与路由
* 导航：Posts / Tags / About
* 页面：首页（置顶+列表）、标签页（聚合/筛选）、文章详情（正文+上一篇/下一篇）、About（从 `pages/about.md` 加载）
* 路由：`/`、`/post/:id`（`id` 为文件名不含 `.md`）、`/tags`、`/tag/:name`、`/about`
* Web 路由：使用 hash 模式（`/#/post/xxx`），GitHub Pages 直接支持
* Base URL：`https://daweibayu.github.io/yuBlog1Day`
* Content Base URL：`{baseUrl}/articles/`（客户端拼接此路径访问 posts.json、Markdown、图片）

## 3. 内容规范与数据结构
* Front Matter 规范：
  * 所有字段可选：`title`、`date`（YYYY-MM-DD）、`author`、`tags`、`excerpt_separator`（默认 `<!--more-->`）、`cover`、`pinned`（默认 `false`）、`hide`（默认 `false`）
  * 忽略：`layout`（Jekyll 遗留字段）
* `posts.json` 字段：`generatedAt`、`pageSize`、`posts[]`、`tags[]`
* `posts[]` 字段：`id`、`title`、`date`、`tags`、`author`、`excerpt`、`cover`、`pinned`、`path`
* 构建规则：
  * `id`：从文件名生成（去除 `.md` 后缀）
  * `path`：相对路径（如 `posts/xxx.md`），客户端拼接 baseUrl
  * `title`：可空，为空时显示空字符串
  * `date`：可空，无 date 时排序排在最后
  * `tags`：统一转为数组格式（字符串转 `[string]`）
  * `excerpt`：优先使用 `excerpt_separator` 切分，无则取前 50 字符（去除 Markdown 语法）
  * `cover`：可空，为空时使用默认占位图
  * `hide`：为 `true` 时不写入 `posts.json`（不在列表显示，也无法直链）
* `posts.json` 中 `tags[]`：所有文章标签汇总，去重、排序
* 分页：客户端分页，一次拉取全部 `posts.json`

## 4. 数据来源与流转
* 存储：`articles` 分支
  * `posts/`：文章 Markdown 文件
  * `pages/`：独立页面（`about.md`、`404.html` 等），不纳入 `posts.json`
  * `assets/`：资源文件
    * `assets/images/`：图片资源
* 构建：GitHub Actions 扫描 `posts/` 下所有 `.md` 文件，生成 `posts.json`；`pages/` 目录直接同步
* 消费：统一使用 GitHub Pages URL（多端统一，代码简单）
* 更新：改动 `articles` 分支即触发内容构建
* 流程（MVP）：拉取 `posts.json` → 列表 → 点击拉取 Markdown（无缓存）
* 图片路径：Markdown 中使用相对路径（如 `/assets/images/xxx.webp`），客户端渲染时拼接 baseUrl

## 5. 技术选型
* Flutter 最新稳定版
* 最低版本：Android API 26（8.0）、iOS 15.0（优先使用新框架，如框架要求更高版本则跟随）
* 路由：`go_router`
* 状态：`ValueNotifier + Provider`
* Markdown：`markdown_widget`（内置代码高亮，功能更全面）
* 网络：`http`（MVP 不做缓存）
* 主题：Markdown 浅色主题，代码高亮主题可选

## 6. 工程分层
* 分层：Data（解析/请求） / Repository（ArticlesRepository） / UI + State（Notifier + Provider）
* 关键模块：
  * Data：HTTP 客户端、JSON/Markdown 解析器
  * Repository：ArticlesRepository（统一数据获取入口）
  * State：ArticlesNotifier、PostNotifier（状态管理）
  * UI：Pages（首页/详情/标签/About）、Widgets（列表项/标签/正文/导航等）

## 7. 架构原则
1) 内容与代码解耦（独立 `articles` 分支）
2) 多端统一渲染，Flutter 负责适配
3) 分层清晰但不过度抽象，优先复用
4) MVP 先跑通主流程

## 8. 构建与部署
* 分支策略：
  | 分支 | 用途 | 备注 |
  |------|------|------|
  | `main` | Flutter 源码 | 代码、配置、CI 脚本 |
  | `articles` | 内容 | posts/、pages/、assets/（从空分支创建，不继承 main） |
  | `gh-pages` | 部署产物 | 由 CI 自动生成，不手动操作 |
* `gh-pages` 目录结构：
  * 根目录：Flutter Web 产物（`index.html`、`main.dart.js` 等）
  * `articles/`：文章内容（`posts.json`、`posts/`、`pages/`、`assets/`）
* 构建策略：
  * Web 构建：`main` 变动 → Flutter build web → 部署到 `gh-pages/`（保留 `articles/` 目录）
  * 内容构建：`articles` 变动 → 同步到 `gh-pages/articles/` + 生成 `posts.json`（只允许写 `articles/` 目录）
* 构建脚本：优先 GitHub Actions YAML + inline Shell，复杂逻辑再用 Python
* 产物：多端统一从 `gh-pages/articles/` 读取

