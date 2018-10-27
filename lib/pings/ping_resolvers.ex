defmodule Api.PingResolvers do
  import Ecto.Query

  def list_pings(_parent, args, _resolution) do
    pings =
      Projection.Ping
      |> IotConsumer.EventStoreRepo.all

    {:ok, pings}
  end

  def get_ping(source) do
    Projection.Ping
    |> where(source: ^source)
    |> IotConsumer.EventStoreRepo.one
  end
end
