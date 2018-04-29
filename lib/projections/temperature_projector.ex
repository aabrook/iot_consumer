defmodule Projections.TemperatureProjector do
  use Commanded.Projections.Ecto,
    name: "temperature_projection",
    repo: IotConsumer.EventStoreRepo

  project (temp = %TemperatureRecorded{temperature: temperature, room: room, humidity: humidity}) do
    IO.puts "Projecting temperature #{inspect temperature}"

    Ecto.Multi.insert(multi, :temperature_projection,
                      %Projection.Temperature{
                        temperature: temperature,
                        room: room,
                        humidity: humidity
                      }
    )
  end
end
