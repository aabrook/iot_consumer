defmodule Handlers.Temperature do
  use Commanded.Event.Handler, name: __MODULE__

  def init do
    with {:ok, _pid} <- Agent.start_link(fn -> 0 end, name: __MODULE__) do
      :ok
    end
  end

  def handle(%TemperatureRecorded{ temperature: temperature }, _metadata) do
    Agent.update(__MODULE__, fn _ -> temperature end)
  end

  def current_temperature do
    Agent.get(__MODULE__, fn temperature -> temperature end)
  end
end
