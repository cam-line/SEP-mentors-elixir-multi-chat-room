defmodule MultiRoomChat.Message do
  @moduledoc """
  Represents a message in the chat system.
  """

  defstruct [:sender, :content, :timestamp]
end
