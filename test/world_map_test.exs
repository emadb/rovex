defmodule WorldMapTest do
  use ExUnit.Case

  test "update_rover, list is empty, cell is free, should add cell to the state list" do
    initial_state = %{rover_factory: RoverFactoryStub, rovers: []}
    {:reply, :ok, state} = WorldMap.handle_call({:update_rover, "uno", 1, 3}, {}, initial_state)
    rover = Enum.at(state.rovers, 0)

    assert rover.name == "uno"
    assert rover.x == 1
    assert rover.y == 3
  end

  test "update_rover, cell is free, should add cell to the state list" do
    initial_state = %{rover_factory: RoverFactoryStub, rovers: [%{name: "zero", x: 3, y: 3}]}
    {:reply, :ok, state} = WorldMap.handle_call({:update_rover, "uno", 1, 3}, {}, initial_state)
    rover = Enum.find(state.rovers, fn r -> r.name == "uno" end)

    assert rover.name == "uno"
    assert rover.x == 1
    assert rover.y == 3
  end

  test "update_rover, cell is free, rover is already in the list should update the state list" do
    initial_state = %{rover_factory: RoverFactoryStub, rovers: [%{name: "uno", x: 0, y: 3}]}
    {:reply, :ok, state} = WorldMap.handle_call({:update_rover, "uno", 1, 3}, {}, initial_state)
    rover = Enum.at(state.rovers, 0)

    assert rover.name == "uno"
    assert rover.x == 1
    assert rover.y == 3
  end

  test "update_rover, cell is occupied, rover is already in the list should remove rovers" do
    initial_state = %{rover_factory: RoverFactoryStub, rovers: [%{name: "uno", x: 1, y: 3}]}
    {:reply, :ok, state} = WorldMap.handle_call({:update_rover, "due", 1, 3}, {}, initial_state)

    assert Enum.count(state.rovers) == 0
  end

  test "update_rover, other rovers is alive, cell is occupied, rover is already in the list should remove rovers" do
    initial_state = %{
      rover_factory: RoverFactoryStub,
      rovers: [%{name: "uno", x: 1, y: 3}, %{name: "tre", x: 4, y: 5}]
    }

    {:reply, :ok, state} = WorldMap.handle_call({:update_rover, "due", 1, 3}, {}, initial_state)

    assert Enum.count(state.rovers) == 1
    rover = Enum.at(state.rovers, 0)

    assert rover.name == "tre"
  end
end
