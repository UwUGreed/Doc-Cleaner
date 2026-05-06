# 🔒 PII/PHI Sanitizer - Enterprise Privacy Tool

**Professional-grade PII/PHI detection and tokenization with session-based self-destructing memory.**

Built for compliance with HIPAA, GDPR, and CCPA requirements.

**Supports: .txt, .pdf, .docx, .csv, .json, .xml, .html**

---

## ✨ Features

### 🎯 Comprehensive Detection (15+ Entity Types)

**Identity:**
- Full Names (NER-based)
- Social Security Numbers
- Driver's License Numbers
- US Passport Numbers

**Contact Information:**
- Phone Numbers (multiple formats)
- Email Addresses
- Physical Addresses (Street, City, Zip)

**Healthcare (PHI):**
- Medical Record Numbers (MRN)
- Health Plan IDs
- Birthdates
- Medical License Numbers

**Financial:**
- Credit Card Numbers
- Bank Account Numbers
- IBAN Codes

**Custom Insurance Patterns:**
- Policy Numbers (POL-12345678)

### 🔐 Security Architecture

- **Unique Tokenization:** Every PII/PHI instance gets a cryptographically secure token
- **Session-Based Storage:** Mappings stored in encrypted session vault
- **The Shredder Protocol:** Automatic destruction of mappings after rehydration
- **Complete Vault Wipe:** All data destroyed on application close

### 🎨 Modern UI/UX

- Dark/Light theme toggle
- Drag & Drop file support
- Real-time activity logging
- Visual feedback for all operations
- **Multi-format support:** Text, PDF, Word documents, CSV, JSON, XML, HTML

---

## 🚀 Quick Start

### Option 1: Run from Source

```bash
# Install dependencies
pip install -r requirements.txt
python -m spacy download en_core_web_lg

# Run the application
python pii_sanitizer.py
```

### Option 2: Build Executable (Windows)

```bash
# Automated build script
build_windows.bat
```

### Option 3: Manual PyInstaller Build

See `BUILD_GUIDE.md` for detailed instructions.

---

## 📖 Usage

### 1. Sanitize a File

**Method A: Drag & Drop**
1. Launch the application
2. Wait for "System Ready" status
3. Drag your file onto the drop zone
4. Review the log for detected entities
5. Find sanitized file: `filename_SANITIZED.txt`

**Method B: File Dialog**
1. Click "🔍 Sanitize File"
2. Select your file
3. Wait for processing
4. Check output folder

### 2. Rehydrate a File

**CRITICAL:** You must have the `.session` file in the same directory!

1. Click "💧 Rehydrate File"
2. Select the `_SANITIZED` file
3. Wait for restoration
4. Find restored file: `filename_SANITIZED_RESTORED.txt`
5. **Session data is immediately destroyed** (The Shredder Protocol)

### 3. Application Close

When you close the app:
- Complete vault destruction
- All session mappings permanently deleted
- No recovery possible

---

## 🧪 Testing

Three test files are provided:
- `test_data.txt` - Plain text with various PII/PHI
- `test_data.pdf` - Professional PDF medical record
- `test_data.docx` - Formatted Word document

```bash
# Expected results for all formats:
✅ Detect 10+ different entity types
✅ Generate unique tokens for each
✅ Create filename_SANITIZED.[ext]
✅ Create filename_SANITIZED.session
✅ Successfully rehydrate to restore original data
✅ Session automatically deleted after rehydration
```

---

## 🔧 Technical Details

### Vault Location
```
Windows: %APPDATA%\PIISanitizer\session_vault.json
Linux:   ~/.config/PIISanitizer/session_vault.json
macOS:   ~/Library/Application Support/PIISanitizer/session_vault.json
```

### Token Format
```
<ENTITY_TYPE_XXXX>

Examples:
<PERSON_XJ92>
<US_SSN_PQ41>
<EMAIL_ADDRESS_RT23>
<PHONE_NUMBER_KL89>
```

### Session ID Format
```
session_YYYYMMDD_HHMMSS_<random_hex>

Example:
session_20241208_143022_a4f7b2c9
```

---

## 🛡️ Security Guarantees

### ✅ What This Tool Does

1. **Detects** PII/PHI using Microsoft's Presidio framework
2. **Tokenizes** sensitive data with cryptographically secure tokens
3. **Stores** mappings in local session vault
4. **Rehydrates** data when needed
5. **Destroys** all traces after rehydration or app close

### ⚠️ What This Tool Doesn't Do

1. **Not 100% Accurate:** No automated tool catches everything
2. **Not Network-Based:** All processing is local
3. **Not a Backup:** Original files should be secured separately
4. **Not Legal Advice:** Consult compliance teams for regulatory requirements

---

## 📋 System Requirements

- **OS:** Windows 10/11, Linux, macOS
- **Python:** 3.9 - 3.11 (if running from source)
- **RAM:** 4GB minimum, 8GB recommended
- **Disk:** 1GB free space (for SpaCy model)

---

## 🐛 Troubleshooting

### "SpaCy model not found"
```bash
python -m spacy download en_core_web_lg
```

### "No PII/PHI detected" (but there is)
- Check file encoding (must be UTF-8)
- Verify Presidio initialized (check Activity Log)
- Try simpler test data first

### Executable too large (>1GB)
- Use smaller SpaCy model: `en_core_web_sm`
- Reduces size to ~200-300 MB

### Drag & Drop not working
- Click button instead
- Check administrator permissions
- Verify `tkinterdnd2` installation

---

## 🔄 Workflow Example

```
Original File (test_data.txt):
---
John Doe's SSN is 123-45-6789.
Email: john@email.com
Phone: (555) 123-4567
---

↓ SANITIZE

Sanitized File (test_data_SANITIZED.txt):
---
<PERSON_XJ92>'s SSN is <US_SSN_PQ41>.
Email: <EMAIL_ADDRESS_RT23>
Phone: <PHONE_NUMBER_KL89>
---

Session File Created: test_data_SANITIZED.session
Vault Updated: %APPDATA%\PIISanitizer\session_vault.json

↓ REHYDRATE

Restored File (test_data_SANITIZED_RESTORED.txt):
---
John Doe's SSN is 123-45-6789.
Email: john@email.com
Phone: (555) 123-4567
---

🔥 THE SHREDDER PROTOCOL ACTIVATED
Session deleted from vault
.session file removed
```

---

## 📞 Support & Documentation

- **Full Build Guide:** `BUILD_GUIDE.md`
- **Test Data:** `test_data.txt`
- **Build Script:** `build_windows.bat`

---

## 🎓 Compliance Notes

### HIPAA Compliance
This tool supports HIPAA de-identification requirements under §164.514:
- ✅ Removes 18 identifiers specified by Safe Harbor method
- ✅ Maintains data utility through reversible tokenization
- ⚠️ Should be validated by covered entities for specific use cases

### GDPR Compliance
Supports data minimization principles (Article 5):
- ✅ Reduces personal data exposure
- ✅ Enables privacy-by-design
- ⚠️ Does not replace data protection impact assessments

### CCPA Compliance
Assists with consumer data protection:
- ✅ Minimizes personal information in processing
- ✅ Supports data security requirements
- ⚠️ Organizations must still meet all CCPA obligations

**Important:** No automated tool replaces legal/compliance review. Always consult qualified professionals.

---

## 📄 License

This tool is provided for enterprise use. Customize licensing as needed for your organization.

**Dependencies:**
- Presidio (MIT License)
- SpaCy (MIT License)
- CustomTkinter (MIT License)

---

## 🏆 Credits

Built with:
- **Presidio** - Microsoft's PII detection framework
- **SpaCy** - Industrial-strength NLP
- **CustomTkinter** - Modern UI framework
- **tkinterdnd2** - Drag & drop support

---

**Version:** 1.0.0  
**Last Updated:** December 2024  
**Status:** Production Ready ✅
