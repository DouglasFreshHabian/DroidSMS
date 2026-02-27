# 📱 Manual ADB SMS Walkthrough

This document explains how to manually send an SMS using ADB while understanding Android’s internal architecture.

---

# 📦 Step 1 — Packages

```bash
adb shell pm list packages | grep -i messaging
````

A package is an installed application.

Android manages applications by package name.

Example:

```
com.google.android.apps.messaging
```

Before controlling an app, you must identify it.

---

# 🚪 Step 2 — Activities

```bash
adb shell am start \
  -a android.intent.action.MAIN \
  -c android.intent.category.APP_MESSAGING
```

An Activity represents a screen.

Opening an app = launching an Activity.

---

# 📬 Step 3 — Intents

```bash
adb shell am start \
  -a android.intent.action.SENDTO \
  -d sms:+1234567890
```

An Intent is a structured request.

Here, we ask Android to open the SMS composer for a specific number.

The OS resolves which app handles the request.

---

# 🎯 Step 4 — Focus Management

Before injecting text, the message field must be focused.

```bash
adb shell input keyevent KEYCODE_TAB
```

TAB cycles through focusable elements.

Only the focused element receives keyboard input.

---

# ⌨️ Step 5 — Inject Text

```bash
adb shell input text "Hello\ World!"
```

This simulates keyboard input.

The UI does not distinguish between physical and injected input.

---

# 🧠 Step 6 — Inspect UI

```bash
adb shell uiautomator dump /sdcard/window_dump.xml
adb pull /sdcard/window_dump.xml .
```

This exports the full UI hierarchy as XML.

Each node contains:

* class
* resource-id
* bounds
* clickable state

Now you are inspecting Android structurally.

---

# 👆 Step 7 — Tap Send

After calculating coordinates:

```bash
adb shell input tap X Y
```

This injects a physical touch event at the specified coordinates.

---

# 🔁 Step 8 — Reset State

```bash
adb shell input keyevent KEYCODE_HOME
adb shell am force-stop com.google.android.apps.messaging
```

Deterministic state reset improves automation reliability.

---

## Why This Matters

You just navigated:

Packages → Activities → Intents → Focus → Input → UI Hierarchy → Coordinate Injection

Automation becomes engineering once you understand the layers.

---
