defmodule TemperatureRouter do
  use Commanded.Commands.Router

  identify Temperature, by: :room, prefix: "temperature-"

  dispatch RecordTemperature, to: Temperature

end

