defmodule Mars.Rover do
  use GenServer

  def start_link([id, {x, y}]) do
    GenServer.start_link(__MODULE__, [id, {x, y}], name: {:via, :global, id})
  end

  def init([id, {x, y}]) do
    {:ok, %{id: id, pos: {x, y}, move_count: 0}}
  end

  def get_state(id) do
    GenServer.call({:via, :global, id}, :get_state)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
