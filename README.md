# 🚨 Automated XSS Detection & Reporting Tool

A full-featured automation tool for finding Reflected XSS vulnerabilities using archived URLs, payload injection, headless browser screenshots, and professional PDF report generation.

---

## 📦 Features

- ✅ Collects URLs from Wayback Machine & gau
- ✅ Filters URLs with parameters
- ✅ Injects custom XSS payloads
- ✅ Detects reflected payloads in response
- ✅ Takes headless browser screenshots (Gowitness)
- ✅ Auto-generates PDF report with vulnerable points + screenshots
- ✅ Fully automated with minimal setup

---

## 🔧 Installation

### 1. Clone the repository

```bash
git clone https://github.com/MianHammad0/xss-tool.git
```

```bash
cd xss-tool
```

```bash
chmod +x install.sh
```
```bash
./script.sh
```

## 🚀 Usage

## 1. Add Target
```bash
echo "example.com" > target.txt
```
## 2. Add/Customize Payloads (Optional)
Edit payloads.txt and insert your favorite XSS payloads.

## 3. Run the Main Script
```bash
chmod +x script.sh
./script.sh
```
#### 📂 Output

File / Folder	Description
output/valid-xss.txt	List of reflected XSS URLs
output/screenshots/	Headless browser screenshots
output/xss-summary.json	JSON summary of findings
output/XSS_Report.pdf	Clean PDF report


## 👑 Author

## Mian Hammad

Bug Hunter | Web Pentester | Automation Artist


## 🛡️ Disclaimer
This tool is for educational and authorized testing only.
Always have permission before testing any system.
