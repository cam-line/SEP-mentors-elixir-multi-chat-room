defmodule MultiRoomChat.RoomDirectory do
  use GenServer
  ## Public API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def list_rooms do
    GenServer.call(__MODULE__, :list_rooms)
  end

  def create_room(owner, name, description) do
    GenServer.call(__MODULE__, {:create_room, owner, name, description})
  end

  ## Callbacks
  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:list_rooms, _from, state) do
    {:reply, Map.values(state), state}
  end

  @impl true
  def handle_call({:create_room, owner, name, description}, _from, state) do
    room = %MultiRoomChat.ChatRoomDescription{owner: owner, name: name, description: description, users: []}
    {:reply, :ok, Map.put(state, name, room)}
  end
end
