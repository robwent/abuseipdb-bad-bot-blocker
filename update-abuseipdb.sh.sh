#!/bin/bash

# Save this file as /usr/local/sbin/update-abuseipdb.sh
# Edit api key and confidence level
# Make it Executable chmod 700 /usr/local/sbin/update-abuseipdb.sh
# Daily Cron as root (every 4 hours)
# 0 */4 * * * /usr/local/sbin/update-abuseipdb.sh > /dev/null 2>&1
# Include the output in /etc/nginx/bots.d/blacklist-ips.conf
# include /etc/nginx/bots.d/abuseipdb;

ABUSEIPDB_KEY="your-key"
ABUSEIPDB_FILE_PATH=/etc/nginx/bots.d/abuseipdb
ABUSEIPDB_CONFIDENCE=90
ABUSEIPDB_LIMIT=9999999

echo "#AbuseIPDB - Confidence: $ABUSEIPDB_CONFIDENCE" > $ABUSEIPDB_FILE_PATH;
echo "" >> $ABUSEIPDB_FILE_PATH;
response=`curl -s -L "https://api.abuseipdb.com/api/v2/blacklist?confidenceMinimum=$ABUSEIPDB_CONFIDENCE&limit=$ABUSEIPDB_LIMIT" \
  -H "Key: $ABUSEIPDB_KEY" \
  -H "Accept: text/plain"`

# If the response is empty, exit the script
if [ -z "$response" ]; then
    echo "No response from the API. Exiting..."
    exit 1
fi

for i in $response; do
    echo "$i 1;" >> $ABUSEIPDB_FILE_PATH;
done

echo "" >> $ABUSEIPDB_FILE_PATH;

#test configuration and reload nginx
nginx -t && systemctl reload nginx
