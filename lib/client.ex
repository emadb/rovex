defmodule Client do
  def create_rovers(n) do
    Enum.map(1..n, &Mars.RoverSup.create_rover(&1, {Enum.random(1..1000), Enum.random(1..1000)}))
  end

  def move_all(n) do
    Enum.map(1..n, &Mars.Rover.send(&1, Enum.random(["L", "R", "F", "B"])))
  end
end
