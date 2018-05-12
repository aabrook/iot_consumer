defmodule Api.Types do
  use Absinthe.Schema.Notation

  object :temperature do
    field :id, :id
    field :temperature, :integer
    field :humidity, :integer
    field :room, :string

    field :inserted_at, :string
    field :updated_at, :string

    field :status, :error,
      resolve: fn %{room: room} = parent, _args, resolution ->
        Api.ErrorResolvers.room_error(%{}, %{room: room}, resolution)
      end
  end

  object :error do
    field :id, :id
    field :room, :string
    field :status, :string

    field :inserted_at, :string
    field :updated_at, :string

    field :reading, :temperature, resolve: fn %{room: room}, _args, resolution -> Api.Resolvers.temperature(%{}, %{room: room}, resolution) end
  end
end
