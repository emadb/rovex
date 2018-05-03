use Mix.Config

config :rover,
  http_port: 80,
  rover_supervisor: RoverSupervisorStub,
  world_width: 1000,
  world_height: 1000
