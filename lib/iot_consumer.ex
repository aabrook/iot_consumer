defmodule IotConsumer do
  require Logger
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(Mqtt.TemperatureReceiver, []),
      supervisor(EventStore.EventStoreRepo, []),
      supervisor(IotConsumer.EventStoreRepo, []),
      Plug.Adapters.Cowboy.child_spec(:http, WebServer.Router, [], port: 8080),
      worker(Projections.TemperatureProjector, [], id: :temperature_projector),
      worker(Projections.ErrorProjector, [], id: :error_projector),
      worker(Projections.SlackProjector, [], id: :slack_projector),
      worker(Projections.PingProjector, [], id: :ping_projector)
    ]

    opts = [strategy: :one_for_one, name: IotConsumer]

    _ = Logger.info("IoT Consumer Started")
    Supervisor.start_link(children, opts)
  end
end
