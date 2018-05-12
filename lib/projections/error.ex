defmodule Projection.Error do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "error_projections" do
    field :room, :string
    field :status, :string

    timestamps()
  end

  def changeset(err, params \\ %{}) do
    IO.puts "+params"
    IO.inspect params.room
    IO.puts "-params"

    err
    |> IO.inspect
    |> cast(params, [:room, :status])
    |> validate_required([:room])
  end
end

defmodule Projection.ErrorHistory do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "error_history" do
    field :room, :string
    field :status, :string
    field :message, :string

    belongs_to :error, Projection.Error

    timestamps()
  end
end

