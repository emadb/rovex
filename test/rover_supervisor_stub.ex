defmodule RoverSupervisorStub do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: RoverSupervisorStub)
  end

  def init(args) do
    {:ok, args}
  end

  def kill(name) do
    IO.puts "killing #{name}"
  end
end
