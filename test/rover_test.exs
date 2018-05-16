defmodule RoverTest do
  use ExUnit.Case
  doctest Rover

  test "get_state should return current state" do
    {:ok, _} = Rover.start_link({9, 9, :N, "rover0"})
    {:ok, state} = Rover.get_state("rover0")
    assert state == {9, 9, :N, 0}
  end

  test "handle_call :get_state should return current state" do
    {:reply, {:ok, res}, _state} =
      Rover.handle_call(:get_state, [], %Rover{x: 1, y: 3, direction: :N, score: 5})

    assert res == {1, 3, :N, 5}
  end

  test "handle_cast :go_forward should return updated state" do
    {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 4
    assert state.direction == :N
  end

  test "handle_cast :go_backward should return updated state" do
    {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 1, y: 3, direction: :N})
    assert state.x == 1
    assert state.y == 2
    assert state.direction == :N
  end

  describe "rotate_left" do
    test "handle_cast :rotate_left should return updated state (N)" do
      {:noreply, state} = Rover.handle_cast(:rotate_left, %Rover{x: 1, y: 3, direction: :N})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :W
    end

    test "handle_cast :rotate_left should return updated state (S)" do
      {:noreply, state} = Rover.handle_cast(:rotate_left, %Rover{x: 1, y: 3, direction: :S})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :E
    end

    test "handle_cast :rotate_left should return updated state (E)" do
      {:noreply, state} = Rover.handle_cast(:rotate_left, %Rover{x: 1, y: 3, direction: :E})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :N
    end

    test "handle_cast :rotate_left should return updated state (W)" do
      {:noreply, state} = Rover.handle_cast(:rotate_left, %Rover{x: 1, y: 3, direction: :W})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :S
    end
  end

  describe "rotate_right" do
    test "handle_cast :rotate_right should return updated state (N)" do
      {:noreply, state} = Rover.handle_cast(:rotate_right, %Rover{x: 1, y: 3, direction: :N})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :E
    end

    test "handle_cast :rotate_right should return updated state (S)" do
      {:noreply, state} = Rover.handle_cast(:rotate_right, %Rover{x: 1, y: 3, direction: :S})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :W
    end

    test "handle_cast :rotate_right should return updated state (E)" do
      {:noreply, state} = Rover.handle_cast(:rotate_right, %Rover{x: 1, y: 3, direction: :E})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :S
    end

    test "handle_cast :rotate_right should return updated state (W)" do
      {:noreply, state} = Rover.handle_cast(:rotate_right, %Rover{x: 1, y: 3, direction: :W})
      assert state.x == 1
      assert state.y == 3
      assert state.direction == :N
    end
  end

  describe "world wrap" do
    test "handle_cast :go_forward (N) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 2, y: 9, direction: :N})
      assert state.x == 2
      assert state.y == 0
      assert state.direction == :N
    end

    test "handle_cast :go_backward (N) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 2, y: 0, direction: :N})
      assert state.x == 2
      assert state.y == 9
      assert state.direction == :N
    end

    test "handle_cast :go_forward (S) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 2, y: 0, direction: :S})
      assert state.x == 2
      assert state.y == 9
      assert state.direction == :S
    end

    test "handle_cast :go_backward (S) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 2, y: 9, direction: :S})
      assert state.x == 2
      assert state.y == 0
      assert state.direction == :S
    end

    test "handle_cast :go_forward (E) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 9, y: 5, direction: :E})
      assert state.x == 0
      assert state.y == 5
      assert state.direction == :E
    end

    test "handle_cast :go_backward (E) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 0, y: 0, direction: :E})
      assert state.x == 9
      assert state.y == 0
      assert state.direction == :E
    end

    test "handle_cast :go_forward (W) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_forward, %Rover{x: 0, y: 3, direction: :W})
      assert state.x == 9
      assert state.y == 3
      assert state.direction == :W
    end

    test "handle_cast :go_backward (W) at the end should wrap around" do
      {:noreply, state} = Rover.handle_cast(:go_backward, %Rover{x: 9, y: 2, direction: :W})
      assert state.x == 0
      assert state.y == 2
      assert state.direction == :W
    end

    test "handle_cast :update_score should add 1" do
      {:noreply, state} =
        Rover.handle_cast(:update_score, %Rover{x: 9, y: 2, direction: :W, score: 7})

      assert state.score == 8
    end
  end
end
