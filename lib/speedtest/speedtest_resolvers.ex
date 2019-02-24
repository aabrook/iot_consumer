defmodule Api.SpeedtestResolvers do
  import Ecto.Query

  def list_speedtests(_parent, args, _resolution) do
    tests =
      Projection.Speedtest
      |> order_by([desc: :inserted_at])
      |> IotConsumer.EventStoreRepo.all

    {:ok, tests}
  end

  def list_speedtest_history(_parent, %{speedtest_id: id}, _resolution) do
    speedtest_history=
      Projection.SpeedtestHistory
      |> where(speedtest_id: ^id)
      |> order_by([desc: :inserted_at])
      |> IotConsumer.EventStoreRepo.all

    {:ok, speedtest_history}
  end

  def get_speedtest(source) do
    Projection.Speedtest
    |> where(source: ^source)
    |> IotConsumer.EventStoreRepo.one
  end
end

