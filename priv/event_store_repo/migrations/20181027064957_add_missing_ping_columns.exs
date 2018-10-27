defmodule IotConsumer.EventStoreRepo.Migrations.AddMissingPingColumns do
  use Ecto.Migration

  def change do
    alter table(:ping_projections) do
      add :destination, :string
    end

    alter table(:ping_history) do
      add :source, :string
      add :destination, :string
    end
  end
end
