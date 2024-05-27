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

  def handle_call({:send, cmd}, _from, state) do
    %{pos: {x, y}, move_count: count, direction: direction} = state

    new_state = %{
      state
      | pos: move(cmd, direction, {x, y}),
        direction: rotate(cmd, direction),
        move_count: count + 1
    }

    {:reply, :ok, new_state}
  end

  defp move("F", :north, {x, y}), do: {x, y - 1}
  defp move("F", :south, {x, y}), do: {x, y + 1}
  defp move("F", :east, {x, y}), do: {x + 1, y}
  defp move("F", :west, {x, y}), do: {x - 1, y}

  defp move("B", :north, {x, y}), do: {x, y + 1}
  defp move("B", :south, {x, y}), do: {x, y - 1}
  defp move("B", :east, {x, y}), do: {x - 1, y}
  defp move("B", :west, {x, y}), do: {x + 1, y}

  defp rotate("L", :north), do: :west
  defp rotate("L", :west), do: :south
  defp rotate("L", :south), do: :east
  defp rotate("L", :east), do: :north

  defp rotate("R", :north), do: :east
  defp rotate("R", :west), do: :north
  defp rotate("R", :south), do: :west
  defp rotate("R", :east), do: :south
  defp rotate(_, dir), do: dir
end
