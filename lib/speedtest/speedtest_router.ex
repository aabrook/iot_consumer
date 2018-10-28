defmodule SpeedtestRouter do
  use Commanded.Commands.Router

  identify(Speedtest, by: :source, prefix: "speedtest-")
  dispatch(RecordSpeedtest, to: Speedtest)
end

