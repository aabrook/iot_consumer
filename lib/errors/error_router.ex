defmodule ErrorRouter do
  use Commanded.Commands.Router

  identify(Error, by: :room, prefix: "error-")

  dispatch(ReportError, to: Error)
  dispatch(ResolveError, to: Error)
end

