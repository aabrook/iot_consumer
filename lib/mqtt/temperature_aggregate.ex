defmodule RecordTemperature do
  defstruct [:humidity, :temperature, :room]
end

defmodule TemperatureRecorded do
  defstruct [:humidity, :temperature, :room]
end

defmodule Temperature do
  defstruct [:humidity, :temperature, :room]

  def execute(%Temperature{}, %RecordTemperature{room: r, humidity: h, temperature: t}) do
    with {:ok, _} <- in_range(t, -40, 50, :temperature_out_of_range),
         {:ok, _} <- in_range(h, 0, 100, :humidity_out_of_range)
    do
      %TemperatureRecorded{ room: r, temperature: t, humidity: h }
      |> IO.inspect
    else
      err -> err
    end
  end

  def apply(%Temperature{}, %TemperatureRecorded{ temperature: temperature, room: room, humidity: humidity }) do
    %Temperature{
      room: room,
      humidity: humidity,
      temperature: temperature
    }
  end
  def apply(%Temperature{}, %{"temperature" => temperature, "room" => room, "humidity" => humidity }) do
    %Temperature{temperature: temperature, room: room, humidity: humidity}
  end

  defp in_range(n, min, max, e) do
    {num, _} = n |> :string.to_integer |> IO.inspect

    case min <= num && num <= max do
      true -> {:ok, n}
      false -> {:error, e}
    end
  end
end
