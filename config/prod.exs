use Mix.Config

config :rover,
  http_port: String.to_integer(System.get_env("PORT")),
  rover_supervisor: RoverSupervisor,
  world_width: 1000,
  world_height: 1000
