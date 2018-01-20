defmodule IotConsumer do
  require Logger
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(Mqtt.TemperatureReceiver, []),
      Plug.Adapters.Cowboy.child_spec(:http, WebServer.Router, [], port: 8080),
    ]

    opts = [strategy: :one_for_one, name: IotConsumer]

    _ = Logger.info("IoT Consumer Started")
    Supervisor.start_link(children, opts)
  end
end
