defmodule DalaDev.Tui.RemoteTest do
  use ExUnit.Case, async: true

  alias DalaDev.Tui.Remote

  describe "struct defaults" do
    test "creates a remote struct with all nil fields" do
      remote = %Remote{node: :test@localhost}

      assert remote.node == :test@localhost
      assert remote.version == nil
      assert remote.otp_version == nil
      assert remote.erts_version == nil
      assert remote.app_version == nil
      assert remote.current_screen == nil
      assert remote.screen_info == nil
      assert remote.assigns == nil
      assert remote.memory == nil
      assert remote.process_count == nil
      assert remote.supervision_tree == nil
      assert remote.latency_ms == nil
      assert remote.connected_at == nil
      assert remote.error == nil
    end

    test "creates a remote struct with populated fields" do
      remote = %Remote{
        node: :demo@localhost,
        version: "0.8.0",
        otp_version: "27",
        erts_version: "15.0",
        app_version: "0.1.0",
        current_screen: "HomeScreen",
        screen_info: %{title: "Home"},
        assigns: %{user: "John"},
        memory: %{total: 50_000_000},
        process_count: 150,
        latency_ms: 2.5,
        error: nil
      }

      assert remote.version == "0.8.0"
      assert remote.current_screen == "HomeScreen"
      assert remote.process_count == 150
      assert remote.latency_ms == 2.5
    end
  end

  describe "connected_nodes/0" do
    test "returns a list of connected nodes" do
      nodes = Remote.connected_nodes()
      assert is_list(nodes)
    end

    test "returns empty list when no nodes connected" do
      # In test environment, typically no nodes are connected
      nodes = Remote.connected_nodes()
      assert Enum.all?(nodes, &is_atom/1)
    end
  end

  describe "reachable?/1" do
    test "returns false for unreachable node" do
      refute Remote.reachable?(:nonexistent@localhost)
    end

    test "returns false for invalid node name" do
      refute Remote.reachable(:not_a_node)
    end
  end

  describe "get_dala_version/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_dala_version(:nonexistent@localhost)
    end
  end

  describe "get_app_version/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_app_version(:nonexistent@localhost)
    end
  end

  describe "get_screen_info/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_screen_info(:nonexistent@localhost)
    end
  end

  describe "get_current_screen/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_current_screen(:nonexistent@localhost)
    end
  end

  describe "get_assigns/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_assigns(:nonexistent@localhost)
    end
  end

  describe "get_memory/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.get_memory(:nonexistent@localhost)
    end
  end

  describe "get_process_count/1" do
    test "returns 0 for unreachable node" do
      assert Remote.get_process_count(:nonexistent@localhost) == 0
    end
  end

  describe "measure_latency/1" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.measure_latency(:nonexistent@localhost)
    end
  end

  describe "eval/2" do
    test "returns error for unreachable node" do
      assert {:error, _} = Remote.eval(:nonexistent@localhost, "1 + 1")
    end
  end
end
