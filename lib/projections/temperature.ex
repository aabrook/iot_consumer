defmodule Projection.Temperature do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "temperature_projections" do
    field :room, :string
    field :temperature, :integer
    field :humidity, :integer

    timestamps()
  end
end
