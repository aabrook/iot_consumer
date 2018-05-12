defmodule IotConsumer.EventStoreRepo.Migrations.AddLastRecording do
  use Ecto.Migration

  def change do
    alter table(:temperature_projections) do
      add :last_recording, :datetime
    end
  end
end
