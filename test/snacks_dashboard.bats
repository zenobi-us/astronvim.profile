#!/usr/bin/env bats

@test "snacks dashboard uses static header fallback when DOTFILE_ROOT is unset" {
  run env -u DOTFILE_ROOT nvim --headless \
    '+Lazy! load snacks.nvim' \
    '+lua local s=require("snacks"); local cfg=s.config.get("dashboard"); local found_terminal=false; local found_header=nil; for _,item in ipairs(cfg.sections or {}) do if item.section=="terminal" then found_terminal=true end; if item.header then found_header=item.header end end; print("terminal=" .. tostring(found_terminal)); print("header_len=" .. tostring(found_header and #found_header or 0))' \
    +qa

  [ "$status" -eq 0 ]
  [[ "$output" == *"terminal=false"* ]]
  [[ "$output" != *"header_len=0"* ]]
}
