defmodule RoverFactoryStub do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: RoverFactoryStub)
  end

  def init(args) do
    {:ok, args}
  end

  def kill(_name) do

  end
end
