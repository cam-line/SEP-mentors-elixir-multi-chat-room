defmodule ChatRoomTests do
  use ExUnit.Case

  describe "ChatRoom" do
    setup do
      {:ok, chat_room} = ChatRoom.start_link({:room1, "A test chat room"})
      %{chat_room: chat_room}
    end

    test "users can get the room description", %{chat_room: chat_room} do
      assert ChatRoom.get_description(chat_room) == "A test chat room"
    end

    test "users can join the chat room", %{chat_room: chat_room} do
      ChatRoom.join(chat_room, "user1")
      assert ChatRoom.get_users(chat_room) == ["user1"]
    end

    test "users can leave the chat room", %{chat_room: chat_room} do
      ChatRoom.join(chat_room, "user1")
      ChatRoom.leave(chat_room, "user1")
      assert ChatRoom.get_users(chat_room) == []
    end

    test "non users cannot send messages", %{chat_room: chat_room} do
      message = %MultiRoomChat.Message{sender: "user2", content: "Hello, world!"}
      ChatRoom.send_message(chat_room, message)
      assert ChatRoom.get_messages(chat_room) == []
    end

    test "users can send messages", %{chat_room: chat_room} do
      ChatRoom.join(chat_room, "user1")
      message = %MultiRoomChat.Message{sender: "user1", content: "Hello, world!", timestamp: DateTime.utc_now()}
      ChatRoom.send_message(chat_room, message)
      assert ChatRoom.get_messages(chat_room) == [message]
    end
  end
end
