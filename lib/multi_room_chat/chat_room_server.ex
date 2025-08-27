defmodule MultiRoomChat.ChatRoomServer do
  use GenServer
  @moduledoc """
  GenServer responsible for managing chat room state (users, messages, etc).
  One ChatRoomServer per room.
  """

  defmodule State do
    defstruct name: nil, owner: nil, description: nil, users: [], messages: []
  end

  # API
  def start_link(room_config) do
    GenServer.start_link(__MODULE__, room_config, name: String.to_atom(room_config.name))
  end

  def join(room_name, user) do
    GenServer.cast(String.to_atom(room_name), {:join, user})
  end

  def leave(room_name, user) do
    GenServer.cast(String.to_atom(room_name), {:leave, user})
  end

  def send_message(room_name, message) do
    GenServer.cast(String.to_atom(room_name), {:send_message, message})
  end

  def get_users(room_name) do
    GenServer.call(String.to_atom(room_name), :get_users)
  end

  def get_messages(room_name) do
    GenServer.call(String.to_atom(room_name), :get_messages)
  end

  # Callbacks
  @impl true
  def init(room_config) do
    state = %State{
      name: room_config.name,
      owner: room_config.owner,
      description: room_config.description,
      users: [],
      messages: []
    }
    {:ok, state}
  end

  @impl true
  def handle_cast({:join, _user}, state) do
    # TODO: Implement join logic
    {:noreply, state}
  end

  @impl true
  def handle_cast({:leave, _user}, state) do
    # TODO: Implement leave logic
    {:noreply, state}
  end

  @impl true
  def handle_cast({:send_message, _message}, state) do
    # TODO: Implement message logic
    {:noreply, state}
  end

  @impl true
  def handle_call(:get_users, _from, state) do
    {:reply, state.users, state}
  end

  @impl true
  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end

  defp name(room_name) do
    :"#{room_name}Server"
  end
end
