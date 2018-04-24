defmodule WorldMap do
  use GenServer

  def start_link(rover_factory) do
    GenServer.start_link(__MODULE__, [rover_factory], name: WorldMap)
  end

  def init([rover_factory]) do
    {:ok, %{rover_factory: rover_factory, rovers: []} }
  end

  def update_rover(name, x, y) do

    IO.inspect name, label: "UPDATE"

    GenServer.call(__MODULE__, {:update_rover, name, x, y})
  end


  def handle_call({:update_rover, name, x, y}, _from, state) do
    new_rovers = case Enum.find_index(state.rovers, fn r -> r.name == name end) do
      nil -> state.rovers ++ [%{name: name, x: x, y: y}]
      index -> List.replace_at(state.rovers, index, %{name: name, x: x, y: y})
    end

    ## cerca duplicati
    collision = Enum.filter(new_rovers, fn r -> r.name != name && r.x == x && r.y == y end)

    if Enum.count(collision) > 0 do
      ## uccidi duplicati
      new_rovers
        |> Enum.filter(fn r -> r.x == x && r.y == y end)
        |> Enum.each(fn r ->
            IO.inspect r, label: "KILL"
            state.rover_factory.kill(r.name)
          end)

      ## rimuovi duplicati dalla lista
      new_rovers = Enum.reject(new_rovers, fn r -> r.x == x && r.y == y end)
    end

    {:reply, :ok, %{state | rovers: new_rovers}}
  end


end
