#!/usr/bin/env bash
# ============================================
#  个人知识库 - macOS / Linux 启动脚本
#  自动检查依赖并启动 MkDocs 本地预览
# ============================================
set -e

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 选择 Python 命令
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "[错误] 未找到 Python，请先安装 Python 3.8+ ：https://www.python.org/downloads/"
    exit 1
fi

# 检查 mkdocs 是否已安装，未安装则自动安装依赖
if ! "$PY" -c "import mkdocs, material" >/dev/null 2>&1; then
    echo "[提示] 首次运行，正在安装依赖..."
    "$PY" -m pip install -r requirements.txt
fi

echo ""
echo "[启动] MkDocs 预览服务器： http://127.0.0.1:8000/"
echo "[提示] 按 Ctrl+C 停止服务器"
echo ""

# 启动并自动打开浏览器
"$PY" -m mkdocs serve --open
