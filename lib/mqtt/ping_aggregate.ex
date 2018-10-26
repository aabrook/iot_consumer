defmodule RecordPing do
  defstruct [:ttl, :time, :destination, :source]
end

defmodule PingRecorded do
  defstruct [:ttl, :time, :destination, :source]
end

defmodule Ping do
  defstruct [:ttl, :time, :destination, :source]

  def execute(%Ping{}, %RecordPing{
    ttl: ttl,
    time: time,
    destination: destination,
    source: source
  }) do
    %PingRecorded{
      ttl: ttl,
      time: time,
      destination: destination,
      source: source
    }
  end

  def apply(%Ping{}, %PingRecorded{
    ttl: ttl,
    time: time,
    destination: destination,
    source: source
  }) do
    %Ping{
      ttl: ttl,
      time: time,
      destination: destination,
      source: source
    }
  end
end

