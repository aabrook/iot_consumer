defmodule Projections.SpeedtestProjector do
  use Commanded.Projections.Ecto,
    name: "speedtest_projection",
    repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %SpeedtestRecorded{source: source, host: host, download: download, upload: upload} do
    source
    |> find_source
    |> update_status(multi, %{source: source, host: host, download: download, upload: upload})
  end

  defp find_source(source) do
    Projection.Speedtest
    |> where(source: ^source)
    |> Repo.one()
    |> IO.inspect()
  end

  defp update_status(nil, multi, params) do
    changeset =
      %Projection.Speedtest{}
      |> Projection.Speedtest.changeset(params)

    Ecto.Multi.insert(multi, :speedtest, changeset)
  end

  defp update_status(speedtest = %Projection.Speedtest{}, multi, params) do
    changeset =
      speedtest
      |> Projection.Speedtest.changeset(params)

    previous_set =
      speedtest
      |> Map.from_struct
      |> Map.drop([:id])
      |> Map.merge(%{speedtest_id: speedtest.id})
    history_changeset =
      %Projection.SpeedtestHistory{}
      |> Projection.SpeedtestHistory.changeset(previous_set)

    Ecto.Multi.update(multi, :speedtest, changeset)
    |> Ecto.Multi.insert(:speedtest_history, history_changeset)
  end
end

