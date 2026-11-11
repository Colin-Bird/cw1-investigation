# Use of Claude (frontier model) in this investigation

**Tool:** Claude Chat · model Claude Sonnet 5 (Anthropic) · **free plan**
**Period:** 2026-11-11
**Why it is logged separately:** the CW1 rubric rewards open-source-only AI for evidence curation and report writing. Gemma 4 12B (run locally via Ollama) is the AI used for all analysis prompts – see `ai-log.md`. Claude, a free-tier frontier model, was also used for the work listed below. It is declared here, in the README and in the Generative AI Declaration, and discussed in the AI reflection.

## What Claude was used for

| Area | What Claude did | How I checked it |
|---|---|---|
| Planning | Rewrote my phase instructions (Phases 5–8) so each analysis step runs through Gemma via `ask`/`run`; explained the CW1 rubric's AI conditions from the module handbook | Compared against the module handbook |
| Gemma troubleshooting | Diagnosed why the E04 prompt stalled (242 KB input vs Gemma's 4,096-token context) and suggested sending the headers only | Re-ran with `frame6-headers.csv` (ai-log 13:31) |
| Screenshots | Gave Wireshark steps for E04 and E05 | Took the screenshots myself |
| Timeline | Proposed the first timeline rows from my tshark CSVs; later filled the remaining fields (DHCP frames, first IDS alert, SMTP, Pushdo and C2 rows, Pedals.exe note) | 
| IDS analysis | Counted Pushdo alert destinations (202 Snort / 292 Suricata unique IPs), found the first alerts, and noted the Suricata timestamps come from a later replay | Re-ran the commands logged in `commands.md` |
| Checking Gemma | Checked Gemma's Phase 6 C2 candidates (roewer.de, webways.com); drafted My check / Verdict text for ai-log entries; wrote the checks for the 15:47 (ATT&CK) and 15:50 (recommendations) entries directly |
| Housekeeping | Restored the 15:31 ai-log entry lost in an editor save (from commit fd5549f); rebuilt `evidence/ids/combined.txt`; created `evidence/ids/key-alerts.txt`, `dhcp-frames.csv`, `smtp-syn.csv`, `smtp-responses.csv`; added the GUI-steps table to `commands.md` and the README evidence index; commands it ran are marked in `commands.md` | Reviewed the diffs before committing |

## What Claude was not used for
- Analysis prompts – every analysis prompt in `ai-log.md` was run on Gemma.
- Detection rules – Claude drafted two Snort rules in chat; I did not use them; the rules in `evidence/rules/` are to be drafted with Gemma.
- Writing the report (`drafts/report-v1.md` is my own work), the AI reflection, the video script

## Errors and limits noticed
- Claude initially assumed a .js download would be in the pcap (following my template); the evidence showed no .js file in the capture.
- Claude's first timeline version said "no mail commands captured" for the SMTP traffic; the SMTP response codes (ten 500 replies) later showed that was wrong, and the row was corrected.
- Claude could not open VirusTotal's premium relations or the exercise's password-protected answer file, so it could not supply the Q7 hashes.
- Claude's own ATT&CK and citation corrections still had to be checked against the source documents, the same as Gemma's output.
