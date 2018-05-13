defmodule TemperatureRouter do
  use Commanded.Commands.Router

  identify(Temperature, by: :room, prefix: "temperature-")

  dispatch(RecordTemperature, to: Temperature)
end

defmodule ErrorRouter do
  use Commanded.Commands.Router

  identify(Error, by: :room, prefix: "error-")

  dispatch(ReportError, to: Error)
  dispatch(ResolveError, to: Error)
end
