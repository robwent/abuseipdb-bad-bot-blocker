# Integrate the AbuseIPDB with NGINX Ultimate Bad Bot Blocker

With a free account at AbuseIPDB, you can perform 10 requests per day and get 10k results back max.  
With a paid account, a confidence level of 90% returns around 60k IP addresses.

Copy the contents of abuseipdb.sh to /usr/local/sbin/update-abuseipdb.sh  
`nano /usr/local/sbin/update-abuseipdb.sh`  
Modify the contents to add your API key and confidence level

Make the file executable  
`chmod 700 /usr/local/sbin/update-abuseipdb.sh`

Set a cron job as root to update the file at an interval of your choice  
`0 0 * * * /usr/local/sbin/update-abuseipdb.sh > /dev/null 2>&1`

Include the output in /etc/nginx/bots.d/blacklist-ips.conf  
`nano /etc/nginx/bots.d/blacklist-ips.conf`

Add at the end:  
`include /etc/nginx/bots.d/abuseipdb;`