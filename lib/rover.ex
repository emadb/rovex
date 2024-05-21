defmodule Mars.Rover do
  use GenServer

  def start_link([id, {x, y}]) do
    GenServer.start_link(__MODULE__, [id, {x, y}])
  end

  def init([id, {x, y}]) do
    {:ok, %{id: id, pos: {x, y}, move_count: 0}}
  end

  def get(pid) do
    GenServer.call(pid, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
