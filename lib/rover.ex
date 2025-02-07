defmodule Mars.Rover do
  use GenServer

  def start_link([id, {x, y}, dir]) when dir in [:north, :south, :east, :west] do
    GenServer.start_link(__MODULE__, [id, {x, y}, dir], name: {:via, :global, id})
  end

  def start_link([id, {x, y}]) do
    start_link([id, {x, y}, :north])
  end

  def init([id, {x, y}, dir]) do
    IO.inspect(id, label: "Starting")

    {:ok, %{id: id, pos: {x, y}, direction: dir, move_count: 0, points: 0},
     {:continue, :post_init}}
  end

  def get_state(id) do
    GenServer.call({:via, :global, id}, :get_state)
  end

  def send(id, cmd) when is_list(cmd) do
    GenServer.call({:via, :global, id}, {:send, cmd})
  end

  def send(id, cmd) do
    GenServer.call({:via, :global, id}, {:send, [cmd]})
  end

  def handle_continue(:post_init, state) do
    Process.send_after(self(), :explore, Enum.random(1000..3000))
    {:noreply, state}
  end

  def handle_info(:explore, state) do
    Process.send_after(self(), :explore, Enum.random(1000..3000))

    new_state =
      ["L", "R", "F", "B"]
      |> Enum.random()
      |> then(fn c -> move([c], state) end)

    crash? = Enum.random(1..10) == 1

    if crash? do
      {:stop, :crashed, new_state}
    else
      {:noreply, new_state}
    end
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:send, cmd}, _from, state) do
    new_state = move(cmd, state)

    {:reply, :ok, new_state}
  end

  def terminate(_reason, _state) do
  end

  defp move(cmd, state) do
    new_state =
      Enum.reduce(cmd, state, fn c, acc ->
        acc
        |> Map.merge(apply_command(c, acc))
        |> Map.merge(%{move_count: acc.move_count + 1})
      end)

    case Mars.World.pick(new_state.pos) do
      :found ->
        Phoenix.PubSub.broadcast(:rover_pubsub, "points", %{
          id: state.id,
          points: state.points + 1
        })

        %{new_state | points: state.points + 1}

      :not_found ->
        new_state
    end
  end

  defp apply_command(cmd, %{pos: {x, y}, direction: direction}) do
    %{
      pos: move(cmd, direction, {x, y}),
      direction: rotate(cmd, direction)
    }
  end

  defp move("F", :north, {x, y}), do: {x, y - 1}
  defp move("F", :south, {x, y}), do: {x, y + 1}
  defp move("F", :east, {x, y}), do: {x + 1, y}
  defp move("F", :west, {x, y}), do: {x - 1, y}

  defp move("B", :north, {x, y}), do: {x, y + 1}
  defp move("B", :south, {x, y}), do: {x, y - 1}
  defp move("B", :east, {x, y}), do: {x - 1, y}
  defp move("B", :west, {x, y}), do: {x + 1, y}
  defp move(cmd, _, {x, y}) when cmd in ["L", "R"], do: {x, y}

  defp rotate("L", :north), do: :west
  defp rotate("L", :west), do: :south
  defp rotate("L", :south), do: :east
  defp rotate("L", :east), do: :north

  defp rotate("R", :north), do: :east
  defp rotate("R", :west), do: :north
  defp rotate("R", :south), do: :west
  defp rotate("R", :east), do: :south
  defp rotate(cmd, dir) when cmd in ["F", "B"], do: dir
end
