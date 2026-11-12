#!/usr/bin/env bash
root="$(pwd)"
target="${1:-all}"
status=0
mkdir -p "$root/codemd-reports" "$root/.codemd/test-results"
if [ "$target" = "finalize" ]; then
  if [ ! -f "$root/.codemd/test-results/0.exit" ]; then echo "CODEMD_TIMEOUT 0"; echo "CODEMD_RESULT 0 124"; status=1; else code="$(cat "$root/.codemd/test-results/0.exit")"; [ "$code" -eq 0 ] || status=1; fi
  if [ ! -f "$root/.codemd/test-results/1.exit" ]; then echo "CODEMD_TIMEOUT 1"; echo "CODEMD_RESULT 1 124"; status=1; else code="$(cat "$root/.codemd/test-results/1.exit")"; [ "$code" -eq 0 ] || status=1; fi
  exit "$status"
fi
if [ "$target" = "all" ] || [ "$target" = "0" ]; then
( cd . && eval 'cargo test --test fallback_global_flags_test' ); code=$?
echo "$code" > "$root/.codemd/test-results/0.exit"
echo "CODEMD_RESULT 0 $code"; [ "$code" -eq 0 ] || status=1
fi
if [ "$target" = "all" ] || [ "$target" = "1" ]; then
( cd . && eval 'cargo test --test fallback_integrity_test' ); code=$?
echo "$code" > "$root/.codemd/test-results/1.exit"
echo "CODEMD_RESULT 1 $code"; [ "$code" -eq 0 ] || status=1
fi
exit "$status"
