defmodule Api.Types do
  use Absinthe.Schema.Notation

  object :temperature do
    field :id, :id
    field :temperature, :integer
    field :humidity, :integer
    field :room, :string
  end
end
