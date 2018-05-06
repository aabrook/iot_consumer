defmodule Projections.TemperatureProjector do
  use Commanded.Event.Handler, name: "TemperatureProjector", start_from: :origin

  def handle(event, metadata) do
    IO.puts "Received event #{inspect event}"
    :ok
  end
end
