# Commands run (recovered from shell history on 2026-11-11)
```zsh
ollama run gemma4:12b "In two sentences, what does tshark do?"
mkdir -p evidence/{tshark,ids,rules,screenshots} ai drafts\
touch evidence/{tshark,ids,rules,screenshots}/.gitkeep commands.md evidence/timeline.md evidence/hashes.txt ai/ai-log.md
alias tshark=/Applications/Wireshark.app/Contents/MacOS/tshark\
{ ollama --version; tshark --version | head -1; sw_vers; shasum -a 256 $PCAP; } > $REPO/evidence/environment.txt
tshark -r $PCAP -qz io,phs   > $REPO/evidence/tshark/protocol-hierarchy.txt
tshark -r $PCAP -qz io,phs   > $REPO/evidence/tshark/protocol-hierarchy.txt\
tshark -r $PCAP -qz conv,ip  > $REPO/evidence/tshark/conversations.txt\
tshark -r $PCAP -qz endpoints,ip > $REPO/evidence/tshark/endpoints.txt\
ask $REPO/evidence/tshark/conversations.txt "You are a SOC analyst. Which internal hosts and external IPs stand out in these conversations, and why? Only use what is in the data."
```

```zsh
# 2026-11-11 09:20

```

```zsh
# 2026-11-11 09:20

```

```zsh
# 2026-11-11 09:22

```

```zsh
# 2026-11-11 09:24
tshark -r $PCAP -Y "ip.addr==$INFECTED_IP && (http.request || dns.flags.response==0 || tls.handshake.type==1)" -T fields -E header=y -E separator=, -E quote=d -e frame.number -e frame.time_utc -e ip.dst -e dns.qry.name -e http.host -e http.request.uri -e tls.handshake.extensions_server_name > $REPO/evidence/tshark/infected-activity.csv
```

```zsh
# 2026-11-11 09:24
tshark -r $PCAP -Y "http.response && ip.dst==$INFECTED_IP" -T fields -E header=y -E separator=, -E quote=d -e frame.number -e frame.time_utc -e ip.src -e http.content_type -e http.response_for.uri > $REPO/evidence/tshark/infected-responses.csv
```

```zsh
# 2026-11-11 09:24
tshark -r $PCAP -Y "http.response && ip.dst==$INFECTED_IP" -T fields -E header=y -E separator=, -E quote=d -e frame.number -e frame.time_utc -e ip.src -e http.content_type -e http.request_in > $REPO/evidence/tshark/infected-responses.csv
```

```zsh
# 2026-11-11 13:18
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -q -z follow,http,ascii,0 > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/stream-frame6.txt
```

```zsh
# 2026-11-11 13:31
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -Y 'frame.number==6 || frame.number==204' -T fields -E header=y -E separator=, -e frame.number -e frame.time_utc -e ip.src -e ip.dst -e http.request.method -e http.host -e http.request.uri -e http.user_agent -e http.response.code -e http.content_type -e http.content_length_header > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/frame6-headers.csv
```

```zsh
# 2026-11-11 13:36
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -Y 'frame.number==6' -T fields -e frame.number -e frame.time_utc -e frame.time_epoch > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/frame6-time.txt
```

```zsh
# 2026-11-11 13:47
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap --export-objects http,/Users/colinbird/cw1/objects > /dev/null
```

```zsh
# 2026-11-11 13:47
file ~/cw1/objects/* > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/file-types.txt
```

```zsh
# 2026-11-11 13:47
shasum -a 256 ~/cw1/objects/* > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/hashes.txt
```

```zsh
# 2026-11-11 15:18
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -qz 'conv,tcp,ip.addr==192.168.1.96' > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/infected-tcp-conv.txt
```

```zsh
# 2026-11-11 15:31
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -2 -Y 'ip.addr==107.180.41.94 && tcp.flags.syn==1 && tcp.flags.ack==0' -T fields -E header=y -e frame.number -e frame.time_utc -e frame.time_delta_displayed > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/c2-connections.csv
```

```zsh
# 2026-11-11 16:23
awk '/^Count:/{getline; print}' ~/cw1/CW1Suricata.txt | sort | uniq -c | sort -rn > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/ids/CW1Suricata-signatures.txt
```

```zsh
# 2026-11-11 16:25
{ echo '=== SNORT ==='; cat $REPO/evidence/ids/CW1Snort-signatures.txt; echo '=== SURICATA ==='; cat $REPO/evidence/ids/CW1Suricata-signatures.txt; } > $REPO/evidence/ids/combined.txt
```

```zsh
# 2026-11-11 16:25
{ echo '# Key IDS alert lines (source: CW1Snort.txt / CW1Suricata.txt, kept outside repo as course material)'; echo; echo '## First Snort alerts (13:38 gerv.gun download)'; awk '/^\[\*\*\]/{sig=$0} /^[0-9][0-9]\/[0-9][0-9]-/{print $1" | "$2" "$3" "$4" | "sig}' ~/cw1/CW1Snort.txt | sort | head -4; echo; echo '## First Snort Pushdo alerts'; awk '/Pushdo/{s=$0; f=1; next} f && /->/{print $1" | "$2" "$3" "$4" | "s; f=0}' ~/cw1/CW1Snort.txt | sort | head -3; echo; echo '## Snort Pushdo destination IPs (top 10 of' $(awk '/Pushdo/{f=1;next} f && /->/{split($4,a,":"); print a[1]; f=0}' ~/cw1/CW1Snort.txt | sort -u | wc -l | tr -d ' ') 'unique)'; awk '/Pushdo/{f=1;next} f && /->/{split($4,a,":"); print a[1]; f=0}' ~/cw1/CW1Snort.txt | sort | uniq -c | sort -rn | head -10; echo; echo '## Suricata Pushdo destination IPs (top 10 of' $(awk '/Pushdo/{getline; print $3}' ~/cw1/CW1Suricata.txt | sort -u | wc -l | tr -d ' ') 'unique)'; awk '/Pushdo/{getline; print $3}' ~/cw1/CW1Suricata.txt | sort | uniq -c | sort -rn | head -10; echo; echo '## Suricata timestamp range (replayed with tcpreplay, not original capture time)'; grep '^Count:' ~/cw1/CW1Suricata.txt | awk '{print $3, $4}' | sort | sed -n '1p;$p'; } > $REPO/evidence/ids/key-alerts.txt
```

```zsh
# 2026-11-11 16:25
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -Y 'dhcp' -T fields -E header=y -E separator=, -e frame.number -e frame.time_utc -e ip.src -e ip.dst -e eth.src -e dhcp.option.dhcp -e dhcp.option.hostname > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/dhcp-frames.csv
```

```zsh
# 2026-11-11 16:25
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -Y 'ip.src==192.168.1.96 && tcp.dstport==25 && tcp.flags.syn==1 && tcp.flags.ack==0' -T fields -E header=y -E separator=, -e frame.number -e frame.time_utc -e ip.dst > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/smtp-syn.csv
```

```zsh
# 2026-11-11 16:25
tshark -r /Users/colinbird/cw1/COMP3010CW1.pcap -Y 'smtp.response.code' -T fields -E header=y -E separator=, -e frame.number -e frame.time_utc -e ip.src -e smtp.response.code > /Users/colinbird/Documents/GitHub/cw1-investigation/evidence/tshark/smtp-responses.csv
```

## Manual / GUI steps (not shell commands)
Recorded 2026-11-11 so the evidence can be reproduced.

| Evidence | Tool | Steps |
|---|---|---|
| E01 | Wireshark | Statistics → Conversations → IPv4 tab |
| E02 | Wireshark | Filter `dhcp` → frame 213 → expand Option (12) Host Name and Ethernet source |
| E03 | Wireshark | Filter `nbns` |
| E04 | Wireshark | Filter `frame.number == 6` → right-click → Follow → HTTP Stream |
| E05 | Wireshark | View → Time Display Format → UTC Date and Time of Day; filter `frame.number == 6`, expand Frame 6 |
| E06 | Wireshark | File → Export Objects → HTTP (objects saved to ~/cw1/objects, outside the repo) |
| E07–E09 | VirusTotal (browser) | Search each SHA-256 from evidence/hashes.txt (hash search only, no upload): gerv.gun 0931…7272, trow.exe 94a0…1fe1 (listed as Pedals.exe), wp.exe 79d5…ea48 |
| E10 | Wireshark | Statistics → I/O Graph, display filter `ip.addr==107.180.41.94` |
| Q7 (.js hash) | Web research | Source exercise: malware-traffic-analysis.net/2017/06/28/index.html; campaign write-up naming DOC0978043-2017.6.doc.js and 2017-547805549-231.pdf.js: myonlinesecurity.co.uk/japanese-language-invoice-malspam-using-js-files-inside-zips-today/ |
