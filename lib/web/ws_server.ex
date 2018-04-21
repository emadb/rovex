defmodule Rover.Web.WsServer do
  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts), do: {:upgrade, :protocol, :cowboy_websocket}

  def websocket_init(_type, req, _opts) do
    {:ok, req, %{}, 5000}
  end

  def websocket_handle({:text, "ping"}, req, state) do
    IO.puts("PONG")
    {:reply, {:text, Poison.encode!("pong")}, req, state}
  end

  def websocket_handle({:text, _message}, req, state), do: {:ok, req, state}

  def websocket_info(message, req, state) do
    msg = Poison.encode!(message)
    {:reply, {:text, msg}, req, state}
  end

  def websocket_terminate(_reason, _req, _state), do: :ok

end
