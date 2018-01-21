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

  def on_publish(topic, message, state) do
    payload = message
      |> Poison.decode!()

    Logger.info "#{inspect topic} : #{inspect payload}"

    add_to_stream(payload)

    {:ok, state}
  end

  defp add_to_stream(payload = %{"r" => room}) do
    event = %EventStore.EventData{
      event_type: "TemperatureReceived",
      data: payload,
    }

    uuid = UUID.uuid5(:nil, room)
    :ok = EventStore.append_to_stream(uuid, :any_version, [event])

    {:ok, events} = EventStore.read_stream_forward(uuid)
    events
  end
  defp add_to_stream(payload), do: Logger.warn("No room specified #{inspect payload}")
end
