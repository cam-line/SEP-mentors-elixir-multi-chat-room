defmodule MultiRoomChat.Application do
  use Application

  def start(_type, _args) do
    children = [
      # MultiRoomChat.RoomDirectory
      {MultiRoomChat.RoomsSupervisor, []}
    ]

    rooms_config =
    [
      [name: "Room1", mfa: {MultiRoomChat.ChatRoomWorker, :start_link, []}, size: 5],
      [name: "Room2", mfa: {MultiRoomChat.ChatRoomWorker, :start_link, []}, size: 3]
    ]

    opts = [strategy: :one_for_one, name: MultiRoomChat.Supervisor]
    Supervisor.start_link(children, opts)

    start_rooms(rooms_config)
  end

  def start_rooms(rooms_config) do
    MultiRoomChat.Server.start_link(rooms_config)
  end

  def checkout(room_name) do
    MultiRoomChat.Server.checkout(room_name)
  end

  def checkin(room_name, worker_pid) do
    MultiRoomChat.Server.checkin(room_name, worker_pid)
  end

  def status(room_name) do
    MultiRoomChat.Server.status(room_name)
  end
end
