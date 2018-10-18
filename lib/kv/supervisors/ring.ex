defmodule Kv.Supervisors.Ring do
  require Logger

  @moduledoc """
  c "lib/kv/supervisors/ring.ex"
  pids = Kv.Supervisors.Ring.create_processes(5)
  Kv.Supervisors.Ring.link_processes(pids)
  [p1,p2,p3,p4,p5] = pids
  send(p1,:trap_exit)
  send(p2,:trap_exit)
  pids |> Enum.map(fn pid -> {pid,Process.alive?(pid)} end)
  pids |> Enum.shuffle() |> List.first() |> send(:crash)
  pids |> Enum.map(fn pid -> {pid,Process.alive?(pid)} end)

  -----------------------------------------------------------
  -----------------------------------------------------------
  pid = spawn(fn -> receive do :crash -> 1/0 end end)
  Process.monitor(pid)
  Process.alive?(pid)
  send(pid, :crash)
  Process.alive?(pid)
  flush

  -----------------------------------------------------------
  -----------------------------------------------------------
  pid = spawn(fn -> receive do :crash -> 1/0 end end)
  Process.monitor(pid)
  Process.alive?(pid)
  Process.exit(pid, :kill)
  Process.alive?(pid)
  flush

  """
  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop() end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()

      :trap_exit ->
        Process.flag(:trap_exit, true)

      :crash ->
        1 / 0
    end
  end

  def link_processes(procs) do
    link_processes(procs, [])
  end

  def link_processes([proc_1, proc_2 | rest], linked_processes) do
    send(proc_1, {:link, proc_2})
    link_processes([proc_2 | rest], [proc_1 | linked_processes])
  end

  def link_processes([proc | []], link_processes) do
    first_process = link_processes |> List.last()
    send(proc, {:link, first_process})
    :ok
  end
end
