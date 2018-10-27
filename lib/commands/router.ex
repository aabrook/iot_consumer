defmodule TemperatureRouter do
  use Commanded.Commands.Router

  identify(Temperature, by: :room, prefix: "temperature-")

  dispatch(RecordTemperature, to: Temperature)
end

defmodule PingRouter do
  use Commanded.Commands.Router

  identify(Ping, by: :source, prefix: "ping-")
  dispatch(RecordPing, to: Ping)
end

