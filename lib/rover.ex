defmodule Rover do
  use GenServer

  @type direction :: :N | :S | :E | :W

  defstruct [:x, :y, :direction]

  def start_link({x, y, d, name}) do
    GenServer.start_link(__MODULE__, {x, y, d, name}, name: RegistryHelper.create_key(name))
  end

  def init({x, y, d, name}) do
    {:ok, _} = RegistryHelper.register(name)
    {:ok, %Rover{x: x, y: y, direction: d}}
  end

  def get_state(name) do
    GenServer.call(RegistryHelper.get_pid(name), :get_state)
  end

  def go_forward(name) do
    GenServer.call(RegistryHelper.get_pid(name), :go_forward)
  end

  def rotate_left(name) do
    GenServer.call(RegistryHelper.get_pid(name), :rotate_left)
  end

  def go_backward(name) do
    GenServer.call(RegistryHelper.get_pid(name), :go_backward)
  end

  def rotate_right(name) do
    GenServer.call(RegistryHelper.get_pid(name), :rotate_right)
  end

  def handle_call(:get_state, _from, state) do
    {:reply, {:ok, {state.x, state.y, state.direction}}, state}
  end

  def handle_call(:go_forward, _from, state) do
    new_state = case state.direction do
      :N -> %Rover{x: state.x, y: state.y + 1, direction: state.direction}
      :S -> %Rover{x: state.x, y: state.y - 1, direction: state.direction}
      :E -> %Rover{x: state.x + 1, y: state.y, direction: state.direction}
      :W -> %Rover{x: state.x - 1, y: state.y, direction: state.direction}
    end

    reply = {new_state.x, new_state.y, new_state.direction}
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:reply, {:ok, reply}, new_state}
  end

  def handle_call(:rotate_left, _from, state) do
    new_state = case state.direction do
      :N -> %Rover{x: state.x, y: state.y, direction: :W}
      :S -> %Rover{x: state.x, y: state.y, direction: :E}
      :E -> %Rover{x: state.x, y: state.y, direction: :N}
      :W -> %Rover{x: state.x, y: state.y, direction: :S}
    end

    reply = {new_state.x, new_state.y, new_state.direction}
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:reply, {:ok, reply}, new_state}

  end

  def handle_call(:go_backward, _from, state) do
    new_state = case state.direction do
      :N -> %Rover{x: state.x, y: state.y - 1, direction: state.direction}
      :S -> %Rover{x: state.x, y: state.y + 1, direction: state.direction}
      :E -> %Rover{x: state.x - 1, y: state.y, direction: state.direction}
      :W -> %Rover{x: state.x + 1, y: state.y, direction: state.direction}
    end

    reply = {new_state.x, new_state.y, new_state.direction}
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:reply, {:ok, reply}, new_state}

  end

  def handle_call(:rotate_right, _from, state) do
    new_state = case state.direction do
      :N -> %Rover{x: state.x, y: state.y, direction: :E}
      :S -> %Rover{x: state.x, y: state.y, direction: :W}
      :E -> %Rover{x: state.x, y: state.y, direction: :S}
      :W -> %Rover{x: state.x, y: state.y, direction: :N}
    end

    reply = {new_state.x, new_state.y, new_state.direction}
    Rover.Web.WsServer.send_message_to_client(new_state)
    {:reply, {:ok, reply}, new_state}
  end
end
