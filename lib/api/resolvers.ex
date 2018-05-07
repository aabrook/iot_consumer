defmodule Api.Resolvers do
  import Ecto.Query

  def list_temperatures(_parent, args, _resolution) do
    Projection.Temperature
    |> IotConsumer.EventStoreRepo.all
    |> IO.inspect

    all_latest_rooms =
      get_all_rooms()

    {:ok, all_latest_rooms}
  end

  def temperature(_parent, %{room: room}, %{context: context}) do
    room = Projection.Temperature
      |> where(room: ^room)
      |> IotConsumer.EventStoreRepo.one()

    {:ok, room}
  end


  defp get_all_rooms(start \\ 0) do
    Projection.Temperature
    |> IotConsumer.EventStoreRepo.all()
  end

  defp atomize_keys(%{"temperature" => temperature, "humidity" => humidity, "room" => room}) do
    %{temperature: temperature, humidity: humidity, room: room}
  end
end
