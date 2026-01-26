# Roadmap

## 分支说明
| 分支 | 用途 | 备注 |
|------|------|------|
| `main` | Flutter 源码 | 代码、配置、CI 脚本 |
| `articles` | 内容 | posts/、pages/、assets/ |
| `gh-pages` | 部署产物 | 由 CI 自动生成，不手动操作 |

---

## 进度总览

- [ ] **M1: 环境与数据准备**
- [ ] **M2: 内容构建脚本**
- [ ] **M3: Flutter 核心功能**
- [ ] **M4: Flutter 完善功能**
- [ ] **M5: 部署与验收**

---

## M1: 环境与数据准备

- [x] **1.1 创建 Flutter 项目** `[main]`
  - [x] 初始化 Flutter 项目
  - [x] 配置 `pubspec.yaml`（go_router、provider、markdown_widget、http）
  - [x] 验证：`flutter build web` 构建成功 ✅

- [ ] **1.2 创建 articles 分支并准备测试数据** `[articles]`
  - [ ] 创建 `articles` 分支（从空分支创建，不继承 main）
  - [ ] 创建目录结构：`posts/`、`pages/`、`assets/images/`
  - [ ] 复制测试文章到 `posts/`
  - [ ] 创建 `pages/about.md`
  - [ ] 验证：分支存在，目录结构正确，至少有 1 篇测试文章

- [x] **1.3 确定 Base URL** `[main]`
  - [x] 确定 GitHub 仓库名和 GitHub Pages URL
  - [x] 已完成：`https://daweibayu.github.io/yuBlog1Day`

---

## M2: 内容构建脚本

- [ ] **2.1 实现 posts.json 生成脚本** `[main]`
  - [ ] 创建构建脚本（`.github/scripts/build_posts.py`）
  - [ ] 扫描 `posts/*.md`，解析 Front Matter
  - [ ] 生成 `posts.json`
  - [ ] 验证：本地执行脚本，生成正确的 `posts.json`

- [ ] **2.2 GitHub Actions - 内容构建** `[main]`
  - [ ] 创建 `.github/workflows/build_articles.yml`
  - [ ] 配置触发条件：`articles` 分支 push
  - [ ] 验证：推送 `articles` 分支，`gh-pages/articles/posts.json` 自动更新

---

## M3: Flutter 核心功能 `[main]`

- [ ] **3.1 数据层**
  - [ ] 实现 HTTP 客户端
  - [ ] 实现 JSON 解析（Post 模型）
  - [ ] 实现 Markdown 解析
  - [ ] 验证：能解析 `posts.json` 和 Markdown

- [ ] **3.2 Repository 层**
  - [ ] 实现 ArticlesRepository
  - [ ] 获取文章列表
  - [ ] 获取文章详情
  - [ ] 验证：能从远程获取数据

- [ ] **3.3 路由配置**
  - [ ] 配置 `go_router`（hash 模式）
  - [ ] 定义路由：`/`、`/post/:id`、`/tags`、`/tag/:name`、`/about`
  - [ ] 验证：URL 切换能正确导航

- [ ] **3.4 首页（文章列表）**
  - [ ] 实现导航栏
  - [ ] 实现文章列表（置顶优先、时间倒序）
  - [ ] 实现分页
  - [ ] 验证：首页能显示文章列表，点击能跳转

- [ ] **3.5 文章详情页**
  - [ ] 实现文章头部
  - [ ] 实现 Markdown 渲染
  - [ ] 实现上一篇/下一篇导航
  - [ ] 验证：详情页能正确渲染 Markdown 和代码高亮

---

## M4: Flutter 完善功能 `[main]`

- [ ] **4.1 标签页**
  - [ ] 实现标签聚合页 `/tags`
  - [ ] 实现标签筛选页 `/tag/:name`
  - [ ] 验证：标签页能显示所有标签，点击标签能筛选文章

- [ ] **4.2 About 页**
  - [ ] 实现 About 页
  - [ ] 从 `pages/about.md` 加载内容
  - [ ] 验证：About 页能正确显示内容

- [ ] **4.3 响应式适配**
  - [ ] 移动端适配（< 768px）
  - [ ] 桌面端适配
  - [ ] 验证：不同屏幕宽度下 UI 正常

- [ ] **4.4 基础交互完善**
  - [ ] 加载状态
  - [ ] 错误处理
  - [ ] 空状态
  - [ ] 验证：各种状态下 UI 正常显示

- [ ] **4.5 404 页面**
  - [ ] 实现 404 页面
  - [ ] 处理不存在的路由/文章 id
  - [ ] 验证：访问不存在的 URL 显示 404 页面

---

## M5: 部署与验收

- [ ] **5.1 GitHub Actions - Web 构建** `[main]`
  - [ ] 创建 `.github/workflows/build_web.yml`
  - [ ] 配置触发条件：`main` 分支 push
  - [ ] 动作：Flutter build web → 部署到 `gh-pages/`
  - [ ] 验证：推送 `main` 分支，GitHub Pages 自动更新

- [ ] **5.2 端到端验收**
  - [ ] 访问 GitHub Pages URL
  - [ ] 验证首页正常
  - [ ] 验证详情页正常
  - [ ] 验证标签页正常
  - [ ] 验证 About 页正常

---

## 执行顺序

```
[main]     M1.1 ──────────────────> M3.1 → M3.2 → M3.3 → M3.4 → M3.5 → M4.x → M5.1 ─┐
[main]     M1.3 ✅ ─────────────────────────────────────────────────────────────────┤
[articles] M1.2 ─┐                                                                  │
[main]           └─> M2.1 → M2.2 ───────────────────────────────────────────────────┴─> M5.2
```
