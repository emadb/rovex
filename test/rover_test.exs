defmodule RoverTest do
  use ExUnit.Case
  alias Mars.Rover
  import Mars.TestUtils

  test "start the rover" do
    {:ok, pid} = Rover.start_link([1, {1, 1}])
    assert(Process.alive?(pid))
  end

  test "get rover state" do
    {:ok, _} = start_supervised({Rover, [1, {1, 1}]})
    assert %{id: 1, pos: {1, 1}, move_count: 0, direction: :north} == Rover.get_state(1)
  end

  test "send command" do
    {:ok, _} = start_supervised({Rover, [1, {1, 1}]})
    Rover.send(1, "F")
    assert %{id: 1, pos: {1, 0}, move_count: 1, direction: :north} == Rover.get_state(1)
  end

  test "send multiple commands" do
    {:ok, _} = start_supervised({Rover, [1, {1, 1}]})
    Rover.send(1, ["F", "F", "F"])
    assert %{id: 1, pos: {1, -2}, move_count: 3, direction: :north} == Rover.get_state(1)
  end

  test_case "F", {1, 1}, :north do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 0}, move_count: 1, direction: :north}
  end

  test_case "B", {1, 1}, :north do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 2}, move_count: 1, direction: :north}
  end

  test_case "F", {1, 1}, :east do
    assert Rover.get_state(1) == %{id: 1, pos: {2, 1}, move_count: 1, direction: :east}
  end

  test_case "B", {1, 1}, :east do
    assert Rover.get_state(1) == %{id: 1, pos: {0, 1}, move_count: 1, direction: :east}
  end

  test_case "F", {1, 1}, :south do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 2}, move_count: 1, direction: :south}
  end

  test_case "B", {1, 1}, :south do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 0}, move_count: 1, direction: :south}
  end

  test_case "F", {1, 1}, :west do
    assert Rover.get_state(1) == %{id: 1, pos: {0, 1}, move_count: 1, direction: :west}
  end

  test_case "B", {1, 1}, :west do
    assert Rover.get_state(1) == %{id: 1, pos: {2, 1}, move_count: 1, direction: :west}
  end

  test_case "R", {1, 1}, :north do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :east}
  end

  test_case "R", {1, 1}, :east do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :south}
  end

  test_case "R", {1, 1}, :south do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :west}
  end

  test_case "R", {1, 1}, :west do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :north}
  end

  test_case "L", {1, 1}, :north do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :west}
  end

  test_case "L", {1, 1}, :east do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :north}
  end

  test_case "L", {1, 1}, :south do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :east}
  end

  test_case "L", {1, 1}, :west do
    assert Rover.get_state(1) == %{id: 1, pos: {1, 1}, move_count: 1, direction: :south}
  end
end
