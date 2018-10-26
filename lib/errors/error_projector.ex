defmodule Projections.ErrorProjector do
  use Commanded.Projections.Ecto,
    name: "error_projection",
    repo: IotConsumer.EventStoreRepo

  import Ecto.Query
  alias IotConsumer.EventStoreRepo, as: Repo

  project %ErrorReported{source: room} do
    room
    |> find_room
    |> update_status(multi, %{room: room, status: "reported"})
  end

  project %ErrorEscalated{source: room} do
    room
    |> find_room
    |> update_status(multi, %{room: room, status: "escalated"})
  end

  project %ErrorAlerted{source: room} do
    room
    |> find_room
    |> update_status(multi, %{room: room, status: "alerted"})
  end

  project %ErrorResolved{source: room} do
    room
    |> find_room
    |> update_status(multi, %{room: room, status: "resolved"})
  end

  defp find_room(room) do
    IO.puts("Find Room")

    Projection.Error
    |> where(room: ^room)
    |> Repo.one()
    |> IO.inspect()
  end

  defp update_status(nil, multi, %{status: status, room: room}) do
    changeset =
      %Projection.Error{}
      |> Projection.Error.changeset(%{status: status, room: room})

    Ecto.Multi.insert(multi, :error, changeset)
  end

  defp update_status(error = %Projection.Error{}, multi, %{status: status}) do
    changeset =
      error
      |> Projection.Error.changeset(%{status: status})

    Ecto.Multi.update(multi, :error, changeset)
  end
end
