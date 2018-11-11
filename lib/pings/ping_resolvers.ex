defmodule Api.PingResolvers do
  import Ecto.Query

  def list_pings(_parent, args, _resolution) do
    pings =
      Projection.Ping
      |> IotConsumer.EventStoreRepo.all

    {:ok, pings}
  end

  def list_ping_history(_parent, %{ping_id: id}, _resolution) do
    ping_history =
      Projection.PingHistory
      |> where(ping_id: ^id)
      |> IotConsumer.EventStoreRepo.all

    {:ok, ping_history}
  end

  def get_ping(source) do
    Projection.Ping
    |> where(source: ^source)
    |> IotConsumer.EventStoreRepo.one
  end
end
