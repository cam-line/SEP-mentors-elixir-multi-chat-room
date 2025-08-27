defmodule MultiRoomChat.Supervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, _args, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      {MultiRoomChat.RoomsSupervisor, []},
      {MultiRoomChat.Server}
      # {MultiRoomChat.UserRegistry, []},
    ]

    opts = [strategy: :one_for_all]
    Supervisor.init(children, opts)
  end
end
