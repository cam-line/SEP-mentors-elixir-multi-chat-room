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
    3. Quit
    """)
    case IO.gets("Choose an option: ") |> String.trim() do
      "1" -> list_rooms(user)
      "2" -> list_my_rooms(user)
      "3" -> quit()
      _ -> IO.puts("Invalid option :("); main_menu(user)
    end
  end

  def list_rooms(user) do

    main_menu(user)
  end


  def list_my_rooms(user) do

    main_menu(user)
  end

  def quit do
    IO.puts("Bye!")
    System.halt(0)
  end
end
