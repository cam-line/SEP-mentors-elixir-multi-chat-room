defmodule MultiRoomChat.User do
  @moduledoc """
  Represents a user in the chat system.
  Tracks the user's name and last visited time per room.
  """

  defstruct [
    :name,                # String, the user's display name
    :last_visited_rooms   # Map, %{room_name => timestamp}
  ]

  @type t :: %__MODULE__{
    name: String.t(),
    last_visited_rooms: %{optional(String.t()) => DateTime.t()}
  }

  @doc """
  Creates a new user with the given name.
  """
  def new(name) when is_binary(name) do
    %__MODULE__{name: name, last_visited_rooms: %{}}
  end

  @spec visit_room(MultiRoomChat.User.t(), binary(), map()) :: MultiRoomChat.User.t()
  @doc """
  Updates the last visited time for a room.
  """
  def visit_room(%__MODULE__{last_visited_rooms: rooms} = user, room_name, datetime) when is_binary(room_name) and is_struct(datetime, DateTime) do
    %{user | last_visited_rooms: Map.put(rooms, room_name, datetime)}
  end

  @doc """
  Gets the last visited time for a room, or nil if never visited.
  """
  def last_visited(user, room_name) when is_binary(room_name) do
    Map.get(user.last_visited_rooms, room_name)
  end
end
