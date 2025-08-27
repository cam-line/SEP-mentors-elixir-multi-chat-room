defmodule MultiRoomChat.RoomsSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
      children = [
        MultiRoomChat.RoomDirectory
      ]
      opts = [strategy: :one_for_one]
      Supervisor.init(children, opts)
  end
end
