defmodule Mars.RoverSup do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_rover(id, {x, y}) do
    DynamicSupervisor.start_child(__MODULE__, {Mars.Rover, [id, {x, y}]})
  end
end
