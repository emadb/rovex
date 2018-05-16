defmodule WorldMap do
  use GenServer

  def start_link(rover_supervisor) do
    GenServer.start_link(__MODULE__, [rover_supervisor], name: WorldMap)
  end

  def init([rover_supervisor]) do
    {:ok, %{rover_supervisor: rover_supervisor, rovers: []}}
  end

  @spec update_rover(String.t, integer, integer) :: :ok
  def update_rover(name, x, y) do
    GenServer.call(__MODULE__, {:update_rover, name, x, y})
  end

  def handle_call({:update_rover, name, x, y}, _from, state) do
    new_rovers =
      case Enum.find_index(state.rovers, fn r -> r.name == name end) do
        nil -> state.rovers ++ [%{name: name, x: x, y: y}]
        index -> List.replace_at(state.rovers, index, %{name: name, x: x, y: y})
      end

    same_position = same_position_fn(name, x, y)
    case Enum.any?(new_rovers, same_position) do
      true ->
        new_rovers
        |> Enum.find(same_position)
        |> state.rover_supervisor.kill

        Rover.update_score(name)
        new_rovers = Enum.reject(new_rovers, same_position)
        {:reply, :ok, %{state | rovers: new_rovers}}

      false ->
        {:reply, :ok, %{state | rovers: new_rovers}}
    end
  end

  defp same_position_fn(name, x, y) do
    fn r -> r.name != name && r.x == x && r.y == y end
  end

end
