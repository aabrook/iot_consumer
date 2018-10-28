defmodule RecordSpeedtest do
  defstruct [:download, :upload, :host, :source]
end

defmodule SpeedtestRecorded do
  defstruct [:download, :upload, :host, :source]
end

defmodule Speedtest do
  defstruct [:download, :upload, :host, :source]

  def execute(%Speedtest{}, %RecordSpeedtest{
    download: download,
    upload: upload,
    host: host,
    source: source
  }) do
    %SpeedtestRecorded{
      download: download,
      upload: upload,
      host: host,
      source: source
    }
  end

  def apply(%Speedtest{}, %SpeedtestRecorded{
    download: download,
    upload: upload,
    host: host,
    source: source
  }) do
    %Speedtest{
      download: download,
      upload: upload,
      host: host,
      source: source
    }
  end
end


