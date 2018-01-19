defmodule IotConsumerTest do
  use ExUnit.Case
  doctest IotConsumer

  test "greets the world" do
    assert IotConsumer.hello() == :world
  end
end
