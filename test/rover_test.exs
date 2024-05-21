defmodule RoverTest do
  use ExUnit.Case
  alias Mars.Rover

  test "start the rover" do
    {:ok, pid} = Rover.start_link([1, {1, 1}])
    assert(Process.alive?(pid))
  end

  test "get rover state" do
    {:ok, _} = start_supervised({Rover, [1, {1, 1}]})
    assert %{id: 1, pos: {1, 1}, move_count: 0} == Rover.get_state(1)
  end
end
