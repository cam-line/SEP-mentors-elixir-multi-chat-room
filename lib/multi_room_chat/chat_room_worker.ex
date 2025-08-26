defmodule MultiRoomChat.ChatRoomWorker do
  use GenServer
  @moduledoc """
  Worker process for handling per-user or per-message tasks in a chat room.
  """

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    {:ok, args}
  end
end
