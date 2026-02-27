# 📱 DroidSMS

DroidSMS is a Bash-based SMS automation tool built on top of ADB (Android Debug Bridge).

It demonstrates how to:

- Launch Android activities via intents
- Prefill SMS data
- Inspect UI hierarchy
- Extract clickable element bounds
- Inject tap events programmatically
- Automate SMS sending without root

This project is designed for educational, lab, and forensic environments.

---

## ⚙️ Features

- ✅ Automatic Send button detection (UI XML parsing)
- ✅ Manual coordinate fallback mode
- ✅ Persistent coordinate storage
- ✅ Works on non-rooted devices
- ✅ Compatible with physical devices and emulators
- ✅ Transparent, reproducible automation flow

---

## 🧠 How It Works (High-Level)

DroidSMS does **not** bypass Android security.

Instead, it follows this structured flow:

```

Intent → UI Render → XML Dump → Coordinate Extraction → Tap Injection

````

1. Launch SMS compose window using Android intent
2. Dump the current UI hierarchy
3. Locate the Send button
4. Calculate its center coordinates
5. Inject a tap event
6. Optionally reset app state

This mirrors how UI automation frameworks operate internally.

---

## 📦 Requirements

### Install ADB

```bash
sudo apt update && sudo apt install adb -y
adb --version
````

### Enable USB Debugging

1. Settings → About Phone
2. Tap Build Number 7 times
3. Developer Options → Enable USB Debugging

### Verify Device

```bash
adb devices
```

---

## 🚀 Usage

```bash
chmod +x smsSender.sh
./smsSender.sh
```

Follow the on-screen menu.

---

## 📚 Learn the Architecture

Want to understand how this works at a system level?

* 👉 [Manual ADB SMS Walkthrough](docs/manual-walkthrough.md)
* 👉 [UI XML & Coordinate Analysis](docs/ui-analysis.md)

The script is simply a structured wrapper around the manual workflow.

---

## ⚠️ Important Notes

* Device must be unlocked
* Android does not allow silent SMS sending via ADB
* This tool simulates UI interaction
* Intended for controlled lab environments

---

## License

MIT License — feel free to fork, modify, and adapt for demos or educational content.

---

### ☕ Support This Project

If **DroidSMS** helped you better understand Android or ADB, consider supporting continued development:

<p align="center">
  <a href="https://www.buymeacoffee.com/dfreshZ" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
</p>

<!-- 
 _____              _       _____                        _          
|  ___| __ ___  ___| |__   |  ___|__  _ __ ___ _ __  ___(_) ___ ___ ™️
| |_ | '__/ _ \/ __| '_ \  | |_ / _ \| '__/ _ \ '_ \/ __| |/ __/ __|
|  _|| | |  __/\__ \ | | | |  _| (_) | | |  __/ | | \__ \ | (__\__ \
|_|  |_|  \___||___/_| |_| |_|  \___/|_|  \___|_| |_|___/_|\___|___/
        freshforensicsllc@tuta.com Fresh Forensics, LLC 2026 -->
