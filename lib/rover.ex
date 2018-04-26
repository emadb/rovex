defmodule Rover do
  use GenServer

  @world_width Application.get_env(:rover, :world_width)
  @world_height Application.get_env(:rover, :world_height)

  @type direction :: :N | :S | :E | :W

  defstruct [:x, :y, :direction, :name]

  def start_link({x, y, d, name}) do
    GenServer.start_link(__MODULE__, {x, y, d, name}, name: RegistryHelper.create_key(name))
  end

  def init({x, y, d, name}) do
    {:ok, _} = RegistryHelper.register(name)
    WorldMap.update_rover(name, x, y)
    {:ok, %Rover{x: x, y: y, direction: d, name: name}}
  end

  def crash(name) do
    GenServer.call(RegistryHelper.get_pid(name), :crash)
  end

  def get_state(name) do
    GenServer.call(RegistryHelper.get_pid(name), :get_state)
  end

  def go_forward(name) do
    GenServer.cast(RegistryHelper.get_pid(name), :go_forward)
  end

  def rotate_left(name) do
    GenServer.cast(RegistryHelper.get_pid(name), :rotate_left)
  end

  def go_backward(name) do
    GenServer.cast(RegistryHelper.get_pid(name), :go_backward)
  end

  def rotate_right(name) do
    GenServer.cast(RegistryHelper.get_pid(name), :rotate_right)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, {state.x, state.y, state.direction}}, state}
  end

  def handle_call(:crash, _from, state) do
    {:stop, "self_crash", state}
  end

  def handle_cast(:go_forward, state) do
    new_state =
      case state.direction do
        :N ->
          %Rover{
            x: state.x,
            y: mod(state.y + 1, @world_height),
            direction: state.direction,
            name: state.name
          }

        :S ->
          %Rover{
            x: state.x,
            y: mod(state.y - 1, @world_height),
            direction: state.direction,
            name: state.name
          }

        :E ->
          %Rover{
            x: mod(state.x + 1, @world_width),
            y: state.y,
            direction: state.direction,
            name: state.name
          }

        :W ->
          %Rover{
            x: mod(state.x - 1, @world_width),
            y: state.y,
            direction: state.direction,
            name: state.name
          }
      end

    WorldMap.update_rover(state.name, new_state.x, new_state.y)
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:noreply, new_state}
  end

  def handle_cast(:go_backward, state) do
    new_state =
      case state.direction do
        :N ->
          %Rover{
            x: state.x,
            y: mod(state.y - 1, @world_height),
            direction: state.direction,
            name: state.name
          }

        :S ->
          %Rover{
            x: state.x,
            y: mod(state.y + 1, @world_height),
            direction: state.direction,
            name: state.name
          }

        :E ->
          %Rover{
            x: mod(state.x - 1, @world_width),
            y: state.y,
            direction: state.direction,
            name: state.name
          }

        :W ->
          %Rover{
            x: mod(state.x + 1, @world_width),
            y: state.y,
            direction: state.direction,
            name: state.name
          }
      end

    WorldMap.update_rover(state.name, new_state.x, new_state.y)
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:noreply, new_state}
  end

  def handle_cast(:rotate_right, state) do
    new_state =
      case state.direction do
        :N -> %Rover{x: state.x, y: state.y, direction: :E, name: state.name}
        :S -> %Rover{x: state.x, y: state.y, direction: :W, name: state.name}
        :E -> %Rover{x: state.x, y: state.y, direction: :S, name: state.name}
        :W -> %Rover{x: state.x, y: state.y, direction: :N, name: state.name}
      end

    WorldMap.update_rover(state.name, new_state.x, new_state.y)
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:noreply, new_state}
  end

  def handle_cast(:rotate_left, state) do
    new_state =
      case state.direction do
        :N -> %Rover{x: state.x, y: state.y, direction: :W, name: state.name}
        :S -> %Rover{x: state.x, y: state.y, direction: :E, name: state.name}
        :E -> %Rover{x: state.x, y: state.y, direction: :N, name: state.name}
        :W -> %Rover{x: state.x, y: state.y, direction: :S, name: state.name}
      end

    WorldMap.update_rover(state.name, new_state.x, new_state.y)
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:noreply, new_state}
  end

  defp mod(x, y) when x > 0, do: rem(x, y)
  defp mod(x, y) when x < 0, do: rem(x, y) + y
  defp mod(0, _y), do: 0
end
