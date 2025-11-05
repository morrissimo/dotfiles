# #!/usr/bin/env bash

# This file is specifically written for usage with Github Codespaces
# see more details here:
# https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account#dotfiles


set -euo pipefail

trap 'echo "[bootstrap] error line $LINENO" >&2' ERR
export AWS_PAGER=""; export DEBIAN_FRONTEND=noninteractive

phase="${1:-}"; shift || true
log(){ printf '[bootstrap] %s\n' "$*"; }

setup_aws(){
  mkdir -p "${HOME}/.aws"
  cfg="${HOME}/.aws/config"
  [[ -f "$cfg" ]] || : > "$cfg"

  grep -q '^\[default\]' "$cfg" 2>/dev/null || cat >>"$cfg" <<CFG
[default]
region = ${AWS_DEFAULT_REGION:-us-east-1}
output = json
CFG

# ## corp AWS SSO profile setup (disabled for now, kept for reference)

#   # Warn on missing critical envs (non-fatal)
#   [[ -n "${AWS_SSO_START_URL:-}" ]] || log "WARN: AWS_SSO_START_URL is empty"
#   [[ -n "${AWS_ROLE_NAME_DEV:-}" ]] || log "WARN: AWS_ROLE_NAME_DEV is empty"

#   grep -q '^\[sso-session groupsense\]' "$cfg" 2>/dev/null || cat >>"$cfg" <<CFG

# [sso-session groupsense]
# sso_start_url = ${AWS_SSO_START_URL:-}
# sso_region    = ${AWS_SSO_REGION:-us-east-1}
# sso_registration_scopes = sso:account:access
# CFG

#   grep -q '^\[profile gs-tl\]' "$cfg" 2>/dev/null || cat >>"$cfg" <<CFG

# [profile gs-tl]
# sso_session    = groupsense
# sso_account_id = ${AWS_ACCOUNT_ID_TL:-}
# sso_role_name  = ${AWS_ROLE_NAME_DEV:-}
# region         = ${AWS_DEFAULT_REGION:-us-east-1}
# output = json
# CFG

#   grep -q '^\[profile gs-br\]' "$cfg" 2>/dev/null || cat >>"$cfg" <<CFG

# [profile gs-br]
# sso_session    = groupsense
# sso_account_id = ${AWS_ACCOUNT_ID_BR:-}
# sso_role_name  = ${AWS_ROLE_NAME_DEV:-}
# region         = ${AWS_DEFAULT_REGION:-us-east-1}
# output = json
# CFG

#   grep -q '^\[profile example\]' "$cfg" 2>/dev/null || cat >>"$cfg" <<CFG

# [profile example]
# sso_session    = groupsense
# sso_account_id = ${AWS_ACCOUNT_ID_DEV:-}
# sso_role_name  = ${AWS_ROLE_NAME_DEV:-}
# region         = ${AWS_DEFAULT_REGION:-us-east-1}
# output = json
# CFG

  chmod 700 "${HOME}/.aws" || true
  chmod 600 "$cfg" || true
}

# setup_aws_helpers(){
#   # Add a device-code alias; idempotent
#   local rc
#   if [[ -n "${ZSH_VERSION:-}" ]]; then rc="$HOME/.zshrc"; else rc="$HOME/.bashrc"; fi
#   local line="alias aws-sso-login='aws sso login --use-device-code --no-browser'"
#   grep -Fqx "$line" "$rc" 2>/dev/null || echo "$line" >> "$rc"
# }

# check_aws_sso(){
#   command -v aws >/dev/null 2>&1 || { log "aws missing"; return 0; }
#   timeout 5s AWS_PROFILE=example aws sts get-caller-identity >/dev/null 2>&1 \
#     && log "AWS SSO active for profile 'example'" \
#     || log "Not logged in. Run: aws sso login --sso-session groupsense --use-device-code"
# }

setup_aliases(){
  local rc
  if [[ -n "${ZSH_VERSION:-}" ]]; then rc="$HOME/.zshrc"; else rc="$HOME/.bashrc"; fi

  local line="alias ll='ls -alFh'"
  grep -Fqx "$line" "$rc" 2>/dev/null || echo "$line" >> "$rc"
}

on_create(){
  log "[bootstrap] create phase"
  setup_aws
#   setup_aws_helpers
}

on_start(){
  log "[bootstrap] start phase"
  setup_aws
#   setup_aws_helpers
#   check_aws_sso
  setup_aliases
}

case "${phase}" in
  --phase=create) on_create ;;
  --phase=start)  on_start ;;
  *) echo "usage: $0 --phase=create|--phase=start"; exit 2 ;;
esac
