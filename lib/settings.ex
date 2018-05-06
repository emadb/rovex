defmodule Settings do

  def get_port do
    port = case System.get_env("PORT") do
      nil -> Application.get_env(:rover, :http_port, "3000")
      p -> p
    end
    String.to_integer(port)
  end

end
