defmodule LoadServerTest do
  use ExUnit.Case
  doctest LoadServer

  test "greets the world" do
    assert LoadServer.hello() == :world
  end
end
