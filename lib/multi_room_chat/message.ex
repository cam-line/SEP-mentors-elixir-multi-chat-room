defmodule MultiRoomChat.Message do
  @moduledoc """
  Represents a message in the chat system.
  Sender is a MultiRoomChat.User struct.
  """

  defstruct [
    :sender,    # MultiRoomChat.User
    :content,
    :timestamp
  ]

  @type t :: %__MODULE__{
    sender: MultiRoomChat.User.t(),
    content: String.t(),
    timestamp: DateTime.t()
  }

  @spec format(MultiRoomChat.Message.t()) :: String.t()
  def format(%__MODULE__{sender: %MultiRoomChat.User{name: name}, content: c, timestamp: t}) do
    "[#{t}] #{name}: #{c}"
  end
end
