import json, os
from weasyprint import HTML

OUTPUT_DIR = "output"
SCREENSHOT_DIR = f"{OUTPUT_DIR}/screenshots"
SUMMARY_FILE = f"{OUTPUT_DIR}/xss-summary.json"
REPORT_HTML = f"{OUTPUT_DIR}/report.html"
REPORT_PDF = f"{OUTPUT_DIR}/XSS_Report.pdf"

with open(SUMMARY_FILE, 'r') as f:
    data = json.load(f)

html = """<html><head><style>
body { font-family: sans-serif; padding: 20px; }
h1 { color: #333; }
.vuln { border: 1px solid #ccc; padding: 15px; margin: 20px 0; border-radius: 10px; }
img { max-width: 800px; border: 1px solid #000; margin-top: 10px; }
</style></head><body>
<h1>Reflected XSS Report</h1>
<p>Total vulnerabilities found: <b>{}</b></p>
""".format(len(data))

for i, item in enumerate(data, 1):
    ss_name = item['url'].replace("https://", "").replace("http://", "").replace("/", "_").replace("?", "_") + ".png"
    img_path = os.path.join(SCREENSHOT_DIR, ss_name)
    html += f"<div class='vuln'><h2>{i}. {item['url']}</h2><p><b>Payload:</b> <code>{item['payload']}</code></p>"
    if os.path.exists(img_path):
        html += f"<img src='{img_path}'>"
    else:
        html += "<p><i>No screenshot available.</i></p>"
    html += "</div>"

html += "</body></html>"

with open(REPORT_HTML, "w") as f:
    f.write(html)

HTML(REPORT_HTML).write_pdf(REPORT_PDF)
print(f"[✓] PDF generated: {REPORT_PDF}")
