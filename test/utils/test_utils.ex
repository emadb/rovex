defmodule Mars.TestUtils do
  alias Mars.Rover

  # defmacro test_case(cmd, pos, dir, expected) do
  #   quote do
  #     test "Test #{unquote(cmd)} #{inspect(unquote(pos))} #{inspect(unquote(dir))}" do
  #       {:ok, _} = start_supervised({Rover, [1, unquote(pos), unquote(dir)]})
  #       Rover.send(1, unquote(cmd))
  #       assert unquote(expected) = Rover.get_state(1)
  #     end
  #   end
  # end

  defmacro test_case(cmd, pos, dir, do: ass) do
    quote do
      test "Test #{unquote(cmd)} #{inspect(unquote(pos))} #{inspect(unquote(dir))} " do
        {:ok, _} = start_supervised({Rover, [1, unquote(pos), unquote(dir)]})
        Rover.send(1, unquote(cmd))
        unquote(ass)
      end
    end
  end
end
