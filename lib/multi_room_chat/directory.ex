defmodule MultiRoomChat.Directory do
  @moduledoc """
  Manages the chat room directory.
  """

  defstruct rooms: %{}

  @type t :: %__MODULE__{
    rooms: %{optional(String.t()) => pid()}
  }

  def start_link(_) do
    Agent.start_link(fn -> %__MODULE__{} end)
  end

  def create_room(directory, name, description) do
    Agent.get_and_update(directory, fn state ->
      if Map.has_key?(state.rooms, name) do
        {:error, state}
      else
        {:ok, room} = ChatRoom.start_link({name, description})
        new_rooms = Map.put(state.rooms, name, room)
        {:ok, %{state | rooms: new_rooms}}
      end
    end)
  end

  def get_room(directory, name) do
    Agent.get(directory, fn state ->
      Map.get(state.rooms, name)
    end)
  end

  def list_rooms(directory) do
    Agent.get(directory, fn state ->
      Map.keys(state.rooms)
    end)
  end
end
