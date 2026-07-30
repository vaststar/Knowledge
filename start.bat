@echo off
chcp 65001 >nul
REM ============================================
REM  个人知识库 - Windows 启动脚本
REM  自动检查依赖并启动 MkDocs 本地预览
REM ============================================

cd /d "%~dp0"

REM 检查 Python
where python >nul 2>nul
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装 Python 3.8+ ：https://www.python.org/downloads/
    pause
    exit /b 1
)

REM 检查 mkdocs 是否已安装，未安装则自动安装依赖
python -c "import mkdocs, material" >nul 2>nul
if errorlevel 1 (
    echo [提示] 首次运行，正在安装依赖...
    python -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [错误] 依赖安装失败，请检查网络或手动运行： python -m pip install -r requirements.txt
        pause
        exit /b 1
    )
)

echo.
echo [启动] MkDocs 预览服务器： http://127.0.0.1:8000/
echo [提示] 按 Ctrl+C 停止服务器
echo.

REM 启动并自动打开浏览器
python -m mkdocs serve --open

pause
