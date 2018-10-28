defmodule Projection.Speedtest do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "speedtest_projections" do
    field(:source, :string)
    field(:host, :string)
    field(:download, :string)
    field(:upload, :string)

    timestamps()
  end

  def changeset(speedtest, params \\ %{}) do
    speedtest
    |> cast(params, [:source, :time, :ttl, :destination])
    |> validate_required([:source])
  end
end

defmodule Projection.SpeedtestHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "speedtest_history" do
    field(:source, :string)
    field(:host, :string)
    field(:download, :string)
    field(:upload, :string)

    @foreign_key_type :binary_id
    belongs_to(:speedtest, Projection.Speedtest)

    timestamps()
  end

  def changeset(history, params \\ %{}) do
    history
    |> cast(params, [:speedtest_id, :source, :host, :download, :upload])
    |> validate_required([:speedtest_id])
  end
end


