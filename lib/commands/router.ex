defmodule TemperatureRouter do
  use Commanded.Commands.Router

  identify(Ping, by: :source, prefix: "ping-")
  identify(Temperature, by: :room, prefix: "temperature-")

  dispatch(RecordPing, to: Ping)
  dispatch(RecordTemperature, to: Temperature)
end

