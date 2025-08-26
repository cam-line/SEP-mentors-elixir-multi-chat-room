defmodule MultiRoomChat.WorkerSupervisor do
  use DynamicSupervisor
  @moduledoc """
  DynamicSupervisor for chat room worker processes.
  """

  def start_link(chat_room_supervisor, {_,_,_} = mfa) do
    DynamicSupervisor.start_link(__MODULE__, [chat_room_supervisor, mfa])
  end

  def init([chat_room_supervisor, {m,f,a}]) do
    Process.link(chat_room_supervisor)
    # children = [
    #   %{
    #     id: m,
    #     start: {m, f, a},
    #     restart: :temporary,
    #     shutdown: 500
    #   }
    # ]
    # opts = [strategy: :one_for_one,
    #         max_restarts: 5,
    #         max_seconds: 5]
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
