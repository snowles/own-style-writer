---
name: own-style-writer
description: |
  通用参考文风写作 skill。用于用户要求“按这个目录里的文章风格写”“学习某批文档的行文风格”“用参考文章生成大纲/正文”“从本地 PDF/DOCX/PPTX/Excel/HTML/文本等素材提炼文风并写文章”时。它会先用内置 MarkItDown 将用户指定的本地目录转换为 Markdown，汇总语料，提炼结构、节奏、语气和表达禁忌，再根据用户需求先输出风格说明与文章大纲，待确认后生成正文。不要用于纯标题生成、短社媒文案，或不需要参考文风拟合的普通写作。
---

# Own Style Writer

这是一个“参考文风写作”skill，不内置任何固定作者人格或默认口癖。每次写作都必须以用户指定目录中的文章为最高风格依据。

Inspired by khazix-writer, but contains no khazix-writer persona, corpus, prompts, or runtime dependency.

## Core Rule

先学习，再写作。

如果用户给了参考文章目录，必须先转换并阅读语料，提炼风格画像，然后先给出大纲和拟合说明。不要在第一次响应里直接输出完整正文，除非用户明确说“跳过大纲确认，直接写”。

## Quick Start

1. 确认用户提供了两个东西：
   - 参考文章目录，例如 `D:\workspace\test\writetest`
   - 本次写作需求，例如主题、观点、素材、目标读者、篇幅、输出语言
2. 运行转换脚本：
   - Windows/CMD: `scripts\run_prepare_corpus.cmd --input-dir "<参考目录>" --output-dir "<输出目录>" --recursive`
   - Windows/PowerShell: `powershell -ExecutionPolicy Bypass -File scripts/run_prepare_corpus.ps1 -InputDir "<参考目录>" -OutputDir "<输出目录>" -Recursive`
   - macOS/Linux/WSL: `scripts/run_prepare_corpus.sh "<参考目录>" "<输出目录>" --recursive`
3. 阅读输出目录中的 `corpus.md` 和 `manifest.json`。
4. 参考 `references/style_profile_template.md`，生成 `style_profile.md`。
5. 参考 `references/outline_review_template.md`，生成 `outline_review.md` 并展示给用户确认。
6. 用户确认后，再生成 `draft.md`。
7. 参考 `references/quality_check_template.md`，生成 `quality_report.md`。

## Conversion Contract

本 skill 自带 MarkItDown 源码，位于 `vendor/markitdown`。首次运行转换脚本时，`scripts/bootstrap_markitdown.py` 会自动创建可复用 Python runtime。`prepare_style_corpus.py` 默认按输入目录里的文件类型自动安装所需转换依赖，例如只有 PDF 时只安装 PDF 依赖；后续遇到 Word、PowerPoint、Excel 或 MSG 时再补装对应依赖。

默认支持的本地文件类型包括：

- PDF
- Word: `.docx`
- PowerPoint: `.pptx`
- Excel: `.xlsx`, `.xls`
- HTML: `.html`, `.htm`
- Text data: `.md`, `.txt`, `.csv`, `.json`, `.xml`
- EPUB, Outlook MSG, ZIP

转换脚本必须保留中间产物：

- `converted/*.md`
- `manifest.json`
- `conversion_errors.json`
- `corpus.md`

如果某个文件转换失败，记录错误并继续处理其它文件。不要因为单个文件失败而放弃整个目录。

## Style Extraction

提炼风格画像时，不要只总结主题内容。重点观察这些维度：

- 开头如何启动：叙事、判断、问题、场景、金句、新闻事实，还是直接抛结论
- 文章结构：线性推进、分节论证、清单式、故事弧、评论式、研究式、问答式
- 段落密度：长段还是短段，单句成段是否高频
- 句式节奏：长短句比例，停顿方式，转折方式，是否爱用反问
- 论证方式：案例、数据、经验、类比、引用、复盘、情绪判断
- 视角和姿态：旁观者、亲历者、导师、朋友、研究员、评论员、交易员、编辑部口吻
- 用词习惯：高频词、口头禅、行业术语、情绪词、连接词
- 格式习惯：标题层级、编号、加粗、引用、表格、括号、标点
- 禁忌：参考文章明显不用或很少用的表达方式
- 结尾方式：回扣开头、给判断、留悬念、行动建议、风险提示、情绪收束

风格画像要写成可执行约束，而不是泛泛评价。例如不要写“语言生动”，要写“每个核心判断后面通常跟一个短句解释，并用口语转折把节奏拉回来”。

## Outline First

默认先输出大纲，不直接写正文。大纲必须包含：

- 本次文章的核心主题和目标读者
- 将采用的参考风格特征
- 开头写法
- 主体结构
- 每一节/每一段承担的功能
- 结尾方式
- 需要用户补充或确认的事实

如果参考文章与用户需求冲突，优先保持参考文章的结构、语气和节奏，但事实、观点和结论必须服务用户本次需求。冲突处写进大纲说明，让用户确认。

## Drafting Rules

写正文时严格依据 `style_profile.md` 和已确认的 `outline_review.md`。

- 不套用任何固定作者人格。
- 不继承旧 skill 的固定口癖、固定尾巴或固定价值观。
- 不编造第一手经历、数据、引用或具体事实。
- 用户没有提供的信息，用“需要补充”或保守表达处理。
- 如果参考语料是财经、医疗、法律等高风险领域，避免给出确定性操作指令；需要事实核验时提醒用户核验。
- 如果用户要求直接发布稿，仍要附上简短 `quality_report.md`，说明哪些风格特征已对齐、哪些事实仍需人工确认。

## Runtime Notes

首次 bootstrap 需要网络或本机 pip 缓存。之后 runtime 会复用，不需要每次重新安装。

如果要预装完整文档依赖，可给转换脚本传 `--extras full` 或 `--extras pdf,docx,pptx,xlsx,xls,outlook`。默认 `--extras auto` 更适合日常使用，首跑更轻。单独运行 `bootstrap_markitdown.py` 时默认只预装 PDF 依赖。

默认 runtime 位置：

- Windows: `%LOCALAPPDATA%\own-style-writer\runtime`
- Linux/WSL/macOS: `~/.cache/own-style-writer/runtime`

如果当前环境不能写用户缓存目录，设置 `OWN_STYLE_WRITER_RUNTIME` 到一个可写目录。

在 WSL 中，默认 runtime 位于 Linux 用户缓存目录，通常比放在 `/mnt/c` 或 `/mnt/d` 这类 Windows 挂载盘更快。验收测试可以把 runtime 放到工作区，便于查看产物；日常使用优先用默认位置。

同一个 runtime 目录可以被 Windows Python 和 WSL/Linux Python 复用；bootstrap 会按 Python 版本、操作系统和 CPU 架构隔离依赖目录，避免不同平台的二进制包互相污染。

## Real PDF Acceptance Test

本仓库验收时使用：

`D:\workspace\test\writetest`

该目录包含多个中文文件名 PDF。测试时输出到：

`D:\workspace\test\writetest\.own-style-writer-test`

验收标准：

- 首次运行能自动 bootstrap MarkItDown。
- PDF 文件能转换为对应 Markdown。
- `manifest.json` 记录源文件、输出文件、字符数、状态。
- `corpus.md` 可用于提炼统一风格画像。
- 流程停在大纲确认阶段，不直接生成正文。
