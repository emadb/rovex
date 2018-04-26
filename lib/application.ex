defmodule Rover.Application do
  use Application

  @rover_factory Application.get_env(:rover, :rover_factory)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, Rover.Registry]),
      Plug.Adapters.Cowboy.child_spec(:http, Rover.Web.Router, [], port: 3000, dispatch: dispatch()),
      %{id: @rover_factory, start: {@rover_factory, :start_link, [[]]}},
      worker(WorldMap, [@rover_factory])
    ]

    opts = [strategy: :one_for_one, name: Rover.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def dispatch(key, message) do
    Registry.dispatch(Rover.Registry, key, fn entries ->
      for {pid, _} <- entries do
        send(pid, message)
      end
    end)
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
