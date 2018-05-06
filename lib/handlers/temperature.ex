defmodule Handlers.Temperature do
  @behaviour Commanded.Commands.Handler

  def init do
    IO.puts "Init temperature handler"
    with {:ok, _pid} <- Agent.start_link(fn -> 0 end, name: __MODULE__) do
      :ok
    end
  end

  def handle(temperature = %TemperatureRecorded{ temperature: temperature }, _metadata) do
    IO.puts "Handled #{temperature}"
    Agent.update(__MODULE__, fn _ -> temperature end)
  end

  def handle(temperature, _metadata) do
    IO.puts "Handled #{temperature}"
    :ok
  end

  def current_temperature do
    Agent.get(__MODULE__, fn temperature -> temperature end)
  end
end
