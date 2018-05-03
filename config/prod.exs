use Mix.Config

config :rover,
  http_port: {:system, "PORT"},
  rover_supervisor: RoverSupervisor,
  world_width: 1000,
  world_height: 1000
