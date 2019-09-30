defmodule ServerSideTest do
  use ExUnit.Case
  doctest ServerSide

  test "greets the world" do
    assert ServerSide.hello() == :world
  end
end
