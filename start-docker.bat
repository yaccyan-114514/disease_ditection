@echo off
chcp 65001 >nul
echo ==========================================
echo   疾病检测系统 Docker 启动脚本
echo ==========================================
echo.

REM 检查 Docker 是否安装
where docker >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 错误: 未找到 Docker，请先安装 Docker Desktop
    echo 访问: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM 检查 Docker Compose 是否安装
where docker-compose >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 错误: 未找到 Docker Compose
    pause
    exit /b 1
)

echo ✓ Docker 环境检查通过
echo.

REM 检查模型文件
if not exist "python_service\streamlit_app\model\best_model_tuned.weights.h5" (
    echo ⚠️  警告: 未找到模型文件 best_model_tuned.weights.h5
    echo    请确保模型文件存在于: python_service\streamlit_app\model\
    echo.
    set /p continue="是否继续启动？（模型文件缺失可能导致 AI 功能无法使用）[y/N]: "
    if /i not "%continue%"=="y" (
        echo 已取消启动
        pause
        exit /b 1
    )
)

REM 检查数据库初始化文件
if not exist "disease_detection.sql" (
    echo ❌ 错误: 未找到数据库初始化文件 disease_detection.sql
    pause
    exit /b 1
)

echo ✓ 文件检查通过
echo.

REM 询问是否构建镜像
set /p rebuild="是否需要重新构建镜像？[y/N]: "
if /i "%rebuild%"=="y" (
    echo 正在构建镜像...
    docker-compose build
    echo.
)

REM 启动服务
echo 正在启动服务...
docker-compose up -d

REM 等待服务启动
echo.
echo 等待服务启动（这可能需要 30-60 秒）...
timeout /t 5 /nobreak >nul

REM 检查服务状态
echo.
echo 服务状态：
docker-compose ps

echo.
echo ==========================================
echo   启动完成！
echo ==========================================
echo.
echo 访问地址：
echo   - Java Web 应用: http://localhost:8080
echo   - Python API 服务: http://localhost:5050/health
echo.
echo 常用命令：
echo   - 查看日志: docker-compose logs -f
echo   - 停止服务: docker-compose stop
echo   - 重启服务: docker-compose restart
echo   - 查看状态: docker-compose ps
echo.
echo 详细文档请查看: DOCKER_README.txt
echo ==========================================
pause
