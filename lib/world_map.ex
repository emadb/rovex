defmodule WorldMap do
  use GenServer

  def start_link(rover_factory) do
    GenServer.start_link(__MODULE__, [rover_factory], name: WorldMap)
  end

  def init([rover_factory]) do
    {:ok, %{rover_factory: rover_factory, rovers: []}}
  end

  def update_rover(name, x, y) do
    GenServer.call(__MODULE__, {:update_rover, name, x, y})
  end

  def handle_call({:update_rover, name, x, y}, _from, state) do
    new_rovers =
      case Enum.find_index(state.rovers, fn r -> r.name == name end) do
        nil -> state.rovers ++ [%{name: name, x: x, y: y}]
        index -> List.replace_at(state.rovers, index, %{name: name, x: x, y: y})
      end

    case are_there_collisions(new_rovers, name, x, y) do
      true ->
        new_rovers
        |> Enum.filter(&same_position(&1, x, y))
        |> Enum.each(fn r -> state.rover_factory.kill(r.name) end)

        new_rovers = Enum.reject(new_rovers, &same_position(&1, x, y))
        {:reply, :ok, %{state | rovers: new_rovers}}

      false ->
        {:reply, :ok, %{state | rovers: new_rovers}}
    end
  end

  defp same_position(r, x, y) do
    r.x == x && r.y == y
  end

  defp are_there_collisions(rovers, name, x, y) do
    Enum.any?(rovers, fn r -> r.name != name && r.x == x && r.y == y end)
  end
end
