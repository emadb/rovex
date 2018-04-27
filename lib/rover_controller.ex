defmodule RoverController do
  @world_width Application.get_env(:rover, :world_width)
  @world_height Application.get_env(:rover, :world_height)

  def create_rover(name, x, y, d) do
    RoverFactory.create_rover(name, x, y, d)
  end

  def create_multiple_rovers(count) do
    dirs = [:N, :E, :S, :W]

    Enum.each(0..count, fn x ->
      RoverFactory.create_rover(get_rover_name(x), Enum.random(0..@world_width), Enum.random(0..@world_height), Enum.at(dirs, Enum.random(0..3)))
    end)
  end

  def send_multiple_commands(rover_count, command_count \\ 1) do
    Enum.each(0..command_count, fn _ -> send_single_command(rover_count) end)
  end

  defp send_single_command(rover_count) do
    Enum.each(0..rover_count, fn n ->
      command = get_command()
      send_command(get_rover_name(n), command)
    end)
  end

  def send_command(name, :F) do
    Rover.go_forward(name)
  end

  def send_command(name, :B) do
    Rover.go_backward(name)
  end

  def send_command(name, :L) do
    Rover.rotate_left(name)
  end

  def send_command(name, :R) do
    Rover.rotate_right(name)
  end

  defp get_command do
    commands = [:F, :B, :L, :R, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F, :F]
    Enum.at(commands, Enum.random(0..(Enum.count(commands) -1)))
  end

  defp get_rover_name(n) do
    "rover_#{Integer.to_string(n)}"
  end
end
