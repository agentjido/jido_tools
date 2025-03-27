defmodule Jido.ToolsTest do
  use ExUnit.Case
  doctest Jido.Tools

  test "greets the world" do
    assert Jido.Tools.hello() == :world
  end
end
