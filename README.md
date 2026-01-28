# yuBlog1Day

纯 Cursor vibe 的 Flutter 博客（限时一天内），可点击 [daweibayu.top](https://daweibayu.top) 查看 web 版。  

* 因为是纯 MVP，外加时间限制（一天内），所以各种细节经不起考究；
* Flutter Web 目前还有局限性，这里纯粹是为了个人学习；
* 移动端可以正常运行，等稳定后我再 release 吧。


## 前言

虽然之前弄了一个博客 [daweibayu.fun](https://daweibayu.fun)，使用的是 [tale](https://github.com/chesterhow/tale)，本来自己就是工程师，所以一直想自己写一个，后边断断续续也尝试过，但一直没有完整版出来。再后来就 AI 了，也断断续续尝试 vibe 一个，也一直没有跑顺整个流程。前段时间继续尝试 [spec-kit](https://github.com/github/spec-kit)，陷入各种细节处理导致需要时间太长所以也没跑通。

前几天刚从非洲滚回来，就想着仿照 spec-kit，但是不完全套用 spec-kit，然后尝试一下，发现异常的顺利，所以就有了当前这个项目。


## （现阶段）合理的 AI 工程目录结构

* [架构文档](.ai/structure.md)
* [roadmap](.ai/roadmap.md)
* [cursor rules](.ai/cursor-rules.md)（规范文档类）

最核心的肯定还是架构文档，但三部分都是必不可少的。小项目三个文件就行，但如果是商业项目，三个部分需要各自再做细拆。

### 架构文档

含两部分，业务架构文档与技术架构文档。这部分内容不应该包含具体的业务细节，保证架构文档的“架构性”。  
但是在每个大任务的完成后，需要同步更新架构文档，保证**过程反哺架构**。


### roadmap

根据业务迭代内容与现有架构生成的 roadmap。
如果是小项目或练手项目（类似当前工程），一个 markdown 就可以了，不要使用多文件，不然会像 spec-kit 一样，很重。
但如果是商业项目，则需要细化，叠加多人协作，此文件夹则需要按照迭代（或功能）为二级目录，其下才是具体的具体功能 roadmap。

### 规范文档

* cursor rules
* git 分支规范（含访问控制）
* commit 规范
* （自动）生成文档规范
* 工程目录规范（比如 Docs、scripts 等文件夹）

所有规范类的文档都可以存放此文件夹