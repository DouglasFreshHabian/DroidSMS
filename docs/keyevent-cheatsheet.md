# 🎮 ADB Input & KeyEvent Cheatsheet (Numeric Codes)

This reference lists commonly used Android `input keyevent` numeric codes for ADB automation.

All commands simulate hardware-level input events.

---

# 🔹 Basic Syntax

## Key Event

```bash
adb shell input keyevent <numeric_code>
```

Example:

```bash
adb shell input keyevent 3
```

---

## Tap

```bash
adb shell input tap X Y
```

---

## Swipe

```bash
adb shell input swipe X1 Y1 X2 Y2
```

With duration (milliseconds):

```bash
adb shell input swipe X1 Y1 X2 Y2 300
```

---

# ⌨️ Core Navigation Keys

| Action     | Code |
| ---------- | ---- |
| Home       | 3    |
| Back       | 4    |
| Call       | 5    |
| End Call   | 6    |
| 0–9 Keys   | 7–16 |
| Enter      | 66   |
| Delete     | 67   |
| Tab        | 61   |
| Escape     | 111  |
| App Switch | 187  |
| Menu       | 82   |
| Power      | 26   |

Example:

```bash
adb shell input keyevent 61
```

(Tab)

---

# 🔼 Directional Pad (Focus Navigation)

| Action | Code |
| ------ | ---- |
| Up     | 19   |
| Down   | 20   |
| Left   | 21   |
| Right  | 22   |
| Select | 23   |

Example:

```bash
adb shell input keyevent 20
```

(Down)

---

# 🔊 Volume & System

| Action        | Code |
| ------------- | ---- |
| Volume Up     | 24   |
| Volume Down   | 25   |
| Volume Mute   | 164  |
| Camera        | 27   |
| Notifications | 83   |
| Settings      | 176  |

---

# 🖐 Gesture Examples

## Scroll Up

```bash
adb shell input swipe 500 1600 500 400
```

## Scroll Down

```bash
adb shell input swipe 500 400 500 1600
```

## Long Press (Simulated)

```bash
adb shell input swipe 600 1200 600 1200 800
```

(Swipe to same coordinate with duration.)

---

# 📏 Get Screen Resolution

```bash
adb shell wm size
```

Example:

```
Physical size: 1080x2400
```

Coordinates must fall within this range.

---

# 🔠 Inject Text

```bash
adb shell input text "Hello\ World"
```

Spaces must be escaped or quoted.

---

# 🧠 Focus-Based Automation Tip

Instead of tapping coordinates:

```bash
adb shell input keyevent 61   # TAB
adb shell input keyevent 66   # ENTER
```

Focus-based automation is often:

* More portable
* Less resolution-dependent
* More stable across devices

---

# 🔎 Full KeyEvent Reference

To inspect available keycodes directly on device:

```bash
adb shell getevent -l
```
---

# ⚠️ Notes

* Device must be unlocked
* OEM skins may change behavior
* Soft keyboard can shift layout
* Gesture navigation may override some keys

Using numeric codes makes automation scripts cleaner and more predictable for Bash workflows.

---
