defmodule RoverIntegrationTest do
  use ExUnit.Case
  doctest Rover

  test "send a series of commands (draw a square)" do
    {:ok, _} = Rover.start_link({1, 2, :N, "rover2"})

    Rover.go_forward("rover2")
    Rover.go_forward("rover2")
    Rover.rotate_right("rover2")

    Rover.go_forward("rover2")
    Rover.go_forward("rover2")
    Rover.rotate_right("rover2")

    Rover.go_forward("rover2")
    Rover.go_forward("rover2")
    Rover.rotate_right("rover2")

    Rover.go_forward("rover2")
    Rover.go_forward("rover2")
    Rover.rotate_right("rover2")

    {:ok, state} = Rover.get_state("rover2")
    assert state == {1, 2, :N, 0}
  end
end
