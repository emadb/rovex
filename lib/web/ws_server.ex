defmodule Rover.Web.WsServer do


  @behaviour :cowboy_websocket_handler
  @timeout 60000 # terminate if no activity for one minute
  @registration_key "ws_server"

  def send_message_to_client(message) do
    Rover.Application.dispatch(@registration_key, message)
  end

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    #{:ok, _} = RegistryHelper.register(@registration_key)
    {:ok, _} = Registry.register(Rover.Registry, @registration_key, [])
    state = %{}
    {:ok, req, state, @timeout}
  end

  # Handle 'ping' messages from the browser - reply
  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, _message}, req, state) do
    {:ok, req, state}
  end

  def websocket_info(message, req, state) do
    msg = Poison.encode!(message)
    {:reply, {:text, msg}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
