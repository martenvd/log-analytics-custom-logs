#!/usr/bin/env bash
export LANG=C.UTF-8

wks_id='******************************'
wks_shared_key='*****************************'
log_type='WebMonitorTest'

file=$(cat $1)

rfc1123date=$(TZ=GMT date '+%a, %d %b %Y %T %Z')
x_headers="x-ms-date:$rfc1123date"
content_length=${#file}
full_string="POST\n$content_length\napplication/json\n$x_headers\n/api/logs"
decoded_key=$(echo $wks_shared_key | base64 --decode | xxd -p -u -c 1000)
encoded_hash=$(echo -en $full_string | openssl sha256 -mac HMAC -macopt hexkey:$decoded_key -binary | base64)

authorization="SharedKey $wks_id:$encoded_hash"

uri="https://$wks_id.ods.opinsights.azure.com/api/logs?api-version=2016-04-01"

header1="content-type: application/json"
header2="Authorization: $authorization"
header3="Log-Type: $log_type"
header4="x-ms-date: $rfc1123date"
header5="Content-Length: $content_length"

curl -X POST "$uri" -d "$file" -H "$header1" -H "$header2" -H "$header3" -H "$header4" -H "$header5" --http1.1 
