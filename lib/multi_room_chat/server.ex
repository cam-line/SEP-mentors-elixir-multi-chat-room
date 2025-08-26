defmodule MultiRoomChat.Server do
  use GenServer
  import Supervisor.Spec
  ## API
  def start_link(rooms_config) do
    GenServer.start_link(__MODULE__, rooms_config, name: __MODULE__)
  end

  def checkout(room_name) do
    GenServer.call(:"#{room_name}Server", :checkout)
  end

  def checkin(room_name, worker_pid) do
    GenServer.call(:"#{room_name}Server", {:checkin, worker_pid})
  end

  def status(room_name) do
    GenServer.call(:"#{room_name}Server", :status)
  end

  ## Callbacks
  def init(rooms_config) do
    rooms_config |> Enum.each(fn(room_config) ->
      send(self(), {:start_room, room_config})
    end)

    {:ok, rooms_config}
  end

  def handle_info({:start_room, room_config}, state) do
    {:ok, _room_sup} = Supervisor.start_child(MultiRoomChat.RoomsSupervisor,
    supervisor_spec(room_config))
    {:noreply, state}
  end

  ## Private
  defp supervisor_spec(room_config) do
    %{
      id: String.to_atom("#{room_config[:name]}Supervisor"),
      start: {MultiRoomChat.ChatRoomSupervisor, :start_link, [room_config]}
    }
  end
end
