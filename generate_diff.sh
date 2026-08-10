#!/bin/bash

# 硬编码参数
OLD_BRANCH="old_version"
NEW_BRANCH="main"
MAIN_TEX="memo_hvp3pi.tex"

# 临时文件
OLD_EXPANDED="old.tex"
NEW_EXPANDED="new.tex"
DIFF_OUTPUT="diff.tex"
DIFF_FIXED="diff_fixed.tex"  # 修复后的文件

# 清理旧文件
cleanup() {
    rm -f "$OLD_EXPANDED" "$NEW_EXPANDED" 
}
trap cleanup EXIT

# 保存当前分支
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)

# 提取并展开旧版本
echo "正在提取旧版本 ($OLD_BRANCH)..."
git checkout -f "$OLD_BRANCH" >/dev/null 2>&1
if [ ! -f "$MAIN_TEX" ]; then
    echo "错误: 分支 $OLD_BRANCH 中不存在 $MAIN_TEX"
    exit 1
fi

if ! latexpand --keep-comments --empty-comments "$MAIN_TEX" > "$OLD_EXPANDED"; then
    echo "错误: 无法展开旧版本 $MAIN_TEX"
    exit 1
fi

# 提取并展开新版本
echo "正在提取新版本 ($NEW_BRANCH)..."
git checkout -f "$NEW_BRANCH" >/dev/null 2>&1
if [ ! -f "$MAIN_TEX" ]; then
    echo "错误: 分支 $NEW_BRANCH 中不存在 $MAIN_TEX"
    exit 1
fi

if ! latexpand --keep-comments --empty-comments "$MAIN_TEX" > "$NEW_EXPANDED"; then
    echo "错误: 无法展开新版本 $MAIN_TEX"
    exit 1
fi

# 检查展开后文件差异
echo "检查展开文件差异..."
if diff -q "$OLD_EXPANDED" "$NEW_EXPANDED" >/dev/null; then
    echo "警告: 展开后的文件内容相同！跳过差异生成"
    if [ -n "$CURRENT_BRANCH" ]; then
        git checkout -f "$CURRENT_BRANCH" >/dev/null 2>&1
    fi
    exit 2
fi

# 生成差异文件 (添加表格保护参数)
echo "正在生成差异文件 (使用表格保护参数)..."
latexdiff \
  --type=UNDERLINE \
  --config='PICTUREENV=(?:picture|DIFnomarkup|table)[\w\d*@]*' \
  --append-safecmd='hline' \
  --append-safecmd='cline' \
  --append-safecmd='vline' \
  --append-safecmd='noalign' \
  --exclude-safecmd='tabular' \
  --exclude-safecmd='tabular*' \
  --exclude-safecmd='array' \
  "$OLD_EXPANDED" "$NEW_EXPANDED" > "$DIFF_OUTPUT" || echo "警告: latexdiff 返回非零状态，但继续处理..."

# 应用自动修复
echo "应用自动修复..."
# 1. 修复 \hline 错误
perl -pi -e 's/(\\DIF(add|del)(begin|end)FL\s*\\hline)/$1\n\\noalign{\\vskip2pt}/g' "$DIFF_OUTPUT"
perl -pi -e 's/(\\DIF(add|del)(begin|end)FL)\s*(\\hline\s*\\hline)/$1\n\\noalign{\\vskip2pt}\n$4/g' "$DIFF_OUTPUT"

# 2. 替换 \vline 为更安全的命令
perl -pi -e 's/\\vline/\\texvline/g' "$DIFF_OUTPUT"

# 3. 修复单位错误
perl -pi -e 's/(\\dimexpr\s+)(\d+)(pt)/$1$2\\,$3/g' "$DIFF_OUTPUT"

# 4. 添加安全定义到导言区
perl -i -pe 'if(/\\begin\{document\}/) {
    s/\\begin\{document\}/\\newcommand{\\texvline}{\\mbox{\\textbar}}\n\\makeatletter\n\\renewcommand{\\DIFdel}[1]{{\\protect\\color{red}\\sout{#1}}}\n\\renewcommand{\\DIFadd}[1]{{\\protect\\color{blue}#1}}\n\\renewcommand{\\DIFaddbegin}{}\n\\renewcommand{\\DIFaddend}{}\n\\renewcommand{\\DIFdelbegin}{}\n\\renewcommand{\\DIFdelend}{}\n\\makeatother\n\n\\begin{document}/;
  }' "$DIFF_OUTPUT"

# 5. 修复标签引用问题（新增的核心修复）
perl -pi -e 's/\\DIF(add|del)(begin|end)\s*\\label\{([^}]+)\}/\\label{$3}/g' "$DIFF_OUTPUT"
perl -pi -e 's/\\ref\{(\s*\\DIF(add|del)[^}]+)\}/\\ref{$1}/g' "$DIFF_OUTPUT"
perl -pi -e 's/\\DIF(add|del)\{\\label\{([^}]+)\}\}/\\label{$2}/g' "$DIFF_OUTPUT"

# 创建修复后的文件副本
cp "$DIFF_OUTPUT" "$DIFF_FIXED"
pdflatex -interaction=nonstopmode $DIFF_FIXED
pdflatex -interaction=nonstopmode $DIFF_FIXED
pdflatex -interaction=nonstopmode $DIFF_FIXED

cp memo_hvp3pi.bbl diff_fixed.bbl 
pdflatex -interaction=nonstopmode $DIFF_FIXED
pdflatex -interaction=nonstopmode $DIFF_FIXED
pdflatex -interaction=nonstopmode $DIFF_FIXED


# 生成修复说明
echo "已创建修复版本: $DIFF_FIXED"
echo "请使用以下命令编译:"
echo "   pdflatex -interaction=nonstopmode $DIFF_FIXED"
echo "如果仍有错误，可能需要二次编译或手动修复剩余的 \hline 位置"
echo ""
echo "编译完成后，如果内容正确:"
echo "   mv $DIFF_FIXED ${MAIN_TEX%.tex}_diff.tex"

# # 恢复原始分支
# if [ -n "$CURRENT_BRANCH" ]; then
#     git checkout -f "$CURRENT_BRANCH" >/dev/null 2>&1
# fi

exit 0