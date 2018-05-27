defmodule Projections.TemperatureProjector do
  use Commanded.Projections.Ecto,
    name: "temperature_projection",
    repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %TemperatureRecorded{room: room, humidity: humidity, temperature: temperature} do
    room
    |> find_room()
    |> save_room(multi, %{
      room: room,
      humidity: humidity,
      temperature: temperature,
      last_recording: DateTime.utc_now()
    })
  end

  defp find_room(room) do
    Projection.Temperature
    |> where(room: ^room)
    |> Repo.one()
  end

  defp save_room(nil, multi, params) do
    changeset =
      %Projection.Temperature{}
      |> Projection.Temperature.changeset(params)

    IO.puts("Saving new room: #{inspect(changeset)}")
    Ecto.Multi.insert(multi, :temperature, changeset)
  end

  defp save_room(room = %Projection.Temperature{}, multi, params) do
    changeset =
      room
      |> Projection.Temperature.changeset(params)

    IO.puts("Updating room: #{inspect(changeset)}")
    Ecto.Multi.update(multi, :temperature, changeset)
  end
end
