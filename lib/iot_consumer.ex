defmodule IotConsumer do
  require Logger
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(Mqtt.TemperatureReceiver, [])
    ]

    opts = [strategy: :one_for_one, name: IotConsumer]

    _ = Logger.info("IoT Consumer Started")
    Supervisor.start_link(children, opts)
  end

  @moduledoc """
  Documentation for IotConsumer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> IotConsumer.hello
      :world

  """
  def hello do
    :world
  end
end
