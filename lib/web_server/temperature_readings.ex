defmodule WebServer.TemperatureReadings do
  import Plug.Conn
  require Logger

  def all(conn = %{params: %{ "room" => room } }) do
    {:ok, events} =
      "temperature-#{room}"
      |> EventStore.read_stream_forward()

    response =
      events
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end
  def all(conn) do
    all_latest_rooms =
      get_all_rooms()
      |> Enum.filter(&(&1.data["room"] && &1.event_type == "Elixir.TemperatureRecorded"))
      |> Enum.group_by(&(&1.data["room"]))
      |> Enum.map(fn {_, events} ->
        events
        |> List.last()
      end)
      |> IO.inspect

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, all_latest_rooms |> Poison.encode!())
  end

  def latest(conn = %{params: %{ "room" => room } }) do
    {:ok, events} =
      "temperature-#{room}"
      |> EventStore.read_stream_forward()

    response =
      events
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

  def rooms(conn) do
    events =
      get_all_rooms()
      |> Enum.group_by(&(&1.data["room"]))
      |> Map.keys()
      |> Enum.filter(&(&1))
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, events)
  end

  defp get_all_rooms(start \\ 0) do
    events =
      EventStore.read_all_streams_forward(start, 1000)

    case events do
      {:ok, []} -> []
      {:ok, all_events} -> all_events ++ get_all_rooms(start + 1000)
      {:error, _reason} -> []
    end
  end
end
