@echo off
setlocal

:: Name of the Docker image
set IMAGE_NAME=edaanowl-validator

:: 1. Requirement: Check if Docker is running
echo --- Checking Docker status ---
docker ps > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker does not appear to be running.
    echo Please start Docker Desktop and try again.
    goto :eof
)
echo Docker detected.

:: 2. Build the Docker image
echo.
echo --- Building local validation image (%IMAGE_NAME%) ---
docker build -t %IMAGE_NAME% -f Dockerfile .
if %errorlevel% neq 0 (
    echo [ERROR] Docker image build failed.
    goto :eof
)

:: 3. Run syntax validation (check_rdf.py)
echo.
echo --- 🚀 Running syntax validation (check_rdf.py) ---
:: We use %cd% to mount the current directory (the root of the repo) to /app
docker run --rm -v "%cd%:/app" %IMAGE_NAME% python3 scripts/check_rdf.py
if %errorlevel% neq 0 (
    echo [ERROR] Syntax validation failed.
    goto :eof
)

:: 4. Run SHACL validation (minimal-example)
echo.
echo --- 🚀 Running SHACL validation (minimal-example) ---
docker run --rm -v "%cd%:/app" %IMAGE_NAME% pyshacl -s shapes/edaan-shapes.ttl -d docs/examples/minimal-example.ttl -i docs/ontology/edaan-owl.ttl -m -f human
if %errorlevel% neq 0 (
    echo [ERROR] SHACL validation failed.
    goto :eof
)

:: 5. Run consistency validation (ROBOT)
echo.
echo --- 🚀 Running consistency validation (ROBOT) ---
docker run --rm -v "%cd%:/app" %IMAGE_NAME% java -jar /app/robot.jar validate --input docs/ontology/edaan-owl.ttl
if %errorlevel% neq 0 (
    echo [ERROR] ROBOT consistency validation failed.
    goto :eof
)

echo.
echo --- ✅ Local validation completed successfully ---
endlocal