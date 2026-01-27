# Roadmap

## 分支说明
| 分支 | 用途 | 备注 |
|------|------|------|
| `main` | Flutter 源码 | 代码、配置、CI 脚本 |
| `articles` | 内容 | posts/、pages/、assets/ |
| `gh-pages` | 部署产物 | 由 CI 自动生成，不手动操作 |

---

## 进度总览

- [x] **M1: 环境与数据准备**
- [x] **M2: 内容构建脚本**
- [x] **M3: Flutter 核心功能**
- [x] **M4: Flutter 完善功能**
- [x] **M5: 部署与验收**

---

## M1: 环境与数据准备

- [x] **1.1 创建 Flutter 项目** `[main]`
  - [x] 初始化 Flutter 项目
  - [x] 配置 `pubspec.yaml`（go_router、provider、markdown_widget、http）
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **1.2 创建 articles 分支并准备测试数据** `[articles]`
  - [x] 创建 `articles` 分支（从空分支创建，不继承 main）
  - [x] 创建目录结构：`posts/`、`pages/`、`assets/images/`
  - [x] 复制测试文章到 `posts/`
  - [x] 创建 `pages/about.md`
  - [x] 验证：分支存在，目录结构正确，至少有 1 篇测试文章 ✅

- [x] **1.3 确定 Base URL** `[main]`
  - [x] 确定 GitHub 仓库名和 GitHub Pages URL
  - [x] 已完成：`https://daweibayu.github.io/yuBlog1Day`

---

## M2: 内容构建脚本

- [x] **2.1 实现 posts.json 生成脚本** `[main]`
  - [x] 创建构建脚本（`.github/scripts/build_posts.py`）
  - [x] 扫描 `posts/*.md`，解析 Front Matter
  - [x] 生成 `posts.json`
  - [x] 验证：本地执行脚本，生成正确的 `posts.json` ✅

- [x] **2.2 GitHub Actions - 内容构建** `[main]`
  - [x] 创建 `.github/workflows/build_articles.yml`
  - [x] 配置触发条件：`articles` 分支 push
  - [x] 验证：推送 `articles` 分支，`gh-pages/articles/posts.json` 自动更新（需推送到 GitHub 后验证）✅

---

## M3: Flutter 核心功能 `[main]`

- [x] **3.1 数据层**
  - [x] 实现 HTTP 客户端
  - [x] 实现 JSON 解析（Post 模型）
  - [x] 实现 Markdown 解析
  - [x] 验证：`flutter analyze` 通过 ✅

- [x] **3.2 Repository 层**
  - [x] 实现 ArticlesRepository
  - [x] 获取文章列表
  - [x] 获取文章详情
  - [x] 验证：`flutter analyze` 通过 ✅

- [x] **3.3 路由配置**
  - [x] 配置 `go_router`（hash 模式）
  - [x] 定义路由：`/`、`/post/:id`、`/tags`、`/tag/:name`、`/about`
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **3.4 首页（文章列表）**
  - [x] 实现导航栏
  - [x] 实现文章列表（置顶优先、时间倒序）
  - [x] 实现分页（客户端分页）
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **3.5 文章详情页**
  - [x] 实现文章头部
  - [x] 实现 Markdown 渲染
  - [x] 实现上一篇/下一篇导航
  - [x] 验证：`flutter build web` 构建成功 ✅

---

## M4: Flutter 完善功能 `[main]`

- [x] **4.1 标签页**
  - [x] 实现标签聚合页 `/tags`
  - [x] 实现标签筛选页 `/tag/:name`
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **4.2 About 页**
  - [x] 实现 About 页
  - [x] 从 `pages/about.md` 加载内容
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **4.3 响应式适配**
  - [x] 使用 ConstrainedBox 限制最大宽度
  - [x] 移动端/桌面端自适应布局
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **4.4 基础交互完善**
  - [x] 加载状态（CircularProgressIndicator）
  - [x] 错误处理（错误提示 + 重试）
  - [x] 空状态（暂无文章/标签提示）
  - [x] 验证：`flutter build web` 构建成功 ✅

- [x] **4.5 404 页面**
  - [x] 实现 404 页面
  - [x] 处理不存在的路由/文章 id
  - [x] 验证：`flutter build web` 构建成功 ✅

---

## M5: 部署与验收

- [x] **5.1 GitHub Actions - Web 构建** `[main]`
  - [x] 创建 `.github/workflows/build_web.yml`
  - [x] 配置触发条件：`main` 分支 push
  - [x] 动作：Flutter build web → 部署到 `gh-pages/`
  - [x] 验证：推送 `main` 分支，GitHub Pages 自动更新（需推送到 GitHub 后验证）✅

- [x] **5.2 端到端验收**
  - [x] 访问 GitHub Pages URL ✅
  - [x] 验证首页正常 ✅
  - [x] 验证详情页正常 ✅
  - [x] 验证标签页正常 ✅
  - [x] 验证 About 页正常 ✅

---

## 执行顺序

```
[main]     M1.1 ✅ ────────────────> M3.1 ✅ → M3.2 ✅ → M3.3 ✅ → M3.4 ✅ → M3.5 ✅ → M4.x ✅ → M5.1 ✅ ─┐
[main]     M1.3 ✅ ──────────────────────────────────────────────────────────────────────────────────────┤
[articles] M1.2 ✅ ─┐                                                                                    │
[main]              └─> M2.1 ✅ → M2.2 ✅ ───────────────────────────────────────────────────────────────┴─> M5.2 ✅
```
