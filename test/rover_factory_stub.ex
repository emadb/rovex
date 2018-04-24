defmodule RoverFactoryStub do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: RoverFactoryStub)
  end

  def kill(name) do
    IO.inspect name, label: "Killing"
  end
end
