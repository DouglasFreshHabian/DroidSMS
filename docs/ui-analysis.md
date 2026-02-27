# 🔬 UI XML & Coordinate Analysis

This document explains how DroidSMS dynamically locates the Send button.

---

# Step 1 — Dump UI

```bash
adb shell uiautomator dump /sdcard/window_dump.xml
adb pull /sdcard/window_dump.xml .
````

This produces a structured XML representation of the screen.

---

# Step 2 — Locate the Send Button

Search for resource identifiers:

```bash
grep -i resource-id window_dump.xml
```

Example node:

```xml
<node
    resource-id="Compose:Draft:Send"
    class="android.view.View"
    bounds="[608,1404][706,1502]" />
```

---

# Step 3 — Extract Bounds

```bash
grep -oP 'resource-id="Compose:Draft:Send"[^>]*bounds="\[\d+,\d+\]\[\d+,\d+\]"' window_dump.xml
```

Result:

```
[608,1404][706,1502]
```

Extract numeric values:

```bash
... | sed -E 's/.*\[([0-9]+),([0-9]+)\]\[([0-9]+),([0-9]+)\].*/\1 \2 \3 \4/'
```

---

# Step 4 — Calculate Center

```
centerX = (left + right) / 2
centerY = (top + bottom) / 2
```

Using awk:

```bash
... | awk '{x=($1+$3)/2; y=($2+$4)/2; print x, y}'
```

---

# Step 5 — Inject Tap

```bash
adb shell input tap centerX centerY
```

This simulates a physical touch at the center of the button.

---

# Why Center Targeting Works

Android defines clickable elements using rectangular bounds.

Tapping the center:

* Avoids edge misses
* Avoids overlap errors
* Improves cross-device reliability

---

# Common Failure Points

* Keyboard overlays shifting UI
* Landscape orientation
* Multiple matching resource IDs
* OEM-specific layout differences

DroidSMS dynamically performs this process to remain resolution-independent and reproducible.

---
