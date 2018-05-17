defmodule RoverSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_rover(name, x, y, direction) do
    DynamicSupervisor.start_child(__MODULE__, {Rover, {x, y, direction, name}})
  end

  def kill(rover) do
    pid = RegistryHelper.get_pid(rover.name)
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end
