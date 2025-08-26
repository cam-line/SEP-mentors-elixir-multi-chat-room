defmodule MultiRoomChat.ChatRoomSupervisor do
  use Supervisor

  def start_link(room_config) do
    Supervisor.start_link(__MODULE__, room_config, name: String.to_atom("#{room_config[:name]}Supervisor"))
  end

  def init(room_config) do
    children = [
      {MultiRoomChat.ChatRoomServer, [self(), room_config]}
    ]
    opts = [strategy: :one_for_all]
    Supervisor.init(children, opts)
  end
end
