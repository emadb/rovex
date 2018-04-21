defmodule Rover.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, Rover.Registry]),
      Plug.Adapters.Cowboy.child_spec(:http, Rover.Web.Router, [], port: 3000, dispatch: dispatch()),
      %{
        id: RoverFactory,
        start: {RoverFactory, :start_link, [[]]}
      }
    ]

    opts = [strategy: :one_for_one, name: Rover.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws", Rover.Web.WsServer, []},
         {:_, Plug.Adapters.Cowboy.Handler, {Rover.Web.Router, []}}
       ]}
    ]
  end

end
