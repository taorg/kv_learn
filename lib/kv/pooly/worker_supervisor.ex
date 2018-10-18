defmodule Kv.Pooly.WorkerSupervisor do
  use Supervisor
  require Logger

  @moduledoc """
   WorkerSuervisor implementation
  """
  ###############
  # API API API #
  ###############
  def start_link({_, _, _} = mfa) do
    Supervisor.start_link(__MODULE__, mfa, name: __MODULE__)
  end

  #######################
  # CALLBACKS CALLBACKS #
  #######################
  @impl true
  def init({m, f, a} = mfa) do
    # worker_opts = [id: m, start: f, restart: :permanent]
    # children = [worker(m, a, worker_opts)]
    children = [
      worker(
        Kv.Pooly.SampleWorker,
        [self(), mfa: {SampleWorker, :start_link, []}, size: 5]
      )
    ]

    options = [strategy: :simple_one_for_one, max_restarts: 5, max_seconds: 5]
    Logger.debug("children: #{inspect(children)}")
    Logger.debug("mfa: #{inspect(mfa)}")
    supervise(children, options)
  end
end
