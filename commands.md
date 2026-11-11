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
