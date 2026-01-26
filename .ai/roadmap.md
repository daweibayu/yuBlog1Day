# Roadmap

## 分支说明
| 分支 | 用途 | 备注 |
|------|------|------|
| `main` | Flutter 源码 | 代码、配置、CI 脚本 |
| `articles` | 内容 | posts/、pages/、assets/ |
| `gh-pages` | 部署产物 | 由 CI 自动生成，不手动操作 |

---

## M1: 环境与数据准备（无依赖，可并行）

### 1.1 创建 Flutter 项目 `[main]`
- 初始化 Flutter 项目，配置 `pubspec.yaml`（go_router、provider、markdown_widget、http）
- **验证**：`flutter run -d chrome` 能启动空白页面

### 1.2 创建 articles 分支并准备测试数据 `[articles]`
- 创建 `articles` 分支（从空分支创建，不继承 main）
- 创建目录结构：`posts/`、`pages/`、`assets/images/`
- 复制测试文章到 `posts/`
- 创建 `pages/about.md`
- **验证**：分支存在，目录结构正确，至少有 1 篇测试文章

### 1.3 确定 Base URL `[main]` ✅
- ~~确定 GitHub 仓库名和 GitHub Pages URL~~
- ~~更新 `.ai/structure.md` 中的 Base URL~~
- **已完成**：`https://daweibayu.github.io/yuBlog1Day`

---

## M2: 内容构建脚本

### 2.1 实现 posts.json 生成脚本 `[main]`
- 在 `main` 分支创建构建脚本（`.github/scripts/` 或 inline shell）
- 扫描 `posts/*.md`，解析 Front Matter，生成 `posts.json`
- **验证**：checkout `articles` 分支后，本地执行脚本，生成正确的 `posts.json`

### 2.2 GitHub Actions - 内容构建 `[main]`
- 创建 `.github/workflows/build_articles.yml`
- 触发条件：`articles` 分支 push
- 动作：checkout articles → 生成 posts.json → 同步到 `gh-pages/articles/`
- **验证**：推送 `articles` 分支，`gh-pages/articles/posts.json` 自动更新

---

## M3: Flutter 核心功能 `[main]`（依赖 M1.1）

### 3.1 数据层 `[main]`
- 实现 HTTP 客户端、JSON 解析、Markdown 解析
- **验证**：单元测试或手动测试，能解析 `posts.json` 和 Markdown

### 3.2 Repository 层 `[main]`
- 实现 ArticlesRepository（获取文章列表、文章详情）
- **验证**：能从本地或远程获取数据

### 3.3 路由配置 `[main]`
- 配置 `go_router`（hash 模式），定义所有路由
- **验证**：URL 切换能正确导航

### 3.4 首页（文章列表） `[main]`
- 实现首页 UI：导航栏、文章列表（置顶优先、时间倒序）、分页
- **验证**：首页能显示文章列表，点击能跳转

### 3.5 文章详情页 `[main]`
- 实现详情页 UI：文章头部、Markdown 渲染、上一篇/下一篇
- **验证**：详情页能正确渲染 Markdown 和代码高亮

---

## M4: Flutter 完善功能 `[main]`（依赖 M3）

### 4.1 标签页 `[main]`
- 实现标签聚合页、标签筛选页
- **验证**：标签页能显示所有标签，点击标签能筛选文章

### 4.2 About 页 `[main]`
- 实现 About 页，从 `pages/about.md` 加载
- **验证**：About 页能正确显示内容

### 4.3 响应式适配 `[main]`
- 移动端（< 768px）与桌面端适配
- **验证**：不同屏幕宽度下 UI 正常

### 4.4 基础交互完善 `[main]`
- 加载状态、错误处理、空状态
- **验证**：各种状态下 UI 正常显示

### 4.5 404 页面 `[main]`
- 实现 404 页面，处理不存在的路由/文章 id
- **验证**：访问不存在的 URL 显示 404 页面

---

## M5: 部署与验收（依赖 M2、M4）

### 5.1 GitHub Actions - Web 构建 `[main]`
- 创建 `.github/workflows/build_web.yml`
- 触发条件：`main` 分支 push
- 动作：Flutter build web → 部署到 `gh-pages/`（保留 `articles/` 目录）
- **验证**：推送 `main` 分支，GitHub Pages 自动更新

### 5.2 端到端验收
- 访问 GitHub Pages URL，验证所有功能
- **验证**：首页、详情、标签、About 全部正常

---

## 执行顺序

```
[main]     M1.1 ──────────────────> M3.1 → M3.2 → M3.3 → M3.4 → M3.5 → M4.x → M5.1 ─┐
[main]     M1.3 ────────────────────────────────────────────────────────────────────┤
[articles] M1.2 ─┐                                                                  │
[main]           └─> M2.1 → M2.2 ───────────────────────────────────────────────────┴─> M5.2
```

- `[main]` 分支：Flutter 代码、CI 脚本
- `[articles]` 分支：仅内容准备（M1.2）
- `[gh-pages]` 分支：由 CI 自动管理，不手动操作
