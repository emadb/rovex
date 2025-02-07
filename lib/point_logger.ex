defmodule Rovex.PointLogger do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Phoenix.PubSub.subscribe(:rover_pubsub, "points")
    {:ok, []}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end
end
