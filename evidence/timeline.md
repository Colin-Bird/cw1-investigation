# Incident timeline
All times UTC. Capture date: 2017-06-27. Source: COMP3010CW1.pcap (SHA-256 in environment.txt)
Infected host: 192.168.1.96 · FlashGordon-PC · MAC 00:15:c5:de:c7:3b

| Time (UTC) | Frame | Source → Destination | Event | Evidence | Type |
|---|---|---|---|---|---|
| before 13:38:32 | – | – | User likely opened a malspam .js downloader (DOC0978043-2017.6.doc.js or 2017-547805549-231.pdf.js); not present in the pcap | Q7 hashes [59727ea201d94d471bdbb353b1281cca3c5bebf5305b140a3c017e52a37be702 / 64ae13592c5d8b289be81ebb50e054cef49b0bdf50ea92dd44ed611dd274150f], MyOnlineSecurity write-up | Interpreted (external source) |
| 13:38:32 | 1 | 192.168.1.96 → 192.168.1.1 | DNS lookup for matied.com | infected-activity.csv | Observed |
| 13:38:32 | 6 | 192.168.1.96 → 119.28.70.207 (matied.com) | GET /gerv.gun, User-Agent WinHttp.WinHttpRequest.5 (script, not a browser) | infected-activity.csv, frame6-headers.csv, E04, E05 | Observed |
| 13:38:34 | 8 | 119.28.70.207 → 192.168.1.96 | First IDS alert: Snort FILE-EXECUTABLE download of executable content / PE binary magic detected | ids/key-alerts.txt | Observed |
| 13:38:36 | 204 | 119.28.70.207 → 192.168.1.96 | Response to frame 6 complete: application/octet-stream; file is a PE32 executable (VirusTotal 55/70) | infected-responses.csv, file-types.txt, E07 | Observed |
| 13:40:52 | 213–214 | 192.168.1.96 → DHCP server | Host identifies itself (MAC 00:15:c5:de:c7:3b, hostname FlashGordon-PC); repeated at 13:43:49 (frames 221–222) | E02, dhcp.txt, dhcp-frames.csv | Observed |
| 13:43:50 | 298, 304 | 192.168.1.96 → 119.28.70.207 (centler.at) | GET /auth/ajax/847598782/?min=data and /auth/min/828949448/ (same IP as matied.com) | infected-activity.csv | Observed |
| 13:43:52 | 313 | 192.168.1.96 → 145.131.10.21 (lounge-haarstudio.nl) | Executable downloaded as trow.exe (octet-stream, response frame 656); same SHA-256 is listed on VirusTotal as Pedals.exe | both CSVs, hashes.txt, E06, E08 | Observed |
| 13:43:54 | 667 | 192.168.1.96 → 143.95.151.192 (vantagepointtechnologies.com) | Executable downloaded as wp.exe (application/x-msdownload, response frame 855) | both CSVs, E06, E09 | Observed |
| 13:43:58 | 866 | 192.168.1.96 → 59.106.164.230 (rts21.co.jp) | Payload downloaded as t64.bin (octet-stream, response frame 5381); `file` reports "data", so likely encoded/encrypted | both CSVs, file-types.txt, E06 | Observed / Interpreted |
| 13:43:52–13:44:01 | – | – | Downloaded executables likely ran, leading to the activity below | – | Interpreted |
| 13:44:01 | 1448 | 192.168.1.96 → 208.67.222.222 | myip.opendns.com lookup (public-IP check) | infected-activity.csv | Observed |
| 13:44:01–13:44:42 | 1423–17239 | 192.168.1.96 → 307 hosts | 637 GET / requests to unrelated sites in 41 s | infected-activity.csv | Observed |
| 13:44:11 | 5490 | 192.168.1.96 → 155 mail servers :25 | 475 outbound SMTP connection attempts; servers reply 220 (76), 421 (20), 500 (10) and 554 (1); the 500 (command not recognised) replies are consistent with Snort's 41 "(smtp) Attempted command buffer overflow" alerts, suggesting the host sent oversized or malformed SMTP commands | smtp-syn.csv, smtp-responses.csv, ids/combined.txt | Observed / Interpreted |
| 13:44:11 | 5700 | 192.168.1.96 → 104.20.221.29 (uster.com) | First Pushdo alert: Snort MALWARE-CNC Win.Trojan.Pushdo variant outbound connection (498 alerts to 202 IPs) | ids/key-alerts.txt, ids/combined.txt | Observed |
| 13:44:12–13:44:40 | 5840–16783 | 192.168.1.96 → 107.180.41.94 (leapc.com) | 12 connections to the most-alerted Pushdo IP; gaps 0.11–22.7 s, no regular interval | c2-connections.csv, E10 | Observed |
| 13:44:12–13:44:40 | – | – | No single C2 server isolated; Pushdo spreads requests across many legitimate sites, so no beaconing pattern is visible in this short capture | infected-tcp-conv.txt, c2-connections.csv, E10 | Interpreted |
| – | – | – | Pushdo/Cutwail spambot, based on the Pushdo alerts, the PE payloads and the outbound SMTP to 155 mail servers | ids/combined.txt, E07–E09 | Judgement |

**Type key:** Observed = visible in packets · Interpreted = inferred from observed events · Judgement = analyst opinion

## Defining "time of infection"
Candidate events:
- First malicious download: 13:38:32, frame 6 (GET /gerv.gun; payload received at frame 204)
- First executable download: 13:43:52, frame 313 (trow.exe)
- First IDS alert: 13:38:34, frame 8, Snort FILE-EXECUTABLE (timezone checked against pcap: yes – Snort times match the pcap's UTC frame times; Suricata times show 2017-06-28 00:20 because the alerts were generated later with tcpreplay, so they are not used)
- First C2 traffic: 13:44:01, frame 1423 (start of the GET / burst); first Pushdo alert 13:44:11, frame 5700

**Chosen:** 13:38:32 (frame 6), because it is the earliest point the host requested and received malicious content.

**Uncertainty:** The pcap shows network traffic only. Execution on the host is inferred from follow-on traffic, not observed directly. No JavaScript file appears in the capture; the .js downloader is identified from external sources only, and the WinHttp User-Agent in frame 6 is consistent with a script making the request. No single C2 server could be isolated within the 6-minute capture.

**AI check:** Gemma gave 13:40. That differs from the chosen time because 13:40:52 is the host's DHCP/WPAD traffic (frames 212–215). That traffic only shows the host on the network, and the matied.com request had already happened two minutes earlier. When given the frame 6 timestamp (ai-log entry 2026-11-11 13:37), Gemma agreed that 13:38:32 contradicts 13:40. In Phase 6 (ai-log entry 2026-11-11 15:18) Gemma named 104.20.166.37 and 209.85.25.218 as C2 candidates; both are legitimate sites (roewer.de, webways.com) hit during the GET / burst with irregular timing – verdict: partly correct.

