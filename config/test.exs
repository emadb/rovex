use Mix.Config

config :rover,
  http_port: 3000,
  rover_factory: RoverFactoryStub,
  world_width: 10,
  world_height: 10
