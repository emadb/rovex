defmodule Rover.Application do
  use Application

  @rover_supervisor Application.get_env(:rover, :rover_supervisor)
  @http_port Application.get_env(:rover, :http_port)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Registry, [:unique, Rover.Registry]),
      Plug.Adapters.Cowboy.child_spec(
        :http,
        Rover.Web.Router,
        [],
        port: @http_port,
        dispatch: dispatch()
      ),
      %{id: @rover_supervisor, start: {@rover_supervisor, :start_link, [[]]}},
      worker(WorldMap, [@rover_supervisor])
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
