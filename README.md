# 📱 ADB SMS Sender – Fresh Forensics

A Bash-based SMS automation tool that uses **ADB (Android Debug Bridge)** to compose and send SMS messages on Android devices.

This tool supports:

* ✅ Automatic detection of the **Send button coordinates**
* ✅ Manual coordinate entry (fallback mode)
* ✅ Persistent configuration
* ✅ Non-rooted devices
* ✅ Physical devices and emulators
* ✅ Simple forensic/lab automation workflows

---

# ⚠️ Important Notes

* This tool does **not** bypass Android SMS security.
* It uses the Android intent system to open the SMS composer.
* It simulates a tap on the Send button using screen coordinates.
* It requires the device to be unlocked.
* Works best in controlled lab/forensic environments.

---

# 📦 Requirements

### 1️⃣ Install ADB

Using APT:

```bash
sudo apt update && sudo apt install adb -y
```

Verify installation:

```bash
adb --version
```

---

### 2️⃣ Enable USB Debugging on Device

On the Android device:

1. Go to **Settings → About Phone**
2. Tap **Build Number** 7 times
3. Go to **Developer Options**
4. Enable **USB Debugging**

---

### 3️⃣ Verify Device Connection

```bash
adb devices
```

You should see:

```
List of devices attached
XXXXXXXX	device
```

---

# 🚀 How It Works

The script performs the following steps:

```
1. Launch SMS compose window via Android Intent
2. Wait for UI to load
3. Tap Send button at stored screen coordinates
4. Save coordinates for reuse
```

It supports **two coordinate modes**:

---

# 🔎 Mode 1 – Auto Detect Send Button (Recommended)

The tool uses:

```bash
adb shell uiautomator dump
```

It:

* Dumps the current UI hierarchy
* Pulls the XML locally
* Searches for the Send button resource-id
* Extracts its screen bounds
* Calculates the center point
* Saves X and Y coordinates

This works when:

* The messaging app exposes a consistent resource-id
* The UI layout is stable

---

# ✍️ Mode 2 – Manual Coordinate Entry

If auto-detection fails (common on some OEM devices), you can:

1. Open SMS compose screen manually
2. Run:

```bash
adb shell getevent -l
```

OR use:

```bash
adb shell input tap X Y
```

3. Experiment to determine correct coordinates
4. Enter them manually in the tool

Coordinates are saved to:

```
.smsSender.conf
```

Example:

```
SEND_X=980
SEND_Y=1820
```

---

# 🧪 Example Workflow

### 1️⃣ Launch Tool

```bash
chmod +x smsSender.sh
./smsSender.sh
```

---

### 2️⃣ Choose Option

```
1) Detect Send Button Coordinates (Auto)
2) Enter Send Button Coordinates (Manual)
3) Send SMS Message
0) Exit
```

---

### 3️⃣ Send SMS

* Enter phone number (with country code)
* Enter message
* Tool opens compose window
* Tool taps Send button
* SMS is sent

---

# 🧠 Technical Breakdown

## Intent Used

```bash
adb shell am start \
  -a android.intent.action.SENDTO \
  -d "sms:+1234567890" \
  --es sms_body "Test message"
```

This:

* Opens default SMS app
* Prefills number
* Prefills message body
* Does NOT auto-send (Android restriction)

---

## Why We Use Coordinate Tapping

Android blocks silent SMS sending unless:

* App is default SMS app
* Device is rooted
* System-level permissions exist

Therefore, this tool:

```
Intent → UI Open → Tap Send → Done
```

This approach is:

* Reliable
* Reproducible
* Forensically transparent
* Compatible with modern Android versions

---


# 🔬 Manual UI XML Analysis (Deep Dive Mode)

This section explains how to manually extract the **Send button coordinates** directly from the Android UI hierarchy dump.

This method is useful when:

* Auto-detection fails
* The messaging app uses a custom layout
* You want to understand exactly how the coordinate extraction works
* You are performing forensic validation

---

# 🧩 Step 1 – Dump the Current UI Hierarchy

Android provides a built-in UI inspection tool via:

```bash
adb shell uiautomator dump /sdcard/window_dump.xml
adb pull /sdcard/window_dump.xml .
```

This generates a full XML representation of the current screen.

Each UI element is represented as a `<node>` with attributes such as:

* `text` → Visible label
* `resource-id` → Internal identifier
* `class` → UI component type
* `bounds` → Screen rectangle occupied by the element

Example node:

```xml
<node 
    index="0"
    text=""
    resource-id="Compose:Draft:Send"
    class="android.view.View"
    bounds="[608,1404][706,1502]" />
```

---

# 🔎 Step 2 – Identify the SEND Button

To find candidate elements:

```bash
cat window_dump.xml | grep -i resource-id
```

You are looking for something that clearly identifies the send button.

In many messaging apps (including Google Messages), the Send button often contains a recognizable `resource-id`.

Example:

```
resource-id="Compose:Draft:Send"
```

This string uniquely identifies the Send button within the UI tree.

---

# 📦 Step 3 – Extract the Bounds

We extract the element and isolate its `bounds` value:

```bash
grep -oP 'resource-id="Compose:Draft:Send"[^>]*bounds="\[\d+,\d+\]\[\d+,\d+\]"' window_dump.xml
```

This returns:

```
resource-id="Compose:Draft:Send" bounds="[608,1404][706,1502]"
```

Now extract just the numeric coordinates:

```bash
grep -oP 'resource-id="Compose:Draft:Send"[^>]*bounds="\[\d+,\d+\]\[\d+,\d+\]"' window_dump.xml \
| sed -E 's/.*bounds="\[([0-9]+),([0-9]+)\]\[([0-9]+),([0-9]+)\]".*/\1 \2 \3 \4/'
```

Output:

```
608 1404 706 1502
```

These represent:

```
left  top   right  bottom
```

---

# 📐 Step 4 – Calculate the Center Point

Android tap events work best when targeting the **center of the element**, not the corner.

We calculate:

```
centerX = (left + right) / 2
centerY = (top + bottom) / 2
```

Using `awk`:

```bash
... | awk '{x=($1+$3)/2; y=($2+$4)/2; print "Tap coordinates:", x, y}'
```

For our example:

```
Tap coordinates: 657 1453
```

Math breakdown:

```
(608 + 706) / 2 = 657
(1404 + 1502) / 2 = 1453
```

---

# 👆 Step 5 – Trigger the Tap Event

Now simulate a tap:

```bash
adb shell input tap 657 1453
```

This performs the equivalent of physically tapping the center of the Send button.

If successful:

* The message is sent
* The compose window closes (depending on app behavior)

---

# 🧠 Why This Works

Android UI elements are rendered within a 2D coordinate system.

`bounds` defines a rectangular region:

```
[left,top][right,bottom]
```

ADB's `input tap` command simply injects a touch event at specific X/Y screen coordinates.

By computing the center of the UI element’s bounds, we:

* Avoid edge-case misses
* Avoid tapping outside the clickable region
* Increase reliability across devices

---

# 🧪 Forensic Validation Tip

To verify visually:

```bash
adb shell screencap -p /sdcard/screen.png
adb pull /sdcard/screen.png
```

Open the screenshot and confirm the coordinates align with the Send button.

This ensures:

* No UI overlays are blocking
* Keyboard is not covering the button
* Correct orientation is used

---

# ⚠️ Common Failure Points

### 1️⃣ Multiple Matching Nodes

Some apps reuse similar `resource-id` values.

Solution:

* Add additional filtering (e.g., match class or index)
* Manually inspect XML

---

### 2️⃣ Keyboard Overlay

If the soft keyboard is visible:

* It may shift UI elements
* It may block the Send button

Consider hiding it before tapping:

```bash
adb shell input keyevent 111
```

---

### 3️⃣ Screen Rotation

Landscape mode changes coordinate space.

For consistent results:

* Lock device to portrait mode

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

