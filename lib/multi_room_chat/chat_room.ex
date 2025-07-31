defmodule ChatRoom do
  use GenServer
  ## Public API
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def join(room, user) do
    GenServer.cast(room, {:join, user})
  end

  def leave(room, user) do
    GenServer.cast(room, {:leave, user})
  end

  def send_message(room, %MultiRoomChat.Message{} = message) do
    GenServer.cast(room, {:send_message, message})
  end

  def get_users(room) do
    GenServer.call(room, :get_users)
  end

  def get_messages(room) do
    GenServer.call(room, :get_messages)
  end

  ## Callbacks
  @impl true
  def init(room_name) do
    {:ok, %{name: room_name, messages: [], users: []}}
  end

  @impl true
  def handle_cast({:join, user}, state) do
    if (user in state.users) do
      {:noreply, state}
    else
      new_state =
        %{state | users: [user | state.users]}
      {:noreply, new_state}
    end
  end

  @impl true
  def handle_cast({:leave, user}, state) do
    if (user in state.users) do
      new_state = %{state | users: List.delete(state.users, user)}
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:send_message, message = %MultiRoomChat.Message{sender: sender, content: content, timestamp: timestamp}}, state) do
    if (sender in state.users) do
      formatted = MultiRoomChat.Message.format(message)
      IO.puts(formatted)
      new_state = %{state | messages: [formatted | state.messages]}
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end
end
