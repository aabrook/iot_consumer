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
    :ok = GenMQTT.subscribe(self(), "#", 0)
    Logger.debug "Connected #{inspect state}"

    {:ok, state}
  end

  def on_connect_error(reason, state) do
   Logger.error "Failed to connect: #{reason} (#{inspect state})"
    {:error, state}
  end

  def on_publish(["temperatures"], message, state) do
    payload = message
      |> Poison.decode!()

    Logger.info "temperatures : #{inspect payload}"

    payload
    |> convert_to_command
    |> TemperatureRouter.dispatch
    |> IO.inspect

    {:ok, state}
  end

  def on_publish(topic, message, state) do
    payload = message
      |> Poison.decode!()

    Logger.error "Unknown topic #{inspect topic} : #{inspect payload}"

    {:ok, state}
  end

  defp add_to_stream(payload), do: Logger.warn("No room specified #{inspect payload}")

  defp convert_to_command(%{"r" => room, "h" => humidity, "t" => temperature}) do
    %RecordTemperature{room: room, humidity: humidity, temperature: temperature}
  end
end
