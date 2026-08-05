#!/bin/bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Sum all input-related tokens for accurate count
used_tokens=$(echo "$input" | jq -r '
  (.context_window.current_usage.input_tokens // 0) +
  (.context_window.current_usage.cache_creation_input_tokens // 0) +
  (.context_window.current_usage.cache_read_input_tokens // 0)
')

printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$(whoami)" "$(hostname -s)" "$cwd"

if [ -n "$model" ] && [ "$model" != "null" ]; then
  printf ' \033[00;33m[%s]\033[00m' "$model"
fi

if [ -n "$used_pct" ] && [ -n "$ctx_size" ] && [ -n "$used_tokens" ] && [ "$used_tokens" != "null" ]; then
  format_tokens() {
    local n=$1
    if [ "$n" -ge 1000000 ]; then
      printf "%.1fM" "$(echo "$n / 1000000" | bc -l)"
    elif [ "$n" -ge 1000 ]; then
      printf "%dK" "$(( n / 1000 ))"
    else
      printf "%d" "$n"
    fi
  }
  used_fmt=$(format_tokens "$used_tokens")
  total_fmt=$(format_tokens "$ctx_size")
  used_pct_int=$(printf "%.0f" "$used_pct")
  printf ' \033[00;36mctx: %s%% (%s/%s)\033[00m' "$used_pct_int" "$used_fmt" "$total_fmt"
fi
