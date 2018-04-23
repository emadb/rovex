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

  test "handle_call :go_forward should return updated state" do
    {:reply, {:ok, res}, _state} = Rover.handle_call(:go_forward, [], %Rover{x: 1, y: 3, direction: :N})
    assert res == {1, 4, :N}
  end

  test "handle_call :rotate_left should return updated state" do
    {:reply, {:ok, res}, _state} = Rover.handle_call(:rotate_left, [], %Rover{x: 1, y: 3, direction: :N})
    assert res == {1, 3, :W}
  end


  test "handle_call :go_backward should return updated state" do
    {:reply, {:ok, res}, _state} = Rover.handle_call(:go_backward, [], %Rover{x: 1, y: 3, direction: :N})
    assert res == {1, 2, :N}
  end

  test "handle_call :rotate_right should return updated state" do
    {:reply, {:ok, res}, _state} = Rover.handle_call(:rotate_right, [], %Rover{x: 1, y: 3, direction: :N})
    assert res == {1, 3, :E}
  end
end
