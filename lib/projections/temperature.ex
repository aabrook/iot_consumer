defmodule Projection.Temperature do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "temperature_projections" do
    field :room, :string
    field :temperature, :integer
    field :humidity, :integer
    field :last_recording, :utc_datetime

    timestamps()
  end

  def changeset(temp, params \\ %{}) do
    params = transform(params)
    temp
    |> cast(params, [:last_recording, :temperature, :room, :humidity])
    |> validate_required([:room, :temperature, :last_recording])
  end

  defp transform(reading) do
    reading
    |> update_in([:temperature], &to_int/1)
    |> update_in([:humidity], &to_int/1)
    |> IO.inspect
  end

  defp to_int(nil), do: nil
  defp to_int(s) do
    case :string.to_integer(s) do
      {:error, _error} -> s
      {number, _remaining} -> number
    end
  end
end
