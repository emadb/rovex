
defmodule Rover.Web.Router do
  use Plug.Router

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug Plug.Static, at: "/", from: :server
  plug :match
  plug :dispatch

  get "/ping" do
    send_resp(conn, 200, encode(%{message: "pong"}))
  end

  get "/" do
    conn = put_resp_content_type(conn, "text/html")
    send_file(conn, 200, "priv/static/index.html")
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
    RoverController.send_command(rover_name, command)
    send_resp(conn, 204, encode(%{}))
  end

  post "/simulator" do
    rover_count = conn.body_params["rover_count"]
    command_count = conn.body_params["command_count"]
    RoverController.create_multiple_rovers(rover_count)
    RoverController.send_multiple_commands(rover_count, command_count)
    send_resp(conn, 201, encode(%{message: "running"}))
  end

  defp encode(data) do
    Poison.encode!(data)
  end

  match(_) do
    send_resp(conn, 404, "")
  end

end

