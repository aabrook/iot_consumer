defmodule WebServer.TemperatureReadings do
  import Plug.Conn
  require Logger

  def all(conn = %{params: %{ "room" => room } }) do
    {:ok, events} = :nil
      |> UUID.uuid5(room)
      |> EventStore.read_stream_forward()

    response =
      events
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end
  def all(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, %{error: "Must specify the query param 'room' to query rooms"} |> Poison.encode!())
  end

  def latest(conn = %{params: %{ "room" => room } }) do
    {:ok, events} = :nil
      |> UUID.uuid5(room)
      |> EventStore.read_stream_forward()

    response =
      events
      |> Enum.filter(&valid_temperature/1)
      |> List.last
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end
  def latest(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, %{error: "Must specify the query param 'room' to query rooms"} |> Poison.encode!())
  end

  defp valid_temperature(%{data: %{ "t" => temperature }}) do
    {temp, _remaining} = temperature |> :string.to_integer

    temp < 200
  end
  defp valid_temperature(_), do: false
end
