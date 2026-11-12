# COMP3010 CW1 – Intrusion Investigation

**Analyst:** Colin Bird · **Module:** COMP3010 · **Video briefing:** [link]

## Case summary
The workstation FlashGordon-PC (192.168.1.96) was infected at 13:38:32 UTC when a script on the host PC downloaded a Windows executable (gerv.gun) from matied.com. In six minutes, the host fetched three further payloads and began behaving as a Pushdo/Cutwail spambot where 475 outbound SMTP connection attempts to 155 mail servers masked by 637 decoy web requests to 307 unrelated sites. The entry point is assessed as a malspam JavaScript attachment opened by the user. Immediate isolation and reimaging of the host are recommended followed by egress filtering and script-execution controls.

## Tools and environment
Wireshark/TShark 4.6.9, Snort & Suricata alert output (supplied),
Gemma 4 12B (`gemma4:12b`) via Ollama 0.40.15, run locally on a MacBook Air (16 GB), macOS 27.2.
Full version output: `evidence/environment.txt`.

## How to reproduce
See `commands.md` – every command in the order it was run, plus a table of the GUI and web-research steps behind each screenshot.
The pcap is not included (course material); SHA-256 of the pcap:
`aa8bd9280b943db2e729b921de58d5fd37c4f8c76d1aa9996e9e5b44bcf7a7a3`.
The full Snort/Suricata alert files and the exported malware binaries are also kept outside the repo; the relevant alert lines are in `evidence/ids/key-alerts.txt` and the file hashes in `evidence/hashes.txt`.

## Evidence index
| ID | File | Shows |
|---|---|---|
| E01 | evidence/screenshots/E01 - Conversations view.png | IPv4 conversations – 192.168.1.96 talking to hundreds of external hosts |
| E02 | evidence/screenshots/E02 - DHCP Packet.png | DHCP frame 213: IP 192.168.1.96, MAC 00:15:c5:de:c7:3b, hostname FlashGordon-PC |
| E03 | evidence/screenshots/E03 - nbns file.png | NBNS traffic confirming the host name |
| E04 | evidence/screenshots/E04 - HTTP stream frame 6.png | First malicious request: GET /gerv.gun from matied.com, WinHttp User-Agent, octet-stream response |
| E05 | evidence/screenshots/E05 - Frame 6 UTC time.png | Frame 6 at 2017-06-27 13:38:32 UTC (time of infection) |
| E06 | evidence/screenshots/E06 - Export objects list.png | HTTP objects including gerv.gun, trow.exe, wp.exe and t64.bin |
| E07 | evidence/screenshots/E07 - VirusTotal gerv.gun.png | gerv.gun SHA-256 on VirusTotal (55/70 malicious) |
| E08 | evidence/screenshots/E08 - VirusTotal trow.exe.png | trow.exe SHA-256 on VirusTotal (listed as Pedals.exe) |
| E09 | evidence/screenshots/E09 - VirusTotal wp.exe.png | wp.exe SHA-256 on VirusTotal |
| E10 | evidence/screenshots/E10 - IO graph of 107.180.41.94.png | I/O graph for the most-alerted Pushdo IP – no regular beaconing interval |

Supporting text evidence: `evidence/timeline.md` (incident timeline), `evidence/tshark/` (tshark exports), `evidence/ids/` (IDS summaries and key alerts), `evidence/file-types.txt` and `evidence/hashes.txt` (exported HTTP objects).

## AI use
Method and full log: `ai/ai-log.md` (Gemma 4 12B, local, open source – every prompt, output and my verification). Declared as P1 Partnered Work.
Claude (Anthropic, free plan) was also used for planning the workflow, organising evidence, checking Gemma's output and Q7 research. Exactly what it did, and what it did not do, is declared in `ai/claude-use.md`, the Generative AI Declaration and the AI reflection.
