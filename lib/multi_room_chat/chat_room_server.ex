defmodule MultiRoomChat.ChatRoomServer do
  use GenServer
  import Supervisor.Spec
  @moduledoc """
  GenServer responsible for managing chat room state (users, messages, etc).
  """

  defmodule State do
    defstruct chat_room_sup: nil, worker_sup: nil, monitors: nil, size: nil,
     workers: nil, name: nil, mfa: nil
  end

  # API
  def start_link([chat_room_sup, room_config]) do
    GenServer.start_link(__MODULE__, [chat_room_sup, room_config], name: String.to_atom(room_config[:name]))
  end

  def checkout(room_name) do
    GenServer.call(name(room_name), :checkout)
  end

  def checkin(room_name, worker_pid) do
    GenServer.cast(name(room_name), {:checkin, worker_pid})
  end

  def status(room_name) do
    Genserver.call(name(room_name), :status)
  end

  ## TODO copilot generated, match with your api
  # def join(room, user) do
  #   GenServer.cast(room, {:join, user})
  # end

  # def leave(room, user) do
  #   GenServer.cast(room, {:leave, user})
  # end

  # def send_message(room, message) do
  #   GenServer.cast(room, {:send_message, message})
  # end

  # def get_users(room) do
  #   GenServer.call(room, :get_users)
  # end

  # def get_messages(room) do
  #   GenServer.call(room, :get_messages)
  # end

  # Needed?
  # defp via_tuple(room_name) do
  #   {:via, Registry, {MultiRoomChat.RoomRegistry, room_name}}
  # end

  # Callbacks (to be implemented)
  def init([chat_room_sup, room_config]) when is_pid(chat_room_sup) do
    Process.flag(:trap_exit, true)
    monitors = :ets.new(:monitors, [:private])
    init(room_config, %State{chat_room_sup: chat_room_sup, monitors: monitors})
  end
  def init([{:name, name}|rest], state) do
    init(rest, %{state | name: name})
  end
  def init([{:mfa, mfa}|rest], state) do
    init(rest, %{state | mfa: mfa})
  end
  def init([{:size, size}|rest], state) do
    init(rest, %{state | size: size})
  end
  def init([_|rest], state) do
    init(rest, state)
  end
  def init([], state) do
    send(self(), :start_worker_supervisor)
    {:ok, state}
  end

  def handle_call(:checkout, {from_pid, ref}, %{workers: workers, monitors: monitors} = state) do
    case workers do
      [worker|rest] ->
        Process.monitor(from_pid)
        true = :ets.insert(monitors, {worker, ref})
        {:reply, worker, %{state | workers: rest}}
      [] ->
        {:reply, :noproc, state}
      end
  end

  def handle_call(:status, _from, %{workers: workers, monitors: monitors} = state) do
    {:reply, {length(workers), :ets.info(monitors, :size)}, state}
  end

  def handle_cast({:checkin, worker}, %{workers: workers, monitors: monitors} = state) do
    case :ets.lookup(monitors, worker) do
      [{pid, ref}] ->
        true = Process.demonitor(ref)
        true = :ets.delete(monitors, pid)
        {:noreply, %{state | workers: [pid|workers]}}
      [] ->
        {:noreply, state}
      end
  end

  def handle_info(:start_worker_supervisor, state = %{chat_room_sup: chat_room_sup, name: name, mfa: mfa, size: size}) do
    {:ok, worker_sup} = Supervisor.start_child(chat_room_sup, supervisor_spec(name, mfa))
    workers = prepopulate(size, worker_sup)
    {:noreply, %{state | worker_sup: worker_sup, workers: workers}}
  end

  ## TODO error handling

  # private
  defp name(room_name) do
    :"#{room_name}Server"
  end

  defp prepopulate(size, sup) do
    prepopulate(size, sup, [])
  end
  defp prepopulate(size, _sup, workers) when size < 1 do
    workers
  end
  defp prepopulate(size, sup, workers) do
    prepopulate(size-1, sup, [new_worker(sup) | workers])
  end

  defp new_worker(worker_sup) do
    {:ok, worker} = DynamicSupervisor.start_child(worker_sup, {MultiRoomChat.ChatRoomWorker, []})
  end

  defp supervisor_spec(name, mfa) do
    # opts = [id: name <> "WorkerSupervisor", restart: :temporary]
    # supervisor(MultiRoomChat.WorkerSupervisor, [self(), mfa], opts)
    ## TODO is this right??
    %{
      id: String.to_atom(name <> "WorkerSupervisor"),
      start: {MultiRoomChat.WorkerSupervisor, :start_link, [self(), mfa]},
      type: :supervisor,
      restart: :temporary,
      shutdown: 5000
    }
  end


end
