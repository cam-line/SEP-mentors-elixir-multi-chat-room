defmodule ChatRoom do
  use GenServer
  ## Public API
  def start_link({name, description}) do
    GenServer.start_link(__MODULE__, {name, description}, name: name)
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

  def get_description(room) do
    GenServer.call(room, :get_description)
  end

  ## Callbacks
  @impl true
  def init({room_name, description}) do
    {:ok, %{name: room_name, messages: [], users: [], description: description}}
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
  def handle_cast({:send_message, message = %MultiRoomChat.Message{sender: sender}}, state) do
    if (sender in state.users) do
      formatted = MultiRoomChat.Message.format(message)
      IO.puts(formatted)
      # TODO Store the message not the formatted string
      new_state = %{state | messages: [message | state.messages]}
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_call(:get_users, _from, state) do
    {:reply, state.users, state}
  end

  @impl true
  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end

  @impl true
  def handle_call(:get_description, _from, state) do
    {:reply, state.description, state}
  end
end
