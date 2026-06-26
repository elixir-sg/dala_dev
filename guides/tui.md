# DalaDev TUI

A terminal-based interactive dashboard for the dala_dev toolkit, built on [ExRatatui](https://hexdocs.pm/ex_ratatui).

Navigate devices, run Mix tasks, trigger deployments, inspect logs, and debug remote applications — all without leaving the terminal.

## Features

- **Four-tab layout**: Devices, Tasks, Output, Debug
- **Device panel**: List discovered Android/iOS devices and emulators with status, node info, and distribution ports
- **Tasks panel**: Browse and run `mix dala.*` tasks by category
- **Output panel**: View results from task runs
- **Debug panel**: Inspect remote nodes — version info, screen state, memory usage, process count, latency
- **Keyboard-driven**: Vim keybindings (`j`/`k`/`h`/`l`) and arrow keys
- **Status bar**: Real-time connection info, dala version, OTP version
- **Help overlay**: Press `?` for keyboard reference
- **Mix task**: `mix dala_dev.tui`

## UI Layout

```
╭─ ⚡ DalaDev TUI  │  Debug > demo@localhost ──────────╮
╰──────────────────────────────────────────────────────╯
╭─ Debug 1/1 connected ╮ ╭─ demo@localhost ──────────────═
│ 🟢 demo@localhost    │ │ Node:    demo@localhost        │
│   v0.8.0 (2.5ms)     │ │ Dala:    0.8.0                │
╰──────────────────────╯ │ OTP:     27                    │
                          │ ERTS:    15.0                  │
                          │ App:     0.1.0                 │
                          │ Latency: 2.5ms                 │
                          │                               │
                          │ Screen: HomeScreen             │
                          │                               │
                          │ Memory:                        │
                          │   total: 45.2 MB               │
                          │   processes: 12.1 MB            │
                          │   binary: 8.5 MB               │
                          │                               │
                          │ Processes: 150                 │
                          ╰───────────────────────────────╯
╭──────────────────────────────────────────────────────═
│ 🟢 Ready │ dala: 0.8.0 │ OTP: 27 │ devices: 2 │ nodes: 1│
╰──────────────────────────────────────────────────────╯
╭──────────────────────────────────────────────────────═
│ j/k navigate ⏎ select i inspect Tab tabs ? help q quit │
╰──────────────────────────────────────────────────────╯
```

## Usage

### Starting the TUI

```bash
mix dala_dev.tui
```

### Keybindings

#### Navigation

| Key | Action |
| --- | --- |
| `j` / `↓` | Move selection down |
| `k` / `↑` | Move selection up |
| `h` / `←` | Focus navigation panel |
| `l` / `→` | Focus detail panel |
| `Tab` | Cycle through tabs |
| `1` | Devices tab |
| `2` | Tasks tab |
| `3` | Output tab |
| `4` | Debug tab |

#### Device Actions

| Key | Action |
| --- | --- |
| `Enter` | Select device |
| `r` | Refresh device list |
| `d` | Deploy to selected device |
| `s` | Stream logs from selected device |

#### Debug Actions

| Key | Action |
| --- | --- |
| `i` | Inspect selected remote node (queries version, memory, screen) |
| `Enter` | Select remote node for inspection |

#### Other

| Key | Action |
| --- | --- |
| `?` | Toggle help overlay |
| `q` | Quit |

## Architecture

The TUI follows a clean architecture with pure state transformations:

```
mix dala_dev.tui
  → DalaDev.Tui.App (ExRatatui callback)
  → DalaDev.Tui.State (pure navigation logic)
  → DalaDev.Tui.Devices (device discovery)
  → DalaDev.Tui.Remote (remote node queries)
  → DalaDev.Tui.Tasks (task definitions)
  → DalaDev.Tui.Views.* (rendering)
  → DalaDev.Tui.Theme (colors/styles)
```

### Modules

| Module | Purpose |
| --- | --- |
| `DalaDev.Tui` | Public API, entry point |
| `DalaDev.Tui.App` | ExRatatui app callback |
| `DalaDev.Tui.State` | Pure navigation state and key handling |
| `DalaDev.Tui.Devices` | Device discovery with node/dist port metadata |
| `DalaDev.Tui.Remote` | Remote node queries (version, screen, memory, latency) |
| `DalaDev.Tui.Tasks` | Mix task definitions |
| `DalaDev.Tui.Theme` | Color palette and shared styles |
| `DalaDev.Tui.Views.NavPanel` | Left panel rendering |
| `DalaDev.Tui.Views.DetailPanel` | Right panel rendering |
| `DalaDev.Tui.Views.StatusBar` | Status bar with version/connection info |
| `DalaDev.Tui.Views.HelpOverlay` | Help overlay rendering |

## Remote Node Information

The Debug tab queries remote dala nodes via Erlang RPC to show:

### Version Information
- **Dala framework version** — queried via `Application.spec(:dala, :vsn)` on the remote node
- **OTP version** — from `:erlang.system_info(:otp_release)`
- **ERTS version** — from `:erlang.system_info(:system_version)`
- **App version** — from the application's vsn

### Screen Information
- **Current screen** — queried via `Dala.Test.screen/1`
- **Screen info** — queried via `Dala.Test.screen_info/1`
- **Assigns** — queried via `Dala.Test.assigns/1`

### Memory Usage
- Total memory
- Process memory
- Binary memory
- ETS memory
- Atom memory

### Connection
- **Latency** — measured via RPC round-trip time
- **Process count** — total processes on the remote node

## Testing

The TUI is designed for testability:

- State transitions are pure functions
- Views are pure functions that return widget structs
- The app can run in headless `test_mode` for testing

```bash
# Run TUI tests
mix test test/dala_dev/tui/
```

## Configuration

The TUI reads device information from dala_dev's discovery modules:

- Android: Uses `DalaDev.Discovery.Android` (via `adb devices`)
- iOS: Uses `DalaDev.Discovery.IOS` (via `xcrun simctl`)
- Remote nodes: Uses Erlang distribution `Node.list(:connected)` and RPC

No additional configuration is needed — the TUI automatically discovers available devices and connected nodes.
