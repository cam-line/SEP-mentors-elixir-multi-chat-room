defmodule MultiRoomChat.RoomDirectory do
  use GenServer

  @moduledoc """
  Tracks active chat rooms as ChatRoomServer processes and their metadata.
  State: %{room_name => %{pid: pid, description: description, owner: owner}}
  """

  ## Public API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def list_rooms do
    GenServer.call(__MODULE__, :list_rooms)
  end

  def get_room(name) do
    GenServer.call(__MODULE__, {:get_room, name})
  end

  def create_room(room_config) do
    GenServer.call(__MODULE__, {:create_room, room_config})
  end

  ## Callbacks
  @impl true
  def init(_init_arg) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:list_rooms, _from, state) do
    # Return list of %{name, pid, description, owner} for each room
    rooms = for {name, %{pid: pid, description: desc, owner: owner}} <- state do
      %{name: name, pid: pid, description: desc, owner: owner}
    end
    {:reply, rooms, state}
  end

  @impl true
  def handle_call({:get_room, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  @impl true
  def handle_call({:create_room, room_config}, _from, state) do
    {:ok, _room_sup} = Supervisor.start_child(MultiRoomChat.RoomsSupervisor,
    supervisor_spec(room_config))
    pid = Process.whereis(String.to_atom(room_config.name))
    new_room = %{pid: pid, description: room_config.description, owner: room_config.owner}
    {:reply, :ok, Map.put(state, room_config.name, new_room)}
  end


  ## Private
  defp supervisor_spec(room_config) do
    %{
      id: String.to_atom("#{room_config[:name]}Supervisor"),
      start: {MultiRoomChat.ChatRoomSupervisor, :start_link, [room_config]}
    }
  end
end
