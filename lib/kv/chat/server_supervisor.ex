defmodule KV.Chat.ServerSupervisor do
  use Supervisor
  @chat_server_registry_name :chat_server_process_registry
  @dev_srv KV.Chat.Server
  @moduledoc """
  KV.Chat.ServerSupervisor.start_link(%{user: "user1", room: "room1"})
  KV.Chat.ServerSupervisor.start_room(%{user: "user1", room: "room2"})
  KV.Chat.ServerSupervisor.account_process_rooms
  Registry.lookup(:chat_server_process_registry, {"user1", "room1"})
  Registry.lookup(:chat_server_process_registry, {"user1", "room2"})
  KV.Chat.Server.add_message(%{user: "user1", room: "room1"}, "message2-{user1, room1}")
  KV.Chat.Server.add_message(%{user: "user1", room: "room1"}, "message2-{user2, room2}")
  KV.Chat.Server.get_messages(%{user: "user1", room: "room1"})
  """

  def start_link(map) do
    Supervisor.start_link(__MODULE__, [map], name: __MODULE__)
  end

  def start_room(%{user: user, room: room} = map) do
    # And we use `start_child/2` to start a new Chat.Server process
    with {:ok, _pid} <-
           Supervisor.start_child(__MODULE__, worker(@dev_srv, [map], id: {user, room})) do
      {:ok, {user, room}}
    else
      {:error, error} -> {:error, error}
    end
  end

  @spec account_process_rooms() :: [
          {any(), :restarting | :undefined | pid(), :supervisor | :worker, any()}
        ]
  def account_process_rooms, do: Supervisor.which_children(__MODULE__)

  def init([%{user: user, room: room} = map]) do
    children = [
      worker(Registry, [:unique, @chat_server_registry_name]),
      worker(@dev_srv, [map], id: {user, room})
    ]

    supervise(children, strategy: :one_for_one)
  end
end
