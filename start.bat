@echo off
chcp 65001 >nul
REM ============================================
REM  个人知识库 - Windows 启动脚本
REM  在项目内的 .venv 虚拟环境中运行，不污染系统 Python
REM ============================================

cd /d "%~dp0"

REM 检查系统 Python（仅用于创建虚拟环境）
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装 Python 3.8+ ：https://www.python.org/downloads/
    pause
    exit /b 1
)

REM 首次运行：创建虚拟环境
if not exist ".venv\Scripts\python.exe" (
    echo [提示] 首次运行，正在创建虚拟环境 .venv ...
    python -m venv .venv
    if errorlevel 1 (
        echo [错误] 创建虚拟环境失败。
        pause
        exit /b 1
    )
)

set "VENV_PY=.venv\Scripts\python.exe"

REM 检查虚拟环境内是否已装依赖，未装则安装
"%VENV_PY%" -c "import mkdocs, material" >nul 2>nul
if errorlevel 1 (
    echo [提示] 正在向虚拟环境安装依赖...
    "%VENV_PY%" -m pip install --upgrade pip >nul
    "%VENV_PY%" -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败，请检查网络。
        pause
        exit /b 1
    )
)

echo.
echo [启动] MkDocs 预览服务器： http://127.0.0.1:8000/
echo [提示] 按 Ctrl+C 停止服务器
echo.

REM 用虚拟环境的 Python 启动，并自动打开浏览器
"%VENV_PY%" -m mkdocs serve --open

pause
