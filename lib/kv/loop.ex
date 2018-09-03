defmodule Kv.LoopTask do
  @spec start() :: {:ok, pid()}
  def start() do
    Task.start(fn ->
      loop()
    end)
  end

  def send_stop(pid) do
    send(pid, :stop)
  end

  def stop(pid) do
    IO.inspect("Out of the loop")
    send(pid, :stop)
    Process.exit(pid, :stop)
  end

  def loop do
    IO.inspect("Into the loop")
    Process.sleep(1000)

    receive do
      :stop ->
        IO.puts("Stopping...")
        Process.sleep(100)
        exit(:shutdown)
    after
      # Optional timeout
      3_000 -> :timeout
    end

    loop()
  end
end

# with {:ok, pid} <- Kv.LoopTask.start() do
#  {:ok, pid} = Kv.LoopTask.start()
#  Kv.LoopTask.stop(pid)
#  Process.sleep(200) # to wait until task finishes
#  Process.alive?(pid) # false
# end
