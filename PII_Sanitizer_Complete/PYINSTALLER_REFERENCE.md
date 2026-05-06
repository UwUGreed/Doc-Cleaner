# PyInstaller Command Reference - PII/PHI Sanitizer

## 🎯 The Complete PyInstaller Command

This document provides every variation of the PyInstaller command you might need.

---

## ✅ Standard Windows Command (Recommended)

### Prerequisites
```bash
# 1. Install PyInstaller
pip install pyinstaller==6.3.0

# 2. Find your SpaCy model path
python -c "import en_core_web_lg; print(en_core_web_lg.__path__[0])"
```

### Full Command (Multi-line for readability)

```bash
pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --windowed ^
  --icon=NONE ^
  --add-data "C:\Users\YourUser\AppData\Local\Programs\Python\Python311\Lib\site-packages\en_core_web_lg\en_core_web_lg-3.7.1;en_core_web_lg/en_core_web_lg-3.7.1" ^
  --hidden-import=tiktoken_ext.openai_public ^
  --hidden-import=tiktoken_ext ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=presidio_analyzer.nlp_engine ^
  --hidden-import=presidio_analyzer.predefined_recognizers ^
  --hidden-import=spacy ^
  --hidden-import=en_core_web_lg ^
  --collect-all=customtkinter ^
  --collect-all=tkinterdnd2 ^
  --collect-all=presidio_analyzer ^
  --collect-all=spacy ^
  --noconfirm ^
  pii_sanitizer.py
```

### One-Line Version (for copy-paste)

```bash
pyinstaller --name="PII_Sanitizer" --onefile --windowed --icon=NONE --add-data "C:\Users\YourUser\AppData\Local\Programs\Python\Python311\Lib\site-packages\en_core_web_lg\en_core_web_lg-3.7.1;en_core_web_lg/en_core_web_lg-3.7.1" --hidden-import=tiktoken_ext.openai_public --hidden-import=tiktoken_ext --hidden-import=presidio_analyzer --hidden-import=presidio_analyzer.nlp_engine --hidden-import=presidio_analyzer.predefined_recognizers --hidden-import=spacy --hidden-import=en_core_web_lg --collect-all=customtkinter --collect-all=tkinterdnd2 --collect-all=presidio_analyzer --collect-all=spacy --noconfirm pii_sanitizer.py
```

---

## 🐧 Linux/macOS Command

**Key Difference:** Use `:` instead of `;` for path separators

```bash
pyinstaller --name="PII_Sanitizer" \
  --onefile \
  --windowed \
  --icon=NONE \
  --add-data "/home/user/.local/lib/python3.11/site-packages/en_core_web_lg/en_core_web_lg-3.7.1:en_core_web_lg/en_core_web_lg-3.7.1" \
  --hidden-import=tiktoken_ext.openai_public \
  --hidden-import=tiktoken_ext \
  --hidden-import=presidio_analyzer \
  --hidden-import=presidio_analyzer.nlp_engine \
  --hidden-import=presidio_analyzer.predefined_recognizers \
  --hidden-import=spacy \
  --hidden-import=en_core_web_lg \
  --collect-all=customtkinter \
  --collect-all=tkinterdnd2 \
  --collect-all=presidio_analyzer \
  --collect-all=spacy \
  --noconfirm \
  pii_sanitizer.py
```

---

## 📦 Using Small SpaCy Model (Smaller EXE)

If you want a smaller executable (~200-300MB instead of ~500MB):

```bash
# First, download the small model
python -m spacy download en_core_web_sm

# Then find its path
python -c "import en_core_web_sm; print(en_core_web_sm.__path__[0])"

# Build with small model
pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --windowed ^
  --icon=NONE ^
  --add-data "C:\...\en_core_web_sm\en_core_web_sm-3.7.1;en_core_web_sm/en_core_web_sm-3.7.1" ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=spacy ^
  --hidden-import=en_core_web_sm ^
  --collect-all=customtkinter ^
  --collect-all=tkinterdnd2 ^
  --collect-all=presidio_analyzer ^
  --noconfirm ^
  pii_sanitizer.py
```

---

## 🎨 With Custom Icon

```bash
# Create or download a .ico file (Windows) or .icns (Mac)
# Place it in the same directory as pii_sanitizer.py

pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --windowed ^
  --icon="sanitizer_icon.ico" ^
  --add-data "...\en_core_web_lg\en_core_web_lg-3.7.1;en_core_web_lg/en_core_web_lg-3.7.1" ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=spacy ^
  --hidden-import=en_core_web_lg ^
  --collect-all=customtkinter ^
  --collect-all=tkinterdnd2 ^
  --collect-all=presidio_analyzer ^
  --noconfirm ^
  pii_sanitizer.py
```

---

## 🔍 Debugging Build Issues

### Enable Console Output (for troubleshooting)

Remove `--windowed` to see Python output:

```bash
pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --add-data "...\en_core_web_lg\en_core_web_lg-3.7.1;en_core_web_lg/en_core_web_lg-3.7.1" ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=spacy ^
  --hidden-import=en_core_web_lg ^
  --collect-all=customtkinter ^
  --collect-all=tkinterdnd2 ^
  --collect-all=presidio_analyzer ^
  --noconfirm ^
  pii_sanitizer.py
```

### Clean Build (remove cache)

```bash
# Delete build artifacts
rmdir /s /q build dist
del PII_Sanitizer.spec

# Then rebuild
pyinstaller [your command here]
```

---

## 📋 Flag Explanations

| Flag | Purpose | Required? |
|------|---------|-----------|
| `--name="PII_Sanitizer"` | Output executable name | Optional |
| `--onefile` | Bundle everything into single .exe | Recommended |
| `--windowed` | Hide console window | Recommended for GUI |
| `--icon="file.ico"` | Custom application icon | Optional |
| `--add-data "source;dest"` | Include SpaCy model files | **CRITICAL** |
| `--hidden-import=module` | Force include Python modules | **CRITICAL** |
| `--collect-all=package` | Include all package data | **CRITICAL** |
| `--noconfirm` | Overwrite without prompting | Convenience |

---

## ⚠️ Critical Notes

### 1. The `--add-data` Flag is MANDATORY

Without this, Presidio cannot find the SpaCy model and the app will crash.

**Windows Format:**
```
--add-data "SOURCE_PATH;DESTINATION_PATH"
```

**Linux/Mac Format:**
```
--add-data "SOURCE_PATH:DESTINATION_PATH"
```

### 2. SpaCy Model Path Must Be Exact

Don't guess! Always run:
```bash
python -c "import en_core_web_lg; print(en_core_web_lg.__path__[0])"
```

### 3. Version-Specific Paths

The SpaCy model path includes a version number:
```
en_core_web_lg-3.7.1  ← This changes with SpaCy version
```

If you upgrade SpaCy, you must update the path!

### 4. Windows Path Quirks

If your path has spaces, wrap it in quotes:
```bash
--add-data "C:\Program Files\Python\...\en_core_web_lg;en_core_web_lg/en_core_web_lg-3.7.1"
```

---

## 🧪 Verification After Build

### 1. Check File Size
```bash
dir dist\PII_Sanitizer.exe
```
Should be 400-600 MB (large model) or 200-300 MB (small model)

### 2. Test Run
```bash
dist\PII_Sanitizer.exe
```
Should launch GUI with no console errors

### 3. Check Presidio Initialization
Look for in the Activity Log:
```
✅ SpaCy model loaded successfully
✅ Presidio Engine Ready with Custom Recognizers
```

### 4. Test Detection
Drag `test_data.txt` and verify detection of all entity types

---

## 🔧 Common Build Errors & Fixes

### Error: "Cannot find 'en_core_web_lg'"

**Solution:**
```bash
python -m spacy download en_core_web_lg
```

### Error: "FileNotFoundError: [Errno 2] No such file or directory"

**Cause:** Wrong SpaCy model path in `--add-data`

**Solution:** Re-run the path detection command

### Error: "ImportError: cannot import name 'AnalyzerEngine'"

**Cause:** Missing `--hidden-import` or `--collect-all` flags

**Solution:** Add:
```bash
--hidden-import=presidio_analyzer
--collect-all=presidio_analyzer
```

### Error: EXE crashes immediately (no window)

**Cause:** Missing dependencies

**Solution:** Build without `--windowed` to see error messages

### Error: "tkinter.TclError: Can't find a usable init.tcl"

**Cause:** CustomTkinter not properly bundled

**Solution:** Add:
```bash
--collect-all=customtkinter
```

---

## 📦 Distribution

### Single File Distribution

The `--onefile` flag creates a portable executable:
- **No installation needed**
- **No Python required on target machine**
- **Just copy and run**

### What to Distribute

```
PII_Sanitizer.exe  ← Only this file needed!
```

Users do NOT need:
- Python installed
- Any pip packages
- SpaCy models
- Configuration files

Everything is bundled in the .exe!

---

## 🚀 Advanced: Spec File Customization

After first build, PyInstaller creates `PII_Sanitizer.spec`. You can edit this for advanced control:

```python
# PII_Sanitizer.spec
a = Analysis(
    ['pii_sanitizer.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('C:\\...\\en_core_web_lg\\en_core_web_lg-3.7.1', 'en_core_web_lg/en_core_web_lg-3.7.1')
    ],
    hiddenimports=[
        'presidio_analyzer',
        'spacy',
        'en_core_web_lg'
    ],
    hookspath=[],
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=None,
    noarchive=False
)

pyz = PYZ(a.pure, a.zipped_data, cipher=None)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='PII_Sanitizer',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,  # Set to True for debugging
    icon=None
)
```

Then rebuild with:
```bash
pyinstaller PII_Sanitizer.spec
```

---

## 📊 Build Time & Size Expectations

| Configuration | Build Time | EXE Size | Detection Accuracy |
|--------------|------------|----------|-------------------|
| Large Model (lg) | 8-12 min | 400-600 MB | ⭐⭐⭐⭐⭐ Excellent |
| Small Model (sm) | 5-8 min | 200-300 MB | ⭐⭐⭐⭐ Good |

**Recommendation:** Use large model for production deployments.

---

## ✅ Complete Build Checklist

- [ ] Python 3.9-3.11 installed
- [ ] All dependencies installed (`pip install -r requirements.txt`)
- [ ] SpaCy model downloaded (`python -m spacy download en_core_web_lg`)
- [ ] SpaCy model path obtained
- [ ] PyInstaller installed (`pip install pyinstaller`)
- [ ] Build command executed successfully
- [ ] `dist/PII_Sanitizer.exe` created
- [ ] Executable tested with sample data
- [ ] All entity types detected correctly
- [ ] Rehydration works properly
- [ ] Vault shredding confirmed

---

**Last Updated:** December 2024  
**PyInstaller Version:** 6.3.0  
**Tested with:** Python 3.11, SpaCy 3.7.2, Presidio 2.2.354
