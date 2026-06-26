defmodule DalaDev.Tui do
  @moduledoc """
  Terminal-based interactive dashboard for dala_dev.

  `dala_dev.tui` provides a navigable two-panel TUI for interacting with
  the dala_dev toolkit — manage devices, run Mix tasks, inspect logs,
  and trigger deployments — all without leaving the terminal.

  ## Usage

  Add `dala_dev` to your dependencies (it already is if you're in a dala project):

      def deps do
        [
          {:dala_dev, "~> 0.3"}
        ]
      end

  Then run:

      mix dala_dev.tui

  ## Features

  - **Device panel**: List discovered Android/iOS devices with node info, dist ports, connection status
  - **Tasks panel**: Browse and run `mix dala.*` tasks
  - **Output panel**: View results from task runs
  - **Debug panel**: Inspect remote nodes — dala/OTP version, screen info, memory usage, latency
  - **Status bar**: Real-time connection info, dala version, OTP version
  - **Deploy**: Trigger `mix dala.deploy` with device selection
  - **Logs**: Stream logs from connected devices
  - **Help overlay**: Keyboard reference

  ## Keybindings

  | Key | Action |
  | --- | --- |
  | `j` / `↓` | Move selection down |
  | `k` / `↑` | Move selection up |
  | `h` / `←` | Focus navigation panel |
  | `l` / `→` | Focus detail panel |
  | `Enter` | Select / run action |
  | `Esc` | Go back / close overlay |
  | `r` | Refresh device list |
  | `d` | Deploy to selected device |
  | `s` | Stream logs from selected device |
  | `?` | Toggle help overlay |
  | `q` | Quit |

  ## Architecture

  The TUI follows the same pattern as `ash_tui`:

  - `DalaDev.Tui` — public API, entry point
  - `DalaDev.Tui.App` — ExRatatui app callback
  - `DalaDev.Tui.State` — pure navigation state and key handling
  - `DalaDev.Tui.Devices` — device discovery and status
  - `DalaDev.Tui.Views.*` — rendering modules (pure functions)
  - `DalaDev.Tui.Theme` — color palette and shared styles
  """

  @doc """
  Launches the dala_dev TUI dashboard.

  Starts the ExRatatui application which renders the two-panel interface.
  Blocks until the user quits (presses `q`).

  ## Options

    * `:test_mode` — `{width, height}` tuple for headless testing (optional)
    * `:name` — register the app under a named process (optional)

  ## Examples

      DalaDev.Tui.explore()

  """
  @spec explore(keyword()) :: :ok
  def explore(opts \\ []) do
    starter = Application.get_env(:dala_dev, :tui_starter, &DalaDev.Tui.App.start_link/1)
    {:ok, pid} = starter.(opts)
    ref = Process.monitor(pid)

    receive do
      {:DOWN, ^ref, :process, ^pid, _reason} -> :ok
    end
  end
end
