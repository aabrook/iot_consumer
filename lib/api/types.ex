defmodule Api.Types do
  use Absinthe.Schema.Notation

  import_types(Absinthe.Type.Custom)

  object :temperature do
    field(:id, :id)
    field(:temperature, :integer)
    field(:humidity, :integer)
    field(:room, :string)
    field(:last_recording, :datetime)

    field(:inserted_at, :string)
    field(:updated_at, :string)

    field(
      :status,
      :error,
      resolve: fn %{room: room} = parent, _args, resolution ->
        Api.ErrorResolvers.room_error(%{}, %{room: room}, resolution)
      end
    )
  end

  object :error do
    field(:id, :id)
    field(:room, :string)
    field(:status, :string)

    field(:inserted_at, :string)
    field(:updated_at, :string)

    field(
      :reading,
      :temperature,
      resolve: fn %{room: room}, _args, resolution ->
        Api.Resolvers.temperature(%{}, %{room: room}, resolution)
      end
    )
  end

  object :ping do
    field(:id, :id)
    field(:source, :string)
    field(:ttl, :string)
    field(:time, :string)
    field(:destination, :string)

    field(:inserted_at, :string)
    field(:updated_at, :string)

    field(:history, list_of(:ping_history),
      resolve: fn %{id: id}, _args, resolution ->
        Api.PingResolvers.list_ping_history(%{}, %{ping_id: id}, resolution)
      end
    )
  end

  object :ping_history do
    field(:id, :id)
    field(:source, :string)
    field(:time, :string)
    field(:ttl, :string)
    field(:destination, :string)

    field(:inserted_at, :string)
    field(:updated_at, :string)
  end

  object :speedtest do
    field(:id, :id)
    field(:source, :string)
    field(:host, :string)
    field(:download, :string)
    field(:upload, :string)

    field(:inserted_at, :string)
    field(:updated_at, :string)

    field(:history, list_of(:speedtest_history),
      resolve: fn %{id: id}, _args, resolution ->
        Api.SpeedtestResolvers.list_speedtest_history(%{}, %{speedtest_id: id}, resolution)
      end
    )
  end

  object :speedtest_history do
    field(:id, :id)
    field(:source, :string)
    field(:host, :string)
    field(:download, :string)
    field(:upload, :string)

    field(:inserted_at, :string)
    field(:updated_at, :string)
  end
end
