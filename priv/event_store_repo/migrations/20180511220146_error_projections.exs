defmodule IotConsumer.EventStoreRepo.Migrations.ErrorProjections do
  use Ecto.Migration

  def up do
    create table(:error_projections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string
      add :room, :string

      timestamps()
    end

    create table(:error_history, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :status, :string
      add :messsage, :string

      add :error_id, references(:error_projections, type: :uuid), null: false

      timestamps()
    end
  end

  def down do
    drop table(:error_projections)
    drop table(:error_history)
  end
end
