defmodule IotConsumer.EventStoreRepo.Migrations.CreateTemperatureProjectView do
  use Ecto.Migration

  def change do
    create table(:temperature_projections, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :temperature, :integer
      add :humidity, :integer
      add :room, :string

      timestamps()
    end
  end
end
