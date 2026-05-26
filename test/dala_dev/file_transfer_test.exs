defmodule DalaDev.FileTransferTest do
  use ExUnit.Case, async: true

  alias DalaDev.FileTransfer

  describe "push/3" do
    test "returns error when no devices are connected" do
      results = FileTransfer.push("nonexistent.txt", "dest.txt", device: "no-such-device")
      assert [{:error, _}] = results
    end
  end

  describe "pull/3" do
    test "returns error when no devices are connected" do
      results = FileTransfer.pull("remote.txt", "local.txt", device: "no-such-device")
      assert [{:error, _}] = results
    end
  end

  describe "ls/2" do
    test "returns error when no devices are connected" do
      assert {:error, _} = FileTransfer.ls("data", device: "no-such-device")
    end
  end

  describe "sync/3" do
    test "returns error when no devices are connected" do
      results = FileTransfer.sync("priv/fixtures", "fixtures", device: "no-such-device")
      assert [{:error, _}] = results
    end

    test "returns error for non-existent local directory" do
      results = FileTransfer.sync("nonexistent_dir", "fixtures", device: "no-such-device")
      assert [{:error, _}] = results
    end
  end
end
