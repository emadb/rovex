
defmodule Rover.Web.Router do
  use Plug.Router

  # plug Corsica, max_age: 600, origins: "*"
  # plug PlugBasicAuth,
  #   username: Application.get_env(:api, :basic_auth_user),
  #   password: Application.get_env(:api, :basic_auth_password)

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/ping" do
    send_resp(conn, 200, encode(%{message: "pong"}))
  end

  post "/rover" do
    rover_name = conn.body_params["name"]
    x = conn.body_params["x"]
    y = conn.body_params["y"]
    d = String.to_atom(conn.body_params["d"])
    {:ok, _} = RoverController.create_rover(rover_name, x, y, d)
    send_resp(conn, 201, encode(%{message: "created rover #{rover_name}"}))
  end

  post "/command" do
    rover_name = conn.body_params["name"]
    command = String.to_atom(conn.body_params["command"])
    {:ok, {x, y, d}} = RoverController.send_command(rover_name, command)
    send_resp(conn, 201, encode(%{x: x, y: y, d: d}))
  end

  post "/simulator" do
    count = conn.body_params["count"]
    RoverController.create_multiple_rovers(count)
    RoverController.send_multiple_commands(count)
    send_resp(conn, 201, encode(%{}))
  end

  defp encode(data) do
    Poison.encode!(data)
  end

  match(_) do
    send_resp(conn, 404, "")
  end

end

