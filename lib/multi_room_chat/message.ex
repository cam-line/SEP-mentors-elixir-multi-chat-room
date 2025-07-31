defmodule MultiRoomChat.Message do
  @moduledoc """
  Represents a message in the chat system.
  """

  defstruct [
    :sender,
    :content,
    :timestamp
  ]

  def format(%__MODULE__{sender: s, content: c, timestamp: t}) do
    "[#{t}] #{s}: #{c}"
  end
end
