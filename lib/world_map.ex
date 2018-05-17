defmodule WorldMap do
  use GenServer
  @rover_supervisor Application.get_env(:rover, :rover_supervisor)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: WorldMap)
  end

  def init([]) do
    {:ok, %{rovers: []}}
  end

  @spec update_rover(String.t, integer, integer) :: :ok
  def update_rover(name, x, y) do
    GenServer.call(__MODULE__, {:update_rover, name, x, y})
  end

  defp update_rover_list(rovers, name, x, y) do
      case Enum.find_index(rovers, fn r -> r.name == name end) do
        nil -> rovers ++ [%{name: name, x: x, y: y}]
        index -> List.replace_at(rovers, index, %{name: name, x: x, y: y})
      end
  end

  def handle_call({:update_rover, name, x, y}, _from, state) do
    rover_list = update_rover_list(state.rovers, name, x, y)

    case Enum.find(rover_list, fn r -> r.name != name && r.x == x && r.y == y end) do
      nil ->
        {:reply, :ok, %{state | rovers: rover_list}}
      rover_to_kill ->
        @rover_supervisor.kill(rover_to_kill)
        # pid = RegistryHelper.get_pid(rover_to_kill.name)
        # Process.exit(pid, :collision)
        Rover.update_score(name)
        new_rovers = List.delete(rover_list, rover_to_kill)
        {:reply, :ok, %{state | rovers: new_rovers}}
    end
  end
end
