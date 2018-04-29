defmodule Api.Schema do
  use Absinthe.Schema
  use Absinthe.Schema.Notation
  require Logger

  import_types(Api.Types)

  query do
    field :temperatures, list_of(:temperature) do
      resolve(&Api.Resolvers.list_temperatures/3)
    end

    field :temperature, :temperature do
      arg(:room, non_null(:string))
      resolve(&Api.Resolvers.temperature/3)
    end
  end
end

