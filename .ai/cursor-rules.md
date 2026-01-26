# Cursor Rules - Flutter 博客项目

## 铁律
- **MVP 一天内完成**，专注核心功能，不做过度设计
- 代码简洁，不过度封装，优先复用

## 技术栈
- Flutter + Dart
- 路由：`go_router`（hash 模式）
- 状态：`ValueNotifier + Provider`
- Markdown：`markdown_widget`
- 网络：`http`

## 架构
- 分层：Data / Repository / UI + State
- 内容与代码解耦（`articles` 分支独立管理内容）
- 数据统一从 `gh-pages/articles/` 读取

## AI 行为准则
- **先读后改**：修改文件前必须先读取，理解上下文
- **最小变更**：只改必要范围，不做无关重构
- **基于实际**：基于项目实际结构，不假设不存在的文件
- **不确定就问**：需求不明确时主动询问，不要自行假设
- **遵循已有**：遵循项目已有架构、命名、风格
- **可运行优先**：生成的代码必须可直接运行
- **不要过度**：不要过度封装、过度抽象、过度注释

## 项目上下文
- 架构设计：`.ai/structure.md`
- 文章示例：`.ai/demo/2017-04-06-sessionticket.md`
