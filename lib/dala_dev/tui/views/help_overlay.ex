defmodule DalaDev.Tui.Views.HelpOverlay do
  @moduledoc """
  Help overlay with keyboard reference.

  Pure function — takes rect, returns `[{widget, rect}]`.
  """

  alias DalaDev.Tui.Theme
  alias ExRatatui.Layout.Rect
  alias ExRatatui.Style
  alias ExRatatui.Text.{Line, Span}
  alias ExRatatui.Widgets.{Block, Paragraph}

  @doc """
  Renders the help overlay.
  """
  @spec render(Rect.t()) :: [{struct(), Rect.t()}]
  def render(rect) do
    help_lines = [
      blank_line(),
      help_section("Navigation"),
      help_row("j / ↓", "Move selection down"),
      help_row("k / ↑", "Move selection up"),
      help_row("h / ←", "Focus navigation panel"),
      help_row("l / →", "Focus detail panel"),
      help_row("Tab", "Switch tabs (Devices/Tasks/Output/Debug)"),
      help_row("1-4", "Jump to tab by number"),
      blank_line(),
      help_section("Device Actions"),
      help_row("Enter", "Select device"),
      help_row("d", "Deploy to selected device"),
      help_row("s", "Stream logs from device"),
      help_row("r", "Refresh device list"),
      blank_line(),
      help_section("Debug Actions"),
      help_row("i", "Inspect selected remote node"),
      help_row("Enter", "Run task / query node"),
      blank_line(),
      help_section("Other"),
      help_row("?", "Toggle this help"),
      help_row("q", "Quit"),
      blank_line(),
      %Line{
        spans: [
          %Span{
            content: "  Press any key to close this help.",
            style: Theme.dim_text_style()
          }
        ]
      }
    ]

    [
      {%Paragraph{
         text: help_lines,
         block: %Block{
           title: help_title(),
           borders: [:all],
           border_type: :double,
           border_style: Theme.focused_border_style(),
           style: %Style{bg: {:rgb, 20, 20, 30}}
         }
       }, rect}
    ]
  end

  # ── Private ──────────────────────────────────────────────────

  defp help_title do
    %Line{
      spans: [
        %Span{content: " ⚡ ", style: %Style{}},
        %Span{content: "Keyboard Reference ", style: %Style{fg: :white, modifiers: [:bold]}}
      ]
    }
  end

  defp help_section(label) do
    %Line{
      spans: [
        %Span{content: "  ── ", style: Theme.dim_text_style()},
        %Span{content: label, style: %Style{fg: Theme.cornflower(), modifiers: [:bold]}},
        %Span{content: " ──", style: Theme.dim_text_style()}
      ]
    }
  end

  defp help_row(keys, description) do
    %Line{
      spans: [
        %Span{content: "  ", style: %Style{}},
        Theme.key_pill(keys),
        %Span{content: "  ", style: %Style{}},
        %Span{content: description, style: %Style{fg: :white}}
      ]
    }
  end

  defp blank_line, do: %Line{spans: [%Span{content: "", style: %Style{}}]}
end
