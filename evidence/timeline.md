# Incident timeline
All times UTC. Capture date: 2017-06-27. Source: COMP3010CW1.pcap (SHA-256 in environment.txt)
Infected host: 192.168.1.96 · FlashGordon-PC · MAC 00:15:c5:de:c7:3b

| Time (UTC) | Frame | Source → Destination | Event | Evidence | Type |
|---|---|---|---|---|---|
| 13:38:32 | 1 | 192.168.1.96 → 192.168.1.1 | DNS lookup for matied.com | infected-activity.csv | Observed |
| 13:38:32 | 6 | 192.168.1.96 → 119.28.70.207 (matied.com) | GET /gerv.gun | infected-activity.csv, E04 | Observed |
| 13:38:36 | 204 | 119.28.70.207 → 192.168.1.96 | Response to frame 6: application/octet-stream (first payload received) | infected-responses.csv | Observed |
| 13:40:52 | [from E02] | 192.168.1.96 → DHCP server | Host identifies itself (MAC 00:15:c5:de:c7:3b, hostname FlashGordon-PC) | E02, dhcp.txt | Observed |
| 13:43:50 | 298, 304 | 192.168.1.96 → 119.28.70.207 (centler.at) | GET /auth/ajax/847598782/?min=data and /auth/min/828949448/ (same IP as matied.com) | infected-activity.csv, E05 | Observed |
| 13:43:52 | 313 | 192.168.1.96 → 145.131.10.21 (lounge-haarstudio.nl) | Executable downloaded as trow.exe (octet-stream, response frame 656) | both CSVs, E06 | Observed |
| 13:43:54 | 667 | 192.168.1.96 → 143.95.151.192 (vantagepointtechnologies.com) | Executable downloaded as wp.exe (application/x-msdownload, response frame 855) | both CSVs | Observed |
| 13:43:58 | 866 | 192.168.1.96 → 59.106.164.230 (rts21.co.jp) | Payload downloaded as t64.bin (octet-stream, response frame 5381) | both CSVs | Observed |
| 13:43:52–13:44:01 | – | – | Downloaded executables likely ran, leading to the activity below | – | Interpreted |
| 13:44:01 | 1448 | 192.168.1.96 → 208.67.222.222 | myip.opendns.com lookup (public-IP check) | infected-activity.csv | Observed |
| 13:44:01–13:44:42 | 1423–17239 | 192.168.1.96 → 307 hosts | 637 GET / requests to unrelated sites in 41 s | infected-activity.csv | Observed |
| [hh:mm:ss] | [n] | – | First IDS alert: [signature] (most frequent: MALWARE-CNC Win.Trojan.Pushdo, 498 alerts) | ids/ | Observed |
| – | – | – | Pushdo/Cutwail spambot, based on the Pushdo C2 and SMTP alerts | ids/combined.txt | Judgement |

**Type key:** Observed = visible in packets · Interpreted = inferred from observed events · Judgement = analyst opinion

## Defining "time of infection"
Candidate events:
- First malicious download: 13:38:32, frame 6 (GET /gerv.gun; payload received at frame 204)
- First executable download: 13:43:52, frame 313 (trow.exe)
- First IDS alert: [hh:mm:ss] (timezone checked against pcap: yes/no)
- First C2 traffic: 13:44:01, frame 1423 (start of the GET / burst)

**Chosen:** 13:38:32 (frame 6), because it is the earliest point the host requested and received malicious content.

**Uncertainty:** The pcap shows network traffic only. Execution on the host is inferred from follow-on traffic, not observed directly. No JavaScript file appears in the HTTP traffic, so how gerv.gun was triggered is not visible.

**AI check:** Gemma gave 13:40 (ai-log entry [#]). That differs from the chosen time because 13:40:52 is the host's DHCP/WPAD traffic (frames 212–215). That traffic only shows the host on the network, and the matied.com request had already happened two minutes earlier.