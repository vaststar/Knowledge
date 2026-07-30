# 个人知识库

> 用 [MkDocs](https://www.mkdocs.org/) + [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) 构建的静态知识库，整理编程语法与项目笔记。

## 内容导航

左侧目录（或下方）分为两大板块：

- **编程 Program** —— 语言 / 工具的常用语法速查：Markdown、CMake、C++、Qt。
- **项目 Project** —— 具体项目的实践笔记：TemplateTool、Webex（含 Webex Request API 接口文档）。

## 本地预览与构建

需先安装依赖（需要 Python 3.8+）：

```bash
pip install -r requirements.txt
```

然后在仓库根目录：

```bash
python -m mkdocs serve   # 本地预览（http://127.0.0.1:8000），改动自动刷新
python -m mkdocs build   # 生成静态站点到 site/ 目录
```

## 说明

- 文档源文件在 `docs/` 目录，均为标准 Markdown，可直接阅读，也可用 MkDocs 渲染成网站。
- 站点配置见 `mkdocs.yml`。
- 构建产物 `site/` 已在 `.gitignore` 中忽略，不纳入版本管理。
