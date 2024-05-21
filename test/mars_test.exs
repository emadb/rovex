defmodule MarsTest do
  use ExUnit.Case
  doctest Mars

  test "greets the world" do
    assert Mars.hello() == :world
  end
end
