defmodule DalaDev.Tui.Tasks do
  @moduledoc """
  Mix task definitions for the TUI.

  Provides a categorized list of available `mix dala.*` tasks
  that the user can browse and run from the TUI.
  """

  defstruct [:name, :module, :description, :category, :args]

  @type t :: %__MODULE__{
          name: String.t(),
          module: atom(),
          description: String.t(),
          category: atom(),
          args: [String.t()]
        }

  @doc """
  Returns all available dala_dev Mix tasks, grouped by category.
  """
  @spec list() :: [t()]
  def list do
    [
      %__MODULE__{
        name: "devices",
        module: Mix.Tasks.Dala.Devices,
        description: "List discovered Android and iOS devices",
        category: :device,
        args: []
      },
      %__MODULE__{
        name: "emulators",
        module: Mix.Tasks.Dala.Emulators,
        description: "Manage and launch emulators/simulators",
        category: :device,
        args: []
      },
      %__MODULE__{
        name: "deploy",
        module: Mix.Tasks.Dala.Deploy,
        description: "Deploy builds to connected devices",
        category: :deploy,
        args: []
      },
      %__MODULE__{
        name: "push",
        module: Mix.Tasks.Dala.Push,
        description: "Hot-push changed BEAM modules",
        category: :deploy,
        args: []
      },
      %__MODULE__{
        name: "connect",
        module: Mix.Tasks.Dala.Connect,
        description: "Connect to a running device session",
        category: :deploy,
        args: []
      },
      %__MODULE__{
        name: "watch",
        module: Mix.Tasks.Dala.Watch,
        description: "Auto-push BEAMs on file save",
        category: :deploy,
        args: []
      },
      %__MODULE__{
        name: "screen",
        module: Mix.Tasks.Dala.Screen,
        description: "Capture screenshots, record video",
        category: :device,
        args: []
      },
      %__MODULE__{
        name: "doctor",
        module: Mix.Tasks.Dala.Doctor,
        description: "Diagnose setup and configuration issues",
        category: :diagnostics,
        args: []
      },
      %__MODULE__{
        name: "install",
        module: Mix.Tasks.Dala.Install,
        description: "First-run setup: OTP runtime, icons, dala.exs",
        category: :setup,
        args: []
      },
      %__MODULE__{
        name: "enable",
        module: Mix.Tasks.Dala.Enable,
        description: "Enable optional Dala features",
        category: :setup,
        args: []
      },
      %__MODULE__{
        name: "icon",
        module: Mix.Tasks.Dala.Icon,
        description: "Regenerate app icons from source image",
        category: :setup,
        args: []
      },
      %__MODULE__{
        name: "provision",
        module: Mix.Tasks.Dala.Provision,
        description: "Handle iOS provisioning profiles",
        category: :setup,
        args: []
      },
      %__MODULE__{
        name: "release",
        module: Mix.Tasks.Dala.Release,
        description: "Build signed iOS .ipa",
        category: :release,
        args: []
      },
      %__MODULE__{
        name: "release.android",
        module: Mix.Tasks.Dala.Release.Android,
        description: "Build signed Android .aab",
        category: :release,
        args: []
      },
      %__MODULE__{
        name: "publish",
        module: Mix.Tasks.Dala.Publish,
        description: "Upload .ipa to App Store / TestFlight",
        category: :release,
        args: []
      },
      %__MODULE__{
        name: "publish.android",
        module: Mix.Tasks.Dala.Publish.Android,
        description: "Upload .aab to Google Play Console",
        category: :release,
        args: []
      },
      %__MODULE__{
        name: "server",
        module: Mix.Tasks.Dala.Server,
        description: "Start dev dashboard (Phoenix, :4040)",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "web",
        module: Mix.Tasks.Dala.Web,
        description: "Start comprehensive web UI",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "debug",
        module: Mix.Tasks.Dala.Debug,
        description: "Interactive debugging for dala nodes",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "observer",
        module: Mix.Tasks.Dala.Observer,
        description: "Web-based Observer for remote nodes",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "logs",
        module: Mix.Tasks.Dala.Logs,
        description: "Collect and stream logs from devices",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "trace",
        module: Mix.Tasks.Dala.Trace,
        description: "Distributed tracing for dala clusters",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "bench",
        module: Mix.Tasks.Dala.Bench,
        description: "Run performance benchmarks",
        category: :dev,
        args: []
      },
      %__MODULE__{
        name: "cache",
        module: Mix.Tasks.Dala.Cache,
        description: "Show or clear machine-wide caches",
        category: :diagnostics,
        args: []
      },
      %__MODULE__{
        name: "routes",
        module: Mix.Tasks.Dala.Routes,
        description: "Validate navigation destinations",
        category: :diagnostics,
        args: []
      },
      %__MODULE__{
        name: "push_file",
        module: Mix.Tasks.Dala.PushFile,
        description: "Push file or directory to devices",
        category: :file,
        args: []
      },
      %__MODULE__{
        name: "pull_file",
        module: Mix.Tasks.Dala.PullFile,
        description: "Pull file or directory from device",
        category: :file,
        args: []
      },
      %__MODULE__{
        name: "sync",
        module: Mix.Tasks.Dala.Sync,
        description: "Sync local directory with device",
        category: :file,
        args: []
      },
      %__MODULE__{
        name: "file_ls",
        module: Mix.Tasks.Dala.FileLs,
        description: "List files on connected device",
        category: :file,
        args: []
      }
    ]
  end

  @doc """
  Returns tasks filtered by category.
  """
  @spec by_category(atom()) :: [t()]
  def by_category(category) do
    Enum.filter(list(), &(&1.category == category))
  end

  @doc """
  Returns all task categories with their labels.
  """
  @spec categories() :: [{atom(), String.t()}]
  def categories do
    [
      {:device, "Devices"},
      {:deploy, "Deploy"},
      {:setup, "Setup"},
      {:release, "Release"},
      {:dev, "Development"},
      {:diagnostics, "Diagnostics"},
      {:file, "File Transfer"}
    ]
  end

  @doc """
  Returns the category label.
  """
  @spec category_label(atom()) :: String.t()
  def category_label(category) do
    case category do
      :device -> "Devices"
      :deploy -> "Deploy"
      :setup -> "Setup"
      :release -> "Release"
      :dev -> "Development"
      :diagnostics -> "Diagnostics"
      :file -> "File Transfer"
      _ -> Atom.to_string(category)
    end
  end
end
