#!/usr/bin/env bash
# ============================================
#  个人知识库 - macOS / Linux 启动脚本
#  在项目内的 .venv 虚拟环境中运行，不污染系统 Python
# ============================================
set -e

# 切换到脚本所在目录
cd "$(dirname "$0")"

# 选择系统 Python（仅用于创建虚拟环境）
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "[错误] 未找到 Python，请先安装 Python 3.8+ ：https://www.python.org/downloads/"
    exit 1
fi

# 首次运行：创建虚拟环境
if [ ! -x ".venv/bin/python" ]; then
    echo "[提示] 首次运行，正在创建虚拟环境 .venv ..."
    "$PY" -m venv .venv
fi

VENV_PY=".venv/bin/python"

# 检查虚拟环境内是否已装依赖，未装则安装
if ! "$VENV_PY" -c "import mkdocs, material" >/dev/null 2>&1; then
    echo "[提示] 正在向虚拟环境安装依赖..."
    "$VENV_PY" -m pip install --upgrade pip >/dev/null
    "$VENV_PY" -m pip install -r requirements.txt
fi

echo ""
echo "[启动] MkDocs 预览服务器： http://127.0.0.1:8000/"
echo "[提示] 按 Ctrl+C 停止服务器"
echo ""

# 用虚拟环境的 Python 启动，并自动打开浏览器
"$VENV_PY" -m mkdocs serve --open
