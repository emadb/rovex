use Mix.Config

config :rover,
  http_port: String.to_integer(System.get_env("PORT"))
