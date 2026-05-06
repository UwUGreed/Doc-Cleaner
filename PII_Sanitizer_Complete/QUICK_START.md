# Quick Start - One Page Reference

For experienced Windows users. Full guide: WINDOWS_SETUP_GUIDE.md

---

## ⚡ TL;DR - Copy/Paste These Commands

```cmd
# 1. Install Python 3.11 from python.org (CHECK "Add to PATH")
# 2. Install Git from git-scm.com

# 3. Clone and setup
cd %USERPROFILE%\Documents
git clone https://github.com/UwUGreed/Doc-Cleaner.git
cd Doc-Cleaner
pip install -r requirements.txt
python -m spacy download en_core_web_lg

# 4. Run
python pii_sanitizer.py

# 5. (Optional) Build .exe
pip install pyinstaller
build_windows.bat
```

---

## 📦 What Gets Installed

```
Requirements:
├── customtkinter (UI)
├── tkinterdnd2 (Drag & Drop)
├── presidio-analyzer (PII Detection)
├── spacy (NLP)
├── PyPDF2 (PDF Reading)
├── python-docx (Word Docs)
└── reportlab (PDF Writing)

SpaCy Model:
└── en_core_web_lg (~780 MB) - or en_core_web_sm (~40 MB)
```

---

## 🚀 Three Ways to Run

### 1. Direct Python
```cmd
python pii_sanitizer.py
```

### 2. Build & Run Executable
```cmd
build_windows.bat
dist\PII_Sanitizer.exe
```

### 3. PowerShell Build (Better)
```cmd
powershell -ExecutionPolicy Bypass -File build_windows.ps1
dist\PII_Sanitizer.exe
```

---

## 🧪 Test Files Included

- `test_data.txt` - Plain text
- `test_data.pdf` - PDF document
- `test_data.docx` - Word document

**Test:** Drag any file → Check _SANITIZED output → Rehydrate → Check _RESTORED

---

## 🐛 Common Issues

| Problem | Fix |
|---------|-----|
| `python: command not found` | Reinstall Python, CHECK "Add to PATH" |
| `git: command not found` | Install Git from git-scm.com |
| SpaCy download fails | Use: `python -m spacy download en_core_web_sm` (smaller) |
| SSL error during pip | Add: `pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt` |
| App crashes on start | Run: `pip install -r requirements.txt --force-reinstall` |

---

## 📊 System Requirements

- Windows 10/11
- Python 3.9-3.11
- 4 GB RAM (8 GB recommended)
- 2 GB disk space

---

## 🔄 Update Commands

```cmd
cd Doc-Cleaner
git pull
pip install -r requirements.txt --upgrade
python pii_sanitizer.py
```

---

## 🎯 Feature Highlights

- ✅ 15+ PII/PHI entity types
- ✅ Supports .txt, .pdf, .docx, .csv, .json, .xml, .html
- ✅ Session-based tokenization
- ✅ Self-destructing vault
- ✅ Dark/Light mode
- ✅ Drag & Drop interface

---

**Full Documentation:** README.md | BUILD_GUIDE.md | FILE_FORMAT_GUIDE.md
