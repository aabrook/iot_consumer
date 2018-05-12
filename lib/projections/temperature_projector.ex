defmodule Projections.TemperatureProjector do
  use Commanded.Projections.Ecto,
      name: "temperature_projection",
      repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %TemperatureRecorded{room: room, humidity: humidity, temperature: temperature} = event do
    case find_room(room) do
      nil -> changeset = %Projection.Temperature{} |> Projection.Temperature.changeset(%{room: room, humidity: humidity, temperature: temperature})
        Ecto.Multi.insert(multi, :temperature, changeset)
      room -> changeset = room |> Projection.Temperature.changeset(%{humidity: humidity, temperature: temperature})
        Ecto.Multi.update(multi, :temperature, changeset)
    end
  end

  defp find_room(room) do
    Projection.Temperature
    |> where(room: ^room)
    |> Repo.one
  end
end
