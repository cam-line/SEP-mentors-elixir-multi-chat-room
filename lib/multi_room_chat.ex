defmodule MultiRoomChat do
  @moduledoc """
  Simple demo for creating a room, joining with two users, and sending messages.
  """
alias MultiRoomChat.Message

  def run_demo do
    # Create users
    alice = MultiRoomChat.User.new("Alice")
    bob = MultiRoomChat.User.new("Bob")

    # Start a chat room
    {:ok, room} = ChatRoom.start_link({:demo_room, "Demo room for fun!"})

    # Users join the room
    ChatRoom.join(room, alice.name)
    ChatRoom.join(room, bob.name)
    for user <- ChatRoom.get_users(room) do
      IO.puts("User: #{user}")
    end

    # Send messages
    now = DateTime.utc_now()
    msg1 = %MultiRoomChat.Message{sender: alice.name, content: "Hello, Bob!", timestamp: now}
    msg2 = %MultiRoomChat.Message{sender: bob.name, content: "Hi, Alice!", timestamp: now}
    ChatRoom.send_message(room, msg1)
    ChatRoom.send_message(room, msg2)

    Process.sleep(1000)  # Wait for messages to be processed

    for message <- ChatRoom.get_messages(room) do
      IO.puts("Message: #{Message.format(message)}")
    end
  end
end
