# PII/PHI Sanitizer - Automated Build Script (PowerShell)
# Run with: powershell -ExecutionPolicy Bypass -File build_windows.ps1

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "PII/PHI Sanitizer - Automated Build Script" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install dependencies
Write-Host "Step 1: Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install dependencies" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Step 2: Download SpaCy model
Write-Host "Step 2: Downloading SpaCy model (this may take a few minutes)..." -ForegroundColor Yellow
python -m spacy download en_core_web_lg
if ($LASTEXITCODE -ne 0) {
    Write-Host "WARNING: Large model failed. Trying small model..." -ForegroundColor Yellow
    python -m spacy download en_core_web_sm
    $SpacyModel = "en_core_web_sm"
} else {
    $SpacyModel = "en_core_web_lg"
}
Write-Host ""

# Step 3: Detect SpaCy model path
Write-Host "Step 3: Detecting SpaCy model path..." -ForegroundColor Yellow
$SpacyPath = python -c "import $SpacyModel; print($SpacyModel.__path__[0])"
Write-Host "Found SpaCy model at: $SpacyPath" -ForegroundColor Green
Write-Host ""

# Step 4: Install PyInstaller
Write-Host "Step 4: Installing PyInstaller..." -ForegroundColor Yellow
pip install pyinstaller==6.3.0
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to install PyInstaller" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
Write-Host ""

# Step 5: Build executable
Write-Host "Step 5: Building executable..." -ForegroundColor Yellow
Write-Host "This may take 5-10 minutes depending on your system..." -ForegroundColor Gray
Write-Host ""

$PyInstallerArgs = @(
    "--name=PII_Sanitizer",
    "--onefile",
    "--windowed",
    "--icon=NONE",
    "--add-data=$SpacyPath;$SpacyModel/$SpacyModel-3.7.1",
    "--hidden-import=tiktoken_ext.openai_public",
    "--hidden-import=tiktoken_ext",
    "--hidden-import=presidio_analyzer",
    "--hidden-import=presidio_analyzer.nlp_engine",
    "--hidden-import=presidio_analyzer.predefined_recognizers",
    "--hidden-import=spacy",
    "--hidden-import=$SpacyModel",
    "--hidden-import=PyPDF2",
    "--hidden-import=docx",
    "--hidden-import=reportlab",
    "--collect-all=customtkinter",
    "--collect-all=tkinterdnd2",
    "--collect-all=presidio_analyzer",
    "--collect-all=spacy",
    "--collect-all=PyPDF2",
    "--collect-all=docx",
    "--collect-all=reportlab",
    "--noconfirm",
    "pii_sanitizer.py"
)

& pyinstaller $PyInstallerArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "BUILD SUCCESSFUL!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your executable is located at:" -ForegroundColor Cyan
Write-Host "  dist\PII_Sanitizer.exe" -ForegroundColor White
Write-Host ""
Write-Host "File size: approximately 400-600 MB" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test the executable with sample data" -ForegroundColor White
Write-Host "2. Copy dist\PII_Sanitizer.exe to your deployment location" -ForegroundColor White
Write-Host "3. Distribute to end users" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit"
