defmodule Api.ErrorResolvers do
  import Ecto.Query

  def list_errors(_parent, args, _resolution) do
    errors =
      Projection.Error
      |> IotConsumer.EventStoreRepo.all()
      |> IO.inspect()

    {:ok, errors}
  end

  def room_error(_parent, %{room: room}, _resolution) do
    with error = %Projection.Error{} <- get_error(room) do
      {:ok, error}
    else
      nil -> {:error, :error_not_found}
    end
  end

  defp get_error(room) do
    Projection.Error
    |> where(room: ^room)
    |> IotConsumer.EventStoreRepo.one()
  end
end
