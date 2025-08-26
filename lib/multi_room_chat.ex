defmodule MultiRoomChat do
  @moduledoc """
  Entry point for the MultiRoomChat application.
  Starts the interactive menu CLI.
  """

  def start do
    MultiRoomChat.CLI.start()
  end

  def run_demo do
    # Create users
    alice = MultiRoomChat.User.new("Alice")
    bob = MultiRoomChat.User.new("Bob")

    # Start a chat room
    {:ok, room} = ChatRoom.start_link({:demo_room, "Demo room for fun!"})

    # Users join the room
    ChatRoom.join(room, alice)
    ChatRoom.join(room, bob)
    for user <- ChatRoom.get_users(room) do
      IO.puts("User: #{user.name}")
    end

    # Send messages
    now = DateTime.utc_now()
    msg1 = %MultiRoomChat.Message{sender: alice, content: "Hello, Bob!", timestamp: now}
    msg2 = %MultiRoomChat.Message{sender: bob, content: "Hi, Alice!", timestamp: now}
    ChatRoom.send_message(room, msg1)
    ChatRoom.send_message(room, msg2)

    for message <- ChatRoom.get_messages(room) do
      IO.puts("Message: #{message}")
    end
  end
end
