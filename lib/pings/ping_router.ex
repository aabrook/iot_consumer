defmodule PingRouter do
  use Commanded.Commands.Router

  identify(Ping, by: :source, prefix: "ping-")
  dispatch(RecordPing, to: Ping)
end
