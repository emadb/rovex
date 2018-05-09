defmodule Rover.Application do
  use Application

  @rover_supervisor Application.get_env(:rover, :rover_supervisor)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Supervisor.child_spec({Registry, [keys: :unique, name: Rover.Registry]}, id: :rover_registry),
      Supervisor.child_spec({Registry, [keys: :duplicate, name: Socket.Registry]}, id: :socket_registry),

      Plug.Adapters.Cowboy.child_spec(
        :http,
        Rover.Web.Router,
        [],
        port: Settings.get_port(),
        dispatch: dispatch()
      ),
      %{id: @rover_supervisor, start: {@rover_supervisor, :start_link, [[]]}},
      worker(WorldMap, [@rover_supervisor])
    ]

    opts = [strategy: :one_for_one, name: Rover.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def dispatch(key, message) do
    Registry.dispatch(Socket.Registry, key, fn entries ->
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
