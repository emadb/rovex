defmodule Mars.Rover do
  use GenServer

  def start_link([id, {x, y}]) do
    GenServer.start_link(__MODULE__, [id, {x, y}], name: {:via, :global, id})
  end

  def init([id, {x, y}]) do
    {:ok, %{id: id, pos: {x, y}, direction: :north, move_count: 0}}
  end

  def get_state(id) do
    GenServer.call({:via, :global, id}, :get_state)
  end

  def send(id, cmd) do
    GenServer.call({:via, :global, id}, {:send, cmd})
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(
        {:send, "F"},
        _from,
        state = %{pos: {x, y}, move_count: count, direction: :north}
      ) do
    new_state = %{state | pos: {x, y - 1}, move_count: count + 1}
    {:reply, :ok, new_state}
  end
end
