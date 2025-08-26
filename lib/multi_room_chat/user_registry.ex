defmodule MultiRoomChat.UserRegistry do
  use GenServer

  # API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Add more API functions as needed

  # Callbacks
  def init(state) do
    {:ok, state}
  end
end
