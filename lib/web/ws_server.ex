defmodule Rover.Web.WsServer do
  @behaviour :cowboy_websocket_handler
  @timeout 5 * 60000
  @registration_key "ws_server"

  def send_message_to_client(rover, message) do
    Rover.Application.dispatch("#{@registration_key}_#{rover}", message)
  end

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    {rover, _} = :cowboy_req.qs_val(<<"rover">>, req)
    {:ok, _} = Registry.register(Rover.Registry, "#{@registration_key}_#{rover}", [])
    state = %{}
    {:ok, req, state, @timeout}
  end

  # Handle 'ping' messages from the browser - reply
  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  def websocket_handle({:text, message}, req, state) do
    %{"n" => name, "c" => command} = Poison.decode!(message)
    RoverController.send_command(name, String.to_atom(command))
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
