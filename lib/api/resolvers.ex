defmodule Api.Resolvers do
  import Ecto.Query

  def list_temperatures(_parent, args, _resolution) do
    rooms =
      Projection.Temperature
      |> IotConsumer.EventStoreRepo.all()
      |> IO.inspect()

    {:ok, rooms}
  end

  def temperature(_parent, %{room: room}, %{context: context}) do
    room =
      Projection.Temperature
      |> where(room: ^room)
      |> IotConsumer.EventStoreRepo.one()
      |> IO.inspect()

    {:ok, room}
  end
end
