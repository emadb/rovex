defmodule MainRouter do
  alias Mars.RoverSup
  use Plug.Router

  plug(
    Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, Jason.encode!(%{message: "pong"}))
  end

  post "/rover" do
    %{
      "id" => id,
      "x" => x,
      "y" => y
    } = conn.body_params

    {:ok, _} =
      RoverSup.create_rover(id, {x, y})

    send_resp(conn, 201, Jason.encode!(%{message: "rover created"}))
  end

  match(_, do: send_resp(conn, 404, "Not found"))
end
