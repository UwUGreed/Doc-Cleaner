# File Format Support Guide

## 📄 Supported Formats

The PII/PHI Sanitizer supports the following file formats:

| Format | Extension | Read | Write | Notes |
|--------|-----------|------|-------|-------|
| Plain Text | .txt | ✅ | ✅ | Full support, UTF-8/UTF-16/Latin-1 |
| PDF | .pdf | ✅ | ✅ | Text extraction, multi-page support |
| Word Document | .docx | ✅ | ✅ | Tables, paragraphs, full formatting |
| CSV | .csv | ✅ | ✅ | Treated as text |
| JSON | .json | ✅ | ✅ | Treated as text |
| XML | .xml | ✅ | ✅ | Treated as text |
| HTML | .html | ✅ | ✅ | Treated as text |
| Markdown | .md | ✅ | ✅ | Treated as text |

---

## 📖 Format-Specific Behavior

### Plain Text Files (.txt, .csv, .json, .xml, .html, .md)

**Reading:**
- Automatic encoding detection (UTF-8, UTF-16, Latin-1, CP1252)
- Preserves line breaks and formatting
- Full content passed to Presidio for analysis

**Writing:**
- UTF-8 encoding
- Preserves all tokens and formatting
- Original structure maintained

**Example:**
```
Original:
John Doe's email is john@email.com

Sanitized:
<PERSON_XJ92>'s email is <EMAIL_ADDRESS_RT23>

Restored:
John Doe's email is john@email.com
```

---

### PDF Files (.pdf)

**Reading:**
- Uses PyPDF2 for text extraction
- Extracts text from all pages
- Page markers added: `--- Page 1 ---`
- Tables and structured content extracted as text
- Scanned PDFs (images) not supported - use OCR separately first

**Writing:**
- Uses reportlab to create new PDF
- Maintains page structure where possible
- Professional formatting with paragraph breaks
- **Fallback:** If reportlab unavailable, saves as .txt

**Example Workflow:**
```
1. Drop medical_record.pdf
2. App reads: "Patient John Doe (SSN: 123-45-6789)..."
3. Sanitizes: "Patient <PERSON_XJ92> (SSN: <US_SSN_PQ41>)..."
4. Creates: medical_record_SANITIZED.pdf
5. Rehydrate creates: medical_record_SANITIZED_RESTORED.pdf
```

**Limitations:**
- Images within PDFs are not extracted or sanitized
- Complex layouts may lose formatting
- Scanned documents (image-based PDFs) require OCR preprocessing

---

### Word Documents (.docx)

**Reading:**
- Uses python-docx library
- Extracts all paragraphs
- Extracts table content (rows/cells)
- Preserves text order
- Headers, footers, and images not extracted

**Writing:**
- Creates new .docx with sanitized content
- Preserves paragraph structure
- Basic formatting maintained
- Tables reconstructed as paragraphs
- **Fallback:** If python-docx unavailable, saves as .txt

**Example:**
```
Original DOCX:
┌─────────────────────────────┐
│ Name: Sarah Johnson         │
│ SSN: 123-45-6789           │
│ Phone: (555) 123-4567      │
└─────────────────────────────┘

Sanitized DOCX:
┌─────────────────────────────┐
│ Name: <PERSON_XJ92>        │
│ SSN: <US_SSN_PQ41>         │
│ Phone: <PHONE_NUMBER_KL89> │
└─────────────────────────────┘
```

**Limitations:**
- Complex formatting (colors, fonts, styles) may be lost
- Images and embedded objects not processed
- Charts and diagrams not extracted
- Equations and special content not supported

---

## 🔧 Technical Details

### FileHandler Class

The application uses a `FileHandler` class that automatically:

1. **Detects file type** based on extension
2. **Selects appropriate reader** (PDF, DOCX, or text)
3. **Extracts text content** for Presidio analysis
4. **Writes back** in the same format when possible

### Session Metadata

For each sanitized file, a `.session` file is created with:

```json
{
  "session_id": "session_20241208_143022_a4f7b2c9",
  "original_format": "pdf",
  "original_extension": ".pdf"
}
```

This ensures the file is restored in its original format.

---

## 🚨 Format Fallback Behavior

If the application cannot write to the original format:

1. **PDF:** Falls back to .txt if reportlab unavailable
2. **DOCX:** Falls back to .txt if python-docx unavailable
3. **User notified:** Log shows: `"⚠️ Could not write as PDF, saving as text"`

The `.session` file still tracks the original format for reference.

---

## 📋 Best Practices by Format

### For Text Files
✅ **Best for:** Logs, notes, transcripts, code files
✅ **Advantages:** Fast, lossless, exact format preservation
⚠️ **Watch out for:** Non-UTF-8 encoding (usually auto-detected)

### For PDF Files
✅ **Best for:** Reports, letters, official documents
✅ **Advantages:** Professional appearance, multi-page support
⚠️ **Watch out for:** Scanned documents (need OCR first), images
⚠️ **Note:** Requires reportlab for PDF output (~4MB dependency)

### For Word Documents
✅ **Best for:** Contracts, medical records, business documents
✅ **Advantages:** Structured content, table support
⚠️ **Watch out for:** Complex formatting may be lost, no image support
⚠️ **Note:** Requires python-docx for DOCX output (~2MB dependency)

### For CSV/JSON/XML
✅ **Best for:** Data exports, API responses, configs
✅ **Advantages:** Fast processing, structure preserved
⚠️ **Watch out for:** Nested JSON/XML may have PII in keys (not sanitized)

---

## 🧪 Testing Each Format

### Test Plain Text
```bash
# Drop test_data.txt
# Expected: Instant processing, perfect restoration
```

### Test PDF
```bash
# Drop test_data.pdf
# Expected: Multi-page text extraction, professional PDF output
# Check: All pages sanitized, page markers present
```

### Test DOCX
```bash
# Drop test_data.docx
# Expected: Table and paragraph extraction, formatted output
# Check: Tables converted to text, structure maintained
```

---

## 🔍 Format Detection

The app detects format by file extension:

```python
.pdf  → PDF handler (PyPDF2 + reportlab)
.docx → DOCX handler (python-docx)
.*    → Text handler (UTF-8 with fallbacks)
```

If a file has the wrong extension (e.g., `.txt` but contains PDF data), detection may fail.

---

## ⚠️ Known Limitations

### Cannot Process:
- ❌ Image-based PDFs (scanned documents) - use OCR first
- ❌ Encrypted/password-protected files
- ❌ Binary formats (.doc, .xls, .ppt) - convert to modern formats first
- ❌ Images (.jpg, .png) - no OCR built-in
- ❌ Audio/video files

### Partially Supported:
- ⚠️ Complex DOCX formatting (colors, fonts lost)
- ⚠️ PDF images (extracted text only, images ignored)
- ⚠️ Large files (>50MB may be slow)

---

## 📊 Performance by Format

| Format | 1MB File | 10MB File | Notes |
|--------|----------|-----------|-------|
| .txt | <1s | ~3s | Fastest |
| .pdf | ~2s | ~10s | Depends on page count |
| .docx | ~2s | ~8s | Depends on tables |
| .json | <1s | ~3s | Fast |

*Times based on typical hardware, SpaCy lg model*

---

## 🛠️ Troubleshooting

### "Failed to read PDF"
- **Cause:** Scanned/image-based PDF
- **Solution:** Use OCR software first (Adobe Acrobat, online OCR tools)

### "Could not write as PDF, saving as text"
- **Cause:** reportlab not installed
- **Solution:** `pip install reportlab`

### "Failed to read DOCX"
- **Cause:** Corrupted or password-protected file
- **Solution:** Open in Word, save as new file, try again

### "No PII/PHI detected" (but there is)
- **Cause:** Format issue - text not extracted properly
- **Solution:** Check Activity Log for format detection message
- **Try:** Convert to plain text first, then process

---

## 🔐 Security Notes

### All Formats:
- ✅ Text content fully sanitized
- ✅ Tokens unique per session
- ✅ Mappings stored securely

### Format-Specific:
- **PDF:** Images/attachments NOT sanitized (not extracted)
- **DOCX:** Images NOT sanitized (not extracted)
- **Warning:** If PII exists in images, use image-aware tools first

---

## 📞 Support

For format-specific issues:

1. Check the Activity Log for error messages
2. Verify file is not corrupted (open in native app)
3. Try converting to .txt first as a workaround
4. Check that required libraries are installed

---

**Last Updated:** December 2024  
**Supported Libraries:**
- PyPDF2 3.0.1
- python-docx 1.1.0
- reportlab 4.0.7
