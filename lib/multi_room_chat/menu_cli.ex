defmodule MultiRoomChat.CLI do
  def start do
    IO.puts("""
   __  __ _____ ____    _       ____ _   _    _  _____
|  \/  | ____/ ___|  / \     / ___| | | |  / \|_   _|
| |\/| |  _|| |  _  / _ \   | |   | |_| | / _ \ | |
| |  | | |__| |_| |/ ___ \  | |___|  _  |/ ___ \| |
|_|  |_|_____\____/_/   \_\  \____|_| |_/_/   \_\_|
    """)
    user = login()
    main_menu(user)
  end

  def login do
    IO.gets("Please enter your username: ") |> String.trim() |> MultiRoomChat.User.new()
  end

  def main_menu(user) do
    IO.puts("""
    Menu:
    1. List available rooms
    2. List joined rooms
    3. Create room
    4. Join room
    q. Quit
    """)
    case IO.gets("Choose an option: ") |> String.trim() do
      "1" -> list_rooms(user)
      "2" -> list_my_rooms(user)
      "3" -> create_room(user)
      "4" -> join_room(user)
      "q" -> quit()
      _ -> IO.puts("Invalid option :("); main_menu(user)
    end
  end

  def list_rooms(user) do
    rooms = MultiRoomChat.Server.list_rooms()
    Enum.each(rooms, fn room ->
        IO.puts("#{inspect(room)}")
      end)
    main_menu(user)
  end

  def list_my_rooms(user) do
    # TODO: Implement listing of rooms the user has joined
    main_menu(user)
  end

  def create_room(user) do
    room_name = IO.gets("Enter room name: ") |> String.trim()
    room_description = IO.gets("Enter room description: ") |> String.trim()

    case MultiRoomChat.Server.create_room(user, room_name, room_description) do
      :ok ->
        IO.puts("Room '#{room_name}' created successfully.")
      _ ->
        IO.puts("Failed to create room.")
    end

    main_menu(user)
  end

  def join_room(user) do
    room_name = IO.gets("Enter room name to join: ") |> String.trim()
    case MultiRoomChat.Server.join_room(user, room_name) do
      :ok ->
        IO.puts("Joined room '#{room_name}'.")
      _ ->
        IO.puts("Failed to join room.")
    end
    main_menu(user)
  end

  def quit do
    IO.puts("Bye!")
    System.halt(0)
  end
end
