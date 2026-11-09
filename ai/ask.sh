# ask.sh – sends a prompt plus a data file to Gemma and logs everything to ai/ai-log.md

ask() {
  local file="$1"; shift
  local prompt="$*"
  local log="$REPO/ai/ai-log.md"
  printf '\n---\n### %s · gemma4:12b\n**Prompt:** %s\n**Input:** `%s`\n\n**Output:**\n\n' \
    "$(date '+%Y-%m-%d %H:%M')" "$prompt" "$file" >> "$log"
  ollama run gemma4:12b "$prompt

DATA:
$(cat "$file")" | tee -a "$log"
  printf '\n\n**My check:** \n**Verdict:** (correct / partly / wrong / hallucinated)\n**Used in report:** \n' >> "$log"
}