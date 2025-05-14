# OBS Pomodoro Timer (Lua)

A Lua-based Pomodoro timer for OBS Studio (tested on v31.0.3), designed to display countdowns and session info via a GDI+ Text source.

## Features

- Start/Stop and Pause/Resume controls
- Custom input for:
  - Number of sessions
  - Work minutes
  - Break minutes
  - Start message
  - Break message
- Displays timer and session tracker like this:
25:00 Pomo 1/4
Focus

- Session count updates only **after the break ends**
- Start and Break messages display for 2 seconds

## How to Use

1. **In OBS**, create a **Text (GDI+) source**  
 - Click the **"+" button** under the "Sources" list  
 - Choose **"Text (GDI+)"**  
 - Name it something like `"PomodoroText"`  
 - You don’t need to type anything in yet, just click OK.

2. Open **`Tools > Scripts`** in OBS

3. Click the **“+” button** and load the script file:
[**pomodoro_obs.lua**](https://raw.githubusercontent.com/Carocim/obs-pomodoro-timer/refs/heads/main/pomodoro_obs.lua)

4. In the script settings panel:
- Select the **Text Source** you created earlier (e.g., `PomodoroText`)
- Set:
  - **Number of Sessions** (e.g., 4)
  - **Work Duration (minutes)** (e.g., 25)
  - **Break Duration (minutes)** (e.g., 5)
  - **Start Message** (e.g., "Focus up! 🍅")
  - **Break Message** (e.g., "Break time! 🌿")

5. Use the **Start/Stop** and **Pause/Resume** buttons to control the timer.

---

## Tested On

- OBS Studio v31.0.3 (Windows)

---

Made with ❤️ for productivity 🍅




