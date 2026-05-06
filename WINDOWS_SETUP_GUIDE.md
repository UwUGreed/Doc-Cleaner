# Fresh Windows Setup Guide - PII/PHI Sanitizer

Complete step-by-step instructions for setting up the PII/PHI Sanitizer on a brand new Windows machine.

---

## 📋 Prerequisites Checklist

Before you begin, you need:
- ✅ Windows 10 or Windows 11
- ✅ Administrator access
- ✅ Internet connection
- ✅ ~2 GB free disk space

---

## 🔧 Step 1: Install Python

### Download Python

1. Open your web browser
2. Go to: **https://www.python.org/downloads/**
3. Click the big yellow button: **"Download Python 3.11.x"** (or latest 3.11.x version)
4. Wait for download to complete

### Install Python

1. **Double-click** the downloaded file (e.g., `python-3.11.x-amd64.exe`)
2. **IMPORTANT:** Check both boxes at the bottom:
   - ☑️ **"Add python.exe to PATH"** ← CRITICAL!
   - ☑️ "Install launcher for all users"
3. Click **"Install Now"**
4. Wait for installation (~5 minutes)
5. Click **"Close"** when done

### Verify Python Installation

1. Press `Windows Key + R`
2. Type: `cmd` and press Enter
3. In the black window (Command Prompt), type:
   ```cmd
   python --version
   ```
4. You should see: `Python 3.11.x`
5. Also verify pip:
   ```cmd
   pip --version
   ```
6. You should see: `pip 23.x.x from...`

✅ **If both commands work, Python is installed correctly!**

❌ **If you get "command not found":** Python wasn't added to PATH. Reinstall and check the box.

---

## 📦 Step 2: Install Git

### Download Git

1. Go to: **https://git-scm.com/download/win**
2. Download will start automatically
3. If not, click **"Click here to download manually"**

### Install Git

1. **Double-click** the downloaded file (e.g., `Git-2.43.0-64-bit.exe`)
2. Click **"Next"** through all screens (default settings are fine)
3. Wait for installation (~2 minutes)
4. Click **"Finish"**

### Verify Git Installation

1. Open Command Prompt (Windows Key + R → type `cmd` → Enter)
2. Type:
   ```cmd
   git --version
   ```
3. You should see: `git version 2.43.x`

✅ **If you see a version number, Git is installed!**

---

## 📂 Step 3: Clone the Repository

### Open Command Prompt

1. Press `Windows Key`
2. Type: `cmd`
3. Press `Enter`

### Navigate to Your Desired Location

```cmd
# Go to your Documents folder (recommended)
cd %USERPROFILE%\Documents

# Or go to Desktop
cd %USERPROFILE%\Desktop

# Or create a dedicated folder
mkdir C:\Projects
cd C:\Projects
```

### Clone the Repository

```cmd
git clone https://github.com/UwUGreed/Doc-Cleaner.git
```

You should see:
```
Cloning into 'Doc-Cleaner'...
remote: Enumerating objects: ...
remote: Counting objects: ...
Receiving objects: 100% ...
```

### Navigate into the Project

```cmd
cd Doc-Cleaner
```

---

## 🐍 Step 4: Install Python Dependencies

### Install All Required Packages

```cmd
pip install -r requirements.txt
```

This will install:
- customtkinter (modern UI)
- tkinterdnd2 (drag & drop)
- presidio-analyzer (PII detection)
- presidio-anonymizer
- spacy (NLP engine)
- PyPDF2 (PDF support)
- python-docx (Word support)
- reportlab (PDF creation)

**⏱️ This takes 2-5 minutes depending on your internet speed.**

### Download SpaCy Language Model

This is the AI model that detects names and entities:

```cmd
python -m spacy download en_core_web_lg
```

**⏱️ This downloads ~780 MB and takes 5-10 minutes.**

**Alternative (smaller, faster, but less accurate):**
```cmd
python -m spacy download en_core_web_sm
```
This is only ~40 MB but slightly less accurate.

---

## 🚀 Step 5: Run the Application

### Start the App

```cmd
python pii_sanitizer.py
```

You should see:
1. A modern dark-themed window opens
2. Activity log shows: "🚀 Application started..."
3. After a few seconds: "✅ Presidio Engine Ready with Custom Recognizers"
4. Status bar shows: "✅ Ready to sanitize files"

✅ **If you see the GUI window, SUCCESS!**

---

## 🧪 Step 6: Test the Application

### Test with Sample Files

The repository includes 3 test files:
- `test_data.txt` (plain text)
- `test_data.pdf` (PDF document)
- `test_data.docx` (Word document)

### Test Workflow:

1. **Drag & Drop** `test_data.txt` onto the app window
2. Watch the log detect entities:
   ```
   🔍 Scanning: test_data.txt
   📄 Detected format: TEXT
   ✅ SANITIZATION COMPLETE
   📊 Detected and Scrubbed:
      • 3x PERSON
      • 3x US_SSN
      • 3x EMAIL_ADDRESS
      ...
   ```
3. Check your folder - you'll see:
   - `test_data_SANITIZED.txt` (with tokens)
   - `test_data_SANITIZED.session` (session data)

4. **Click "Rehydrate File"** button
5. Select `test_data_SANITIZED.txt`
6. Watch the log show:
   ```
   ✅ REHYDRATION COMPLETE
   🔓 Restored 15 sensitive items
   🔥 THE SHREDDER PROTOCOL ACTIVATED
   ```
7. Check your folder - you'll see:
   - `test_data_SANITIZED_RESTORED.txt` (original data back!)
   - Session file is GONE (shredded)

---

## 🔨 Step 7: Build Executable (Optional)

If you want to create a standalone `.exe` file:

### Install PyInstaller

```cmd
pip install pyinstaller
```

### Run the Automated Build Script

```cmd
build_windows.bat
```

OR use PowerShell (recommended):

```cmd
powershell -ExecutionPolicy Bypass -File build_windows.ps1
```

**⏱️ This takes 5-10 minutes and creates a 400-600 MB executable.**

### Find Your Executable

After building completes:
```
dist\PII_Sanitizer.exe
```

This is a **standalone executable** that can run on any Windows machine without Python installed!

---

## 📝 Complete Command Summary

Here's every command in one place for easy copy-paste:

```cmd
# 1. Verify Python and pip
python --version
pip --version

# 2. Verify Git
git --version

# 3. Navigate to desired location
cd %USERPROFILE%\Documents

# 4. Clone repository
git clone https://github.com/UwUGreed/Doc-Cleaner.git

# 5. Enter project folder
cd Doc-Cleaner

# 6. Install dependencies
pip install -r requirements.txt

# 7. Download SpaCy model (LARGE - recommended)
python -m spacy download en_core_web_lg

# OR download SMALL model (faster but less accurate)
python -m spacy download en_core_web_sm

# 8. Run the application
python pii_sanitizer.py

# 9. (Optional) Build executable
pip install pyinstaller
build_windows.bat
```

---

## 🐛 Troubleshooting

### Problem: "python is not recognized"

**Cause:** Python not in PATH

**Solution:**
1. Uninstall Python
2. Reinstall and CHECK the box: "Add python.exe to PATH"
3. Restart Command Prompt

### Problem: "git is not recognized"

**Cause:** Git not in PATH

**Solution:**
1. Restart Command Prompt (Git path is set during install)
2. If still not working, reinstall Git

### Problem: "pip install" fails with SSL error

**Cause:** Corporate firewall or antivirus

**Solution:**
```cmd
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
```

### Problem: SpaCy model download fails

**Cause:** Large file (780 MB) timeout

**Solution:**
1. Use smaller model: `python -m spacy download en_core_web_sm`
2. Or download manually from: https://github.com/explosion/spacy-models/releases
3. Install with: `pip install en_core_web_lg-3.7.1.tar.gz`

### Problem: "No module named 'tkinter'"

**Cause:** Python installed without Tkinter (rare)

**Solution:**
1. Reinstall Python
2. During install, click "Customize installation"
3. Ensure "tcl/tk and IDLE" is checked

### Problem: App crashes immediately after opening

**Cause:** Missing dependencies

**Solution:**
```cmd
# Reinstall all dependencies
pip uninstall -y customtkinter tkinterdnd2 presidio-analyzer spacy
pip install -r requirements.txt
python -m spacy download en_core_web_lg
```

### Problem: "Permission denied" when cloning

**Cause:** Protected folder

**Solution:**
```cmd
# Clone to a different location
cd %USERPROFILE%\Desktop
git clone https://github.com/UwUGreed/Doc-Cleaner.git
```

---

## 🔐 Windows Security Warnings

### When Running .exe File

Windows may show: "Windows protected your PC"

**This is normal for unsigned applications.**

To run anyway:
1. Click "More info"
2. Click "Run anyway"

**Why this happens:**
- The app isn't digitally signed (costs $300+/year)
- It's safe - you built it yourself from source code

---

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Windows 10 | Windows 11 |
| RAM | 4 GB | 8 GB |
| Disk Space | 2 GB | 5 GB |
| Python | 3.9 | 3.11 |
| Internet | Required for setup | - |

---

## 🎯 Quick Reference Card

### Most Common Commands:

```cmd
# Start the app
python pii_sanitizer.py

# Update to latest version
cd Doc-Cleaner
git pull
pip install -r requirements.txt --upgrade

# Build executable
build_windows.bat

# Check if everything installed
python -c "import customtkinter, presidio_analyzer, spacy; print('All good!')"
```

---

## 📞 Getting Help

### Check Installation Status

```cmd
# Check Python
python --version

# Check all required packages
pip list | findstr "customtkinter tkinterdnd2 presidio spacy PyPDF2 docx reportlab"

# Check SpaCy model
python -c "import en_core_web_lg; print('SpaCy model found!')"
```

### If Still Having Issues

1. Check the Activity Log in the app for error messages
2. Run with console visible:
   ```cmd
   python pii_sanitizer.py
   ```
3. Look for error messages in the console

---

## 🎓 Next Steps

Once everything is working:

1. ✅ Test all 3 sample files (txt, pdf, docx)
2. ✅ Try sanitizing your own documents
3. ✅ Test the rehydration feature
4. ✅ Build the executable for distribution
5. ✅ Read the FILE_FORMAT_GUIDE.md for format-specific tips

---

## 🔄 Updating the Application

When updates are released:

```cmd
# Navigate to project folder
cd %USERPROFILE%\Documents\Doc-Cleaner

# Pull latest changes
git pull

# Update dependencies (if requirements.txt changed)
pip install -r requirements.txt --upgrade

# Run updated version
python pii_sanitizer.py
```

---

**You're all set!** 🎉

The application is now ready to sanitize sensitive data from your documents.
