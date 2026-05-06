# PII/PHI Sanitizer - Build & Deployment Guide

## 🚀 Quick Start

### 1. Install Dependencies

```bash
# Install Python packages
pip install -r requirements.txt

# Download SpaCy language model (CRITICAL)
python -m spacy download en_core_web_lg

# If en_core_web_lg fails (it's large ~780MB), use the small model as fallback:
python -m spacy download en_core_web_sm
```

**New in this version:** Added PDF and DOCX support
- PyPDF2 for reading PDF files
- python-docx for reading/writing Word documents
- reportlab for creating PDF outputs

### 2. Test the Application

```bash
python pii_sanitizer.py
```

The app should launch with a modern dark-themed GUI. Wait for "System Ready" status.

---

## 📦 Building the Executable with PyInstaller

### Step 1: Install PyInstaller

```bash
pip install pyinstaller==6.3.0
```

### Step 2: Locate SpaCy Model Path

You need to find where SpaCy installed the model:

```bash
# Run this Python command to get the exact path
python -c "import en_core_web_lg; print(en_core_web_lg.__path__[0])"
```

**Example output:**
```
C:\Users\YourName\AppData\Local\Programs\Python\Python311\Lib\site-packages\en_core_web_lg\en_core_web_lg-3.7.1
```

**Copy this path** - you'll need it in the next step.

### Step 3: Build the EXE (CRITICAL COMMAND)

Replace `YOUR_SPACY_MODEL_PATH` with the path from Step 2:

```bash
pyinstaller --name="PII_Sanitizer" ^
  --onefile ^
  --windowed ^
  --icon=NONE ^
  --add-data "YOUR_SPACY_MODEL_PATH;en_core_web_lg/en_core_web_lg-3.7.1" ^
  --hidden-import=tiktoken_ext.openai_public ^
  --hidden-import=tiktoken_ext ^
  --hidden-import=presidio_analyzer ^
  --hidden-import=presidio_analyzer.nlp_engine ^
  --hidden-import=presidio_analyzer.predefined_recognizers ^
  --hidden-import=spacy ^
  --hidden-import=en_core_web_lg ^
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
```

### ⚠️ CRITICAL NOTES:

1. **The `--add-data` flag is ESSENTIAL** - Without it, Presidio won't find the SpaCy model
2. **Format for Windows:** `source_path;destination_path` (semicolon separator)
3. **Format for Linux/Mac:** `source_path:destination_path` (colon separator)
4. **The `^` character** is for line continuation in Windows CMD. Use `\` on Linux/Mac.

### Step 4: Alternative - One-Line Command (Windows)

If you have `en_core_web_lg` installed in the default location:

```bash
pyinstaller --name="PII_Sanitizer" --onefile --windowed --add-data "C:\Users\%USERNAME%\AppData\Local\Programs\Python\Python311\Lib\site-packages\en_core_web_lg\en_core_web_lg-3.7.1;en_core_web_lg/en_core_web_lg-3.7.1" --hidden-import=presidio_analyzer --hidden-import=spacy --hidden-import=en_core_web_lg --hidden-import=PyPDF2 --hidden-import=docx --hidden-import=reportlab --collect-all=customtkinter --collect-all=tkinterdnd2 --collect-all=presidio_analyzer --collect-all=PyPDF2 --collect-all=docx --collect-all=reportlab --noconfirm pii_sanitizer.py
```

### Step 5: Locate Your Executable

After building completes:

```
dist/PII_Sanitizer.exe  (Windows)
dist/PII_Sanitizer      (Linux/Mac)
```

Size will be approximately **400-600 MB** due to the SpaCy model.

---

## 🧪 Testing the Executable

### Create Test Files

Three test files are provided:

#### test_data.txt (Plain Text)
```
John Doe's SSN is 123-45-6789.
Contact him at john.doe@email.com or (555) 123-4567.
He lives at 123 Main Street, Springfield, IL 62701.
MRN: 98765432
Credit Card: 4532-1234-5678-9010
Insurance Policy: POL-87654321
Health Plan ID: HP-ABC123456
Driver's License: DL-X12345678
```

#### test_data.pdf (PDF Document)
A professionally formatted medical record with:
- Patient information table
- Insurance details
- Clinical notes
- Multiple patient records

#### test_data.docx (Word Document)
A Word document with:
- Formatted headers and sections
- Tables with patient data
- Bold labels and structured content
- Multiple patients with various PII/PHI types

### Test Workflow:

1. **Launch** `PII_Sanitizer.exe`
2. **Drag & Drop** `test_data.txt` (or `test_data.pdf` or `test_data.docx`) into the app
3. **Verify** the log shows detected entities:
   ```
   📄 Detected format: TXT (or PDF or DOCX)
   ✅ SANITIZATION COMPLETE
   📊 Detected and Scrubbed:
      • 1x PERSON
      • 1x US_SSN
      • 1x EMAIL_ADDRESS
      • 1x PHONE_NUMBER
      • 1x LOCATION
      • 1x CREDIT_CARD
      • 1x MEDICAL_RECORD_NUMBER
      • 1x INSURANCE_POLICY
      • 1x HEALTH_PLAN_ID
      • 1x DRIVERS_LICENSE
   ```
4. **Check Output:** 
   - For TXT: `test_data_SANITIZED.txt` with tokens
   - For PDF: `test_data_SANITIZED.pdf` (or `.txt` fallback)
   - For DOCX: `test_data_SANITIZED.docx` (or `.txt` fallback)
5. **Rehydrate:** Click "Rehydrate File", select the sanitized file
6. **Verify:** Check the `_RESTORED` file has original data back in the original format
7. **Confirm Shredding:** Check the log for "THE SHREDDER PROTOCOL ACTIVATED"

---

## 🔐 Security Architecture

### Session Vault Location
```
%APPDATA%\PIISanitizer\session_vault.json
```

### Data Flow

1. **Sanitization:**
   - File → Presidio Analysis → Token Generation → Vault Storage → Sanitized File
   
2. **Rehydration:**
   - Sanitized File → Vault Lookup → Token Replacement → Restored File → **VAULT DELETION**

3. **App Close:**
   - Complete vault destruction (`session_vault.json` deleted)

### The Shredder Protocol

- **Trigger 1:** After rehydration, the specific session is permanently deleted
- **Trigger 2:** On app close, the entire vault file is wiped
- **No recovery:** Once shredded, mappings cannot be recovered

---

## 📋 Detected Entity Types

### Identity
- ✅ Full Names (PERSON)
- ✅ Social Security Numbers (US_SSN)
- ✅ Driver's License Numbers (DRIVERS_LICENSE)
- ✅ US Passport Numbers (US_PASSPORT)

### Contact Information
- ✅ Phone Numbers (PHONE_NUMBER)
- ✅ Email Addresses (EMAIL_ADDRESS)
- ✅ Physical Addresses (LOCATION)

### Healthcare (PHI)
- ✅ Medical Record Numbers (MEDICAL_RECORD_NUMBER)
- ✅ Health Plan IDs (HEALTH_PLAN_ID)
- ✅ Birthdates (DATE_TIME)
- ✅ Medical License Numbers (MEDICAL_LICENSE)

### Financial
- ✅ Credit Card Numbers (CREDIT_CARD)
- ✅ Bank Account Numbers (US_BANK_NUMBER)
- ✅ IBAN Codes (IBAN_CODE)

### Custom Insurance Patterns
- ✅ Insurance Policy Numbers (INSURANCE_POLICY)
  - Formats: POL-12345678, POLICY-12345678, INS-12345678

---

## 🐛 Troubleshooting

### Issue: "SpaCy model not found"

**Solution:**
```bash
python -m spacy download en_core_web_lg
# Then rebuild with PyInstaller
```

### Issue: "Module not found" errors in EXE

**Solution:** Add the module to `--hidden-import`:
```bash
--hidden-import=missing_module_name
```

### Issue: EXE is huge (>1GB)

**Cause:** Using `en_core_web_lg` (large model)

**Solution:** Use the smaller model:
```bash
python -m spacy download en_core_web_sm
```
Then rebuild, changing the `--add-data` path to `en_core_web_sm`.

### Issue: "No PII/PHI detected" for obvious data

**Solution:**
1. Check the file encoding (must be UTF-8)
2. Verify Presidio initialized correctly (check log)
3. Test with simpler examples first

### Issue: Drag & Drop not working

**Solution:**
- Ensure `tkinterdnd2` is properly installed
- Try clicking "Sanitize File" button instead
- Check if running as administrator (sometimes blocks drag-drop)

---

## 🎨 Customization

### Add Custom Entity Types

Edit `pii_sanitizer.py` and add to `PresidioEngine.__init__`:

```python
def _add_custom_recognizer(self):
    custom_pattern = Pattern(
        name="custom_pattern",
        regex=r"\bYOUR-REGEX-HERE\b",
        score=0.85
    )
    custom_recognizer = PatternRecognizer(
        supported_entity="CUSTOM_ENTITY_NAME",
        patterns=[custom_pattern]
    )
    self.analyzer.registry.add_recognizer(custom_recognizer)
```

Then call it in `_initialize_engine()`:
```python
self._add_custom_recognizer()
```

### Change Token Format

Edit the `generate_token()` method in `SessionVault`:

```python
def generate_token(self, entity_type: str) -> str:
    suffix = ''.join(secrets.choice(string.ascii_uppercase) for _ in range(6))
    return f"[{entity_type}-{suffix}]"  # Changes <NAME_XJ92> to [NAME-XJKMNP]
```

---

## 📊 Performance

- **Small files (<1MB):** Instant processing
- **Medium files (1-10MB):** 2-5 seconds
- **Large files (>10MB):** May take 10-30 seconds

The bottleneck is Presidio's NLP analysis (SpaCy).

---

## 🛡️ HIPAA & Privacy Compliance

This tool is designed to help with:
- ✅ HIPAA de-identification (§164.514)
- ✅ GDPR data minimization (Article 5)
- ✅ CCPA data protection requirements

**Important:** This tool provides automated PII/PHI detection, but should be:
1. Reviewed by legal/compliance teams
2. Tested thoroughly with your specific data types
3. Used as part of a broader privacy program

No automated tool is 100% accurate. Manual review is recommended for critical data.

---

## 📞 Support

For issues or questions:
1. Check the Activity Log in the app
2. Review the Troubleshooting section above
3. Verify all dependencies are correctly installed
4. Test with provided sample data first

---

## 🔄 Version History

**v1.0.0** - Initial Release
- Full PII/PHI detection (15+ entity types)
- Session-based tokenization
- Self-destructing vault
- Dark/Light theme support
- Drag & drop interface

---

**Built with:** Python 3.11, Presidio, SpaCy, CustomTkinter
**License:** Enterprise Use (Customize as needed)
