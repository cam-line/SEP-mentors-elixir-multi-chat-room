defmodule MultiRoomChat.Application do
  use Application

  def start(_type, _args) do
    children = [
      MultiRoomChat.RoomDirectory
    ]

    opts = [strategy: :one_for_one, name: MultiRoomChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
