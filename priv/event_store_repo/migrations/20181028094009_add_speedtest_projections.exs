defmodule IotConsumer.EventStoreRepo.Migrations.AddSpeedtestProjections do
  use Ecto.Migration

  def change do
    create table(:speedtest_projections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :source, :string
      add :download, :string
      add :upload, :string
      add :host, :string

      timestamps()
    end

    create table(:speedtest_history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :source, :string
      add :download, :string
      add :upload, :string
      add :host, :string

      add :speedtest_id, references(:speedtest_projections, type: :uuid), null: false

      timestamps()
    end
  end
end
