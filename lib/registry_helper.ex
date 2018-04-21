defmodule RegistryHelper do
  def create_key(name), do: {:via, Registry, {Rover.Registry, name}}

  def register(name), do: Registry.register(Rover.Registry, create_key(name), [])

  def get_pid(name) do
    [{pid, _}] = Registry.lookup(Rover.Registry, create_key(name))
    pid
  end
end
