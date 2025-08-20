defmodule MultiRoomChat.RoomDirectoryTests do
  use ExUnit.Case

  describe "Directory" do

    test "can create a room" do
      assert MultiRoomChat.RoomDirectory.create_room("cam", :room1, "A test room") == :ok
    end

    test "can get a room" do
      MultiRoomChat.RoomDirectory.create_room("cam", :room1, "A test room")
      assert MultiRoomChat.RoomDirectory.get_room(:room1) != nil
    end

    test "can list rooms" do
      MultiRoomChat.RoomDirectory.create_room("cam", :room1, "A test room")
      assert Enum.at(MultiRoomChat.RoomDirectory.list_rooms(), 0).name == :room1
    end

  end
end
