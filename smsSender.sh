#!/usr/bin/env bash

# ================================================
#        ADB SMS SENDER – FRESH FORENSICS
# ================================================

cd "$(dirname "$0")" || { echo "Failed to change directory"; exit 1; }

# --- Colors ---
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

CONFIG_FILE="./.adb_sms_sender.conf"

# --- Load Saved Coordinates ---
load_coordinates() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
}

# --- Save Coordinates ---
save_coordinates() {
    echo "SEND_X=$SEND_X" > "$CONFIG_FILE"
    echo "SEND_Y=$SEND_Y" >> "$CONFIG_FILE"
}

# --- Banner ---
banner() {
    clear
    echo -e "${CYAN}${BOLD}=============================================="
    echo -e "              ADB SMS SENDER TOOL"
    echo -e "==============================================${RESET}"
}

# --- Menu ---
menu() {
    echo -e "${YELLOW}Choose an option:${RESET}"
    echo -e "${GREEN}  1)${RESET} Detect Send Button Coordinates (Auto)"
    echo -e "${GREEN}  2)${RESET} Enter Send Button Coordinates (Manual)"
    echo -e "${GREEN}  3)${RESET} Send SMS Message"
    echo -e "${GREEN}  0)${RESET} Exit"
    echo
}
