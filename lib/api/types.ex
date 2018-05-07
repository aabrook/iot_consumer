defmodule Api.Types do
  use Absinthe.Schema.Notation

  object :temperature do
    field :id, :id
    field :temperature, :integer
    field :humidity, :integer
    field :room, :string

    field :inserted_at, :string
    field :updated_at, :string
  end
end
