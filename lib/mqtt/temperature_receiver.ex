defmodule Mqtt.TemperatureReceiver do
  require Logger
  use GenMQTT

  def start_link do
    Logger.info "Start MQTT link"
    {port, _remaining} = System.get_env("MQTT_PORT") |> :string.to_integer()

    GenMQTT.start_link(__MODULE__, %{},
      host: System.get_env("MQTT_HOST"),
      port: port,
      username: System.get_env("MQTT_USER"),
      password: System.get_env("MQTT_PASS"),
    )
  end

  def on_connect(state) do
    :ok = GenMQTT.subscribe(self, "#", 0)
    Logger.debug "Connected #{inspect state}"

    {:ok, state}
  end

  def on_connect_error(reason, state) do
   Logger.error "Failed to connect: #{reason} (#{inspect state})"
    {:error, state}
  end

  def on_publish(topic, message, state) do
    Logger.info "#{inspect topic} : #{inspect message}"
    {:ok, state}
  end
end
