@echo off
echo ================================================
echo PII/PHI Sanitizer - Automated Build Script
echo ================================================
echo.

echo Step 1: Installing dependencies...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install dependencies
    pause
    exit /b 1
)
echo.

echo Step 2: Downloading SpaCy model (this may take a few minutes)...
python -m spacy download en_core_web_lg
if errorlevel 1 (
    echo WARNING: Large model failed. Trying small model...
    python -m spacy download en_core_web_sm
    set SPACY_MODEL=en_core_web_sm
) else (
    set SPACY_MODEL=en_core_web_lg
)
echo.

echo Step 3: Detecting SpaCy model path...
for /f "delims=" %%i in ('python -c "import %SPACY_MODEL%; print(%SPACY_MODEL%.__path__[0])"') do set SPACY_PATH=%%i
echo Found SpaCy model at: %SPACY_PATH%
echo.

echo Step 4: Installing PyInstaller...
pip install pyinstaller==6.3.0
if errorlevel 1 (
    echo ERROR: Failed to install PyInstaller
    pause
    exit /b 1
)
echo.

echo Step 5: Building executable...
echo This may take 5-10 minutes depending on your system...
echo.

pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --windowed ^
  --icon=NONE ^
  --add-data "%SPACY_PATH%;%SPACY_MODEL%/%SPACY_MODEL%-3.7.1" ^
  --hidden-import=tiktoken_ext.openai_public ^
  --hidden-import=tiktoken_ext ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=presidio_analyzer.nlp_engine ^
  --hidden-import=presidio_analyzer.predefined_recognizers ^
  --hidden-import=spacy ^
  --hidden-import=%SPACY_MODEL% ^
  --hidden-import=PyPDF2 ^
  --hidden-import=docx ^
  --hidden-import=reportlab ^
  --collect-all=customtkinter ^
  --collect-all=tkinterdnd2 ^
  --collect-all=presidio_analyzer ^
  --collect-all=spacy ^
  --collect-all=PyPDF2 ^
  --collect-all=docx ^
  --collect-all=reportlab ^
  --noconfirm ^
  pii_sanitizer.py

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo Check the error messages above.
    pause
    exit /b 1
)

echo.
echo ================================================
echo BUILD SUCCESSFUL!
echo ================================================
echo.
echo Your executable is located at:
echo   dist\PII_Sanitizer.exe
echo.
echo File size: approximately 400-600 MB
echo.
echo Next steps:
echo 1. Test the executable with sample data
echo 2. Copy dist\PII_Sanitizer.exe to your deployment location
echo 3. Distribute to end users
echo.
pause
