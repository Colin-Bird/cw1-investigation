# Detection rules

`local.rules` – version 1, drafted by Gemma 4 12B (ai-log 2026-11-11 16:58), unmodified.

`local-v2.rules` – corrected version 

## sid 1000001 – request for gerv.gun
- Detects: the initial GET /gerv.gun to matied.com (frame 6).

- v1 errors fixed: `$any` is not a valid variable; `http_host` is not a Snort 2.9 modifier.

- Test: tshark filter `http.host == "matied.com" && http.request.uri == "/gerv.gun"` – 1 match (frame 6, 13:38:32), 2 s before the first supplied Snort alert.

- Limitation: indicator-based – misses the attack if the domain or filename changes.

## sid 1000002 – many outbound SMTP connection attempts
- Detects: a workstation opening 20+ port-25 connections in 60 s.
- v1 errors fixed: `$any`; hard-coded IP; no threshold (it would alert on every packet).
- Test: `smtp-syn.csv` – 475 attempts; the 20th is frame 5621 at 13:44:11.968, before the first Pushdo alert.
- Limitation: threshold not tuned on normal traffic; mail servers must be excluded.

## Validation
Tested with equivalent tshark filters only – not loaded in Snort/Suricata [or: tested in Suricata X.Y, see test-output/].