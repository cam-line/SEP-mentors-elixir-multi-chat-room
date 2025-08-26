defmodule MultiRoomChat.Supervisor do
  use Supervisor

  def start_link(rooms_config) do
    Supervisor.start_link(__MODULE__, rooms_config, name: __MODULE__)
  end

  def init(rooms_config) do
    children = [
      {MultiRoomChat.RoomsSupervisor, []},
      {MultiRoomChat.Server}
      # {MultiRoomChat.UserRegistry, []},
      # {Registry, keys: :unique, name: MultiRoomChat.RoomRegistry}
    ]

    opts = [strategy: :one_for_all]
    Supervisor.init(children, opts)
  end
end
