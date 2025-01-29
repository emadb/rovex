defmodule Mars.Application do
  use Application

  @impl true
  def start(_type, _args) do
    coords =
      1..50000
      |> Enum.map(fn _ -> {Enum.random(1..1000), Enum.random(1..1000)} end)
      |> Enum.dedup()

    children = [
      {Mars.RoverSup, []},
      {Mars.World, coords},
      {Phoenix.PubSub, name: :rover_pubsub}
    ]

    opts = [strategy: :one_for_one, name: Mars.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
