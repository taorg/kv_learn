defmodule KV.Chat.Server do
  use GenServer
  @chat_server_registry_name :chat_server_process_registry
  # API

  def start_link(map) do
    GenServer.start_link(__MODULE__, [map], name: via_tuple(map))
  end

  # registry lookup handler
  def via_tuple(%{user: user, room: room}),
    do: {:via, Registry, {@chat_server_registry_name, {user, room}}}

  def add_message(map, message) do
    GenServer.cast(via_tuple(map), {:add_message, message})
  end

  def get_messages(map) do
    GenServer.call(via_tuple(map), :get_messages)
  end

  # SERVER

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, new_message}, messages) do
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end
