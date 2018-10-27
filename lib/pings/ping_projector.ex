defmodule Projections.PingProjector do
  use Commanded.Projections.Ecto,
    name: "ping_projection",
    repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %PingRecorded{source: source, ttl: ttl, time: time, destination: destination} do
    source
    |> find_source
    |> update_status(multi, %{source: source, ttl: ttl, time: time, destination: destination})
  end

  defp find_source(source) do
    Projection.Ping
    |> where(source: ^source)
    |> Repo.one()
    |> IO.inspect()
  end

  defp update_status(nil, multi, params) do
    changeset =
      %Projection.Ping{}
      |> Projection.Ping.changeset(params)

    Ecto.Multi.insert(multi, :ping, changeset)
  end

  defp update_status(ping = %Projection.Ping{}, multi, params) do
    changeset =
      ping
      |> Projection.Ping.changeset(params)

    Ecto.Multi.update(multi, :ping, changeset)
  end
end