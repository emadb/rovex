defmodule RegistryHelper do

  @spec create_key(String.t) :: {:via, atom, {atom, String.t}}
  def create_key(name), do: {:via, Registry, {Rover.Registry, name}}

  @spec register(String.t) :: {:ok, pid} | {:error, {:already_registered, pid}}
  def register(name), do: Registry.register(Rover.Registry, create_key(name), [])

  @spec get_pid(String.t) :: pid
  def get_pid(name) do
    [{pid, _}] = Registry.lookup(Rover.Registry, name)
    pid
  end
end
