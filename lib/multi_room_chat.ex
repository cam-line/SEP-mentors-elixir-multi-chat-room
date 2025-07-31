defmodule MultiRoomChat do
  @moduledoc """
  Simple demo for creating a room, joining with two users, and sending messages.
  """

  def run_demo do
    # Create users
    alice = MultiRoomChat.User.new("Alice")
    bob = MultiRoomChat.User.new("Bob")

    # Start a chat room
    {:ok, room} = ChatRoom.start_link(:demo_room)

    # Users join the room
    ChatRoom.join(room, alice)
    ChatRoom.join(room, bob)

    # Send messages
    now = DateTime.utc_now()
    msg1 = %MultiRoomChat.Message{sender: alice, content: "Hello, Bob!", timestamp: now}
    msg2 = %MultiRoomChat.Message{sender: bob, content: "Hi, Alice!", timestamp: now}
    ChatRoom.send_message(room, msg1)
    ChatRoom.send_message(room, msg2)

  end
end
