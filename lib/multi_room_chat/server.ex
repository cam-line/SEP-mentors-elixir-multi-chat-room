defmodule MultiRoomChat.Server do
  use GenServer

  ## API
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end


  # Scaffolding for room creation/joining using RoomDirectory
  def create_room(user, room_name, description) do
    # Use ChatRoomDescription struct for room config
    room_config = %MultiRoomChat.ChatRoomDescription{
      name: room_name,
      owner: user,
      description: description,
      users: []
    }
    MultiRoomChat.RoomDirectory.create_room(room_config)
  end

  def join_room(_user, _room_name) do
    # TODO: Implement join logic, lookup via RoomDirectory
    :ok
  end

  def list_rooms() do
    # TODO: Return list of rooms from RoomDirectory
    MultiRoomChat.RoomDirectory.list_rooms()
  end

  ## Callbacks
  def init(_state) do
    {:ok, %{}}
  end
end
