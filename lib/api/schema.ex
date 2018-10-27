defmodule Api.Schema do
  use Absinthe.Schema
  use Absinthe.Schema.Notation
  require Logger

  import_types(Api.Types)

  query do
    field :temperatures, list_of(:temperature) do
      resolve(authenticated(&Api.Resolvers.list_temperatures/3))
    end

    field :temperature, :temperature do
      arg(:room, non_null(:string))
      resolve(authenticated(&Api.Resolvers.temperature/3))
    end

    field :errors, list_of(:error) do
      resolve(authenticated(&Api.ErrorResolvers.list_errors/3))
    end

    field :pings, list_of(:ping) do
      resolve(authenticated(&Api.PingResolvers.list_pings/3))
    end

    field :room_error, :error do
      arg(:room, non_null(:string))
      resolve(authenticated(&Api.ErrorResolvers.room_error/3))
    end
  end

  defp authenticated(func) do
    fn parent, args, resolution ->
      if resolution.context.authenticated do
        func.(parent, args, resolution)
      else
        {:error, :not_authorised}
      end
    end
  end
end
