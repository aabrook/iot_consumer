defmodule Projection.Ping do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "ping_projections" do
    field(:source, :string)
    field(:time, :string)
    field(:ttl, :string)
    field(:destination, :string)

    timestamps()
  end

  def changeset(ping, params \\ %{}) do
    ping
    |> cast(params, [:source, :time, :ttl, :destination])
    |> validate_required([:source])
  end
end

defmodule Projection.PingHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "ping_history" do
    field(:source, :string)
    field(:time, :string)
    field(:ttl, :string)
    field(:destination, :string)

    @foreign_key_type :binary_id
    belongs_to(:ping, Projection.Ping)

    timestamps()
  end

  def changeset(history, params \\ %{}) do
    history
    |> cast(params, [:ping_id, :source, :time, :ttl, :destination])
    |> validate_required([:ping_id, :source])
  end
end

