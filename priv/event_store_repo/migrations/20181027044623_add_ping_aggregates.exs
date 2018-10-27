defmodule IotConsumer.EventStoreRepo.Migrations.AddPingAggregates do
  use Ecto.Migration

  def change do
    create table(:ping_projections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :source, :string
      add :ttl, :string
      add :time, :string

      timestamps()
    end

    create table(:ping_history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :ttl, :string
      add :time, :string

      add :ping_id, references(:ping_projections, type: :uuid), null: false

      timestamps()
    end
  end
end
