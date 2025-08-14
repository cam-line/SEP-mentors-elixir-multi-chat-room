defmodule MultiRoomChat.DirectoryTests do
  use ExUnit.Case

  describe "Directory" do
    setup do
      {:ok, directory} = MultiRoomChat.Directory.start_link([])
      %{directory: directory}
    end

    test "can create a room", %{directory: directory} do
      assert MultiRoomChat.Directory.create_room(directory, :room1, "A test room") == :ok
    end

    test "can get a room", %{directory: directory} do
      MultiRoomChat.Directory.create_room(directory, :room1, "A test room")
      assert MultiRoomChat.Directory.get_room(directory, :room1) != nil
    end

    test "can list rooms", %{directory: directory} do
      MultiRoomChat.Directory.create_room(directory, :room1, "A test room")
      assert MultiRoomChat.Directory.list_rooms(directory) == [:room1]
    end

  end
end
