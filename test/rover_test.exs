defmodule RoverTest do
  use ExUnit.Case
  doctest Rover

  test "get_state should return current state" do
    {:ok, _} = Rover.start_link({1,3, :N, "rover1"})
    {:ok, state} = Rover.get_state("rover1")
    assert state == {1, 3, :N}
  end

  test "handle_call :get_state should return current state" do
    {:reply, {:ok, res}, _state} = Rover.handle_call(:get_state, [], %Rover{x: 1, y: 3, direction: :N})
    assert res == {1, 3, :N}
  end

  test "handle_cast :go_forward should return updated state" do
    {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 4
    assert state.direction == :N
  end

  test "handle_cast :rotate_left should return updated state" do
    {:noreply, state} = Rover.handle_cast(:rotate_left, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 3
    assert state.direction == :W
  end

  test "handle_cast :go_backward should return updated state" do
    {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 2
    assert state.direction == :N
  end

  test "handle_cast :rotate_right should return updated state" do
    {:noreply, state} = Rover.handle_cast(:rotate_right, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 3
    assert state.direction == :E
  end
end
