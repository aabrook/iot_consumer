defmodule Api.Resolvers do
  import Ecto.Query

  def list_temperatures(_parent, args, _resolution) do
    Projection.Temperature
    |> IotConsumer.EventStoreRepo.all
    |> IO.inspect

    all_latest_rooms =
      get_all_rooms()
      |> Enum.filter(&(&1.data["room"] && &1.event_type == "Elixir.TemperatureRecorded"))
      |> Enum.group_by(&(&1.data["room"]))
      |> Stream.map(fn {_, events} ->
        events
        |> List.last()
      end)
      |> Stream.map(&Map.get(&1, :data))
      |> Enum.map(&atomize_keys/1)

    {:ok, all_latest_rooms}
  end

  def temperature(_parent, %{room: room}, %{context: context}) do
    {:ok, events} =
      "temperature-#{room}"
      |> EventStore.read_stream_forward()

    response =
      events
      |> List.last()
      |> Map.get(:data)
      |> atomize_keys

    {:ok, response}
  end


  defp get_all_rooms(start \\ 0) do
    events =
      EventStore.read_all_streams_forward(start, 1000)

    case events do
      {:ok, []} -> []
      {:ok, all_events} -> all_events ++ get_all_rooms(start + 1000)
      {:error, _reason} -> []
    end
  end

  defp atomize_keys(%{"temperature" => temperature, "humidity" => humidity, "room" => room}) do
    %{temperature: temperature, humidity: humidity, room: room}
  end
end
