defmodule Kv.Pooly.SampleWorker do
  use GenServer
  require Logger

  @moduledoc """
    Sample GenServer implementation

    alias Kv.Pooly.{WorkerSupervisor,SampleWorker}
    {:ok, worker_sup} = WorkerSupervisor.start_link({Kv.Pooly.SampleWorker, :start_link, []})
    Supervisor.which_children(worker_sup)
    Supervisor.start_child(worker_sup,[[]])
    Supervisor.which_children(worker_sup)
    {:ok, worker_pid} = Supervisor.start_child(worker_sup,[SampleWorker,[]])
    Supervisor.which_children(worker_sup)
  """
  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  @impl true
  def init(args) do
    Logger.debug("args: #{inspect(args)}")
    {:ok, args}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end
end
