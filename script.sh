#!/bin/bash

TARGET_FILE="target.txt"
PAYLOADS_FILE="payloads.txt"
OUTPUT_DIR="output"
SCREENSHOT_DIR="$OUTPUT_DIR/screenshots"
TMP_URLS="tmp_all_urls.txt"
SUMMARY_FILE="$OUTPUT_DIR/xss-summary.json"

mkdir -p $OUTPUT_DIR $SCREENSHOT_DIR
rm -f $TMP_URLS $SUMMARY_FILE $OUTPUT_DIR/valid-xss.txt

echo "[*] Collecting URLs from wayback..."
while read -r TARGET; do
    echo $TARGET | waybackurls >> $TMP_URLS
done < $TARGET_FILE

cat $TMP_URLS | urldedupe | httpx -silent | tee $OUTPUT_DIR/live-urls.txt

echo "[*] Filtering URLs with parameters..."
cat $OUTPUT_DIR/live-urls.txt | grep "?" | tee $OUTPUT_DIR/param-urls.txt

echo "[*] Testing payloads..."
while read -r PAYLOAD; do
    echo "[Payload] $PAYLOAD"
    ENCODED=$(python3 -c "import urllib.parse; print(urllib.parse.quote('''$PAYLOAD'''))")

    cat $OUTPUT_DIR/param-urls.txt | qsreplace "$PAYLOAD" | while read -r url; do
        echo "[-] Testing $url"
        RESP=$(curl -sk "$url")
        if echo "$RESP" | grep -q "$PAYLOAD"; then
            echo "[+] Reflected: $url"
            echo "$url" >> $OUTPUT_DIR/valid-xss.txt
            echo "{\"url\": \"$url\", \"payload\": \"$PAYLOAD\"}," >> $SUMMARY_FILE.tmp
            echo "$url" >> $SCREENSHOT_DIR/list.txt
        fi
    done
done < $PAYLOADS_FILE

echo "[" > $SUMMARY_FILE
cat $SUMMARY_FILE.tmp | sed '$s/,$//' >> $SUMMARY_FILE
echo "]" >> $SUMMARY_FILE
rm -f $SUMMARY_FILE.tmp

if [ -f "$SCREENSHOT_DIR/list.txt" ]; then
    echo "[*] Taking screenshots..."
    gowitness file -f $SCREENSHOT_DIR/list.txt --destination $SCREENSHOT_DIR --no-http
fi

echo "[*] Generating PDF report..."
python3 generate_report.py

echo "[✓] Done! Report: $OUTPUT_DIR/XSS_Report.pdf"
