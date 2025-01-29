defmodule Mars.World do
  use GenServer

  def start_link(items) do
    GenServer.start_link(__MODULE__, items, name: __MODULE__)
  end

  def init(items) do
    {:ok, items}
  end

  def pick({x, y}) do
    GenServer.call(__MODULE__, {:pick, {x, y}})
  end

  def handle_call({:pick, {x, y}}, _from, state) do
    case Enum.find(state, fn {ix, iy} -> {ix, iy} == {x, y} end) do
      {_, _} ->
        new_state = Enum.reject(state, fn {ix, iy} -> {ix, iy} == {x, y} end)
        {:reply, :found, new_state}

      nil ->
        {:reply, :not_found, state}
    end
  end
end
