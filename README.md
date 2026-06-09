# Own Style Writer

Own Style Writer 是一个“按参考文章文风写作”的 Agent Skill。

它适合这样的场景：你有一批本地文章、PDF、Word、PPT、Excel、HTML 或文本文件，希望 Agent 先学习这批文章的结构、节奏、语气和表达习惯，再按你的新需求写一篇风格一致的文章。

它不是固定作者人格，也不是固定模板。每一次写作都以你当次提供的参考目录为最高风格依据。

Inspired by khazix-writer, but contains no khazix-writer persona, corpus, prompts, or runtime dependency.

## 它能做什么

- 扫描用户指定的本地参考目录
- 用内置 MarkItDown 把 PDF、DOCX、PPTX、XLSX、HTML、文本等文件转换成 Markdown
- 生成可复查的转换产物：`converted/*.md`、`manifest.json`、`conversion_errors.json`、`corpus.md`
- 阅读 `corpus.md` 后提炼统一文风画像
- 先给文章大纲和风格拟合说明，默认等待用户确认
- 用户确认后再生成正文和质量检查报告

## 工作流

1. 用户给出参考文章目录和本次写作需求。
2. Agent 运行转换脚本，把目录里的文档转成 Markdown。
3. Agent 阅读 `corpus.md` 和 `manifest.json`。
4. Agent 生成 `style_profile.md`，总结可执行的文风规则。
5. Agent 生成 `outline_review.md`，先给用户确认大纲。
6. 用户确认后，Agent 再生成 `draft.md`。
7. Agent 最后生成 `quality_report.md`，检查风格贴合度和事实风险。

默认不会第一步就直接写完整正文，除非用户明确要求跳过大纲确认。

## 安装

把这个仓库放到你的 Agent Skills 目录即可。

Codex 的常见路径：

```powershell
git clone git@github.com:snowles/own-style-writer.git $env:USERPROFILE\.codex\skills\own-style-writer
```

macOS / Linux：

```bash
git clone git@github.com:snowles/own-style-writer.git ~/.codex/skills/own-style-writer
```

如果你的 Agent 支持从 GitHub 安装 skill，也可以直接让它安装：

```text
安装这个 skill：https://github.com/snowles/own-style-writer
```

## 使用示例

你可以这样对 Agent 说：

```text
使用 own-style-writer。
参考目录：D:\workspace\test\writetest
写作需求：模仿这批文章的文风，帮我写一篇关于某个主题的公众号文章。
先总结文风和给大纲，不要直接写正文。
```

如果只想先转换参考语料，也可以直接运行脚本。

Windows CMD：

```cmd
scripts\run_prepare_corpus.cmd --input-dir "D:\path\to\references" --output-dir "D:\path\to\output" --recursive
```

Windows PowerShell：

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run_prepare_corpus.ps1 -InputDir "D:\path\to\references" -OutputDir "D:\path\to\output" -Recursive
```

macOS / Linux / WSL：

```bash
scripts/run_prepare_corpus.sh "/path/to/references" "/path/to/output" --recursive
```

## 输出文件

转换脚本会保留这些文件，方便检查和复用：

- `converted/*.md`：每个源文件对应的 Markdown
- `manifest.json`：源文件、输出文件、字符数、状态
- `conversion_errors.json`：失败文件和具体错误
- `corpus.md`：合并后的参考语料

Agent 后续会基于这些文件生成：

- `style_profile.md`：文风画像
- `outline_review.md`：待确认大纲
- `draft.md`：正文草稿，默认确认大纲后才生成
- `quality_report.md`：风格和事实完整性检查

## MarkItDown

本 skill 内置 MarkItDown 源码，位于 `vendor/markitdown`，不依赖你本机另一个 MarkItDown 项目路径。

首次运行时，脚本会自动创建可复用 Python runtime，并按文件类型安装所需依赖。只有 PDF 时会优先安装 PDF 相关依赖；如果后续遇到 Word、PowerPoint、Excel 等格式，会按需补装。

转换文档本身不需要 LLM。MarkItDown 负责本地格式解析；LLM/Agent 负责阅读转换后的 Markdown、提炼文风和写作。

## 适合与不适合

适合：

- 模仿自己历史文章的结构和表达习惯
- 模仿一批行业评论、公众号文章、报告摘要的行文节奏
- 把 PDF/Word 等本地资料整理成统一 Markdown 语料
- 先看文风画像和大纲，再决定是否写正文

不适合：

- 纯标题生成
- 小红书、朋友圈、推特等短文案
- 不需要参考文章风格的普通写作
- 需要完全复刻某个固定人格或口癖的写作

## 注意事项

- PDF 转换质量取决于源 PDF 的文字层和排版质量。
- 如果参考语料涉及财经、医疗、法律等高风险领域，正文中的事实、数据和操作性建议需要人工核验。
- 这个 skill 会学习你提供的参考目录，不会内置或默认使用任何固定语料、人格或提示词。
