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
      |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, events)
  end

  defp get_all_rooms(start \\ 0) do
    Projection.Temperature
    |> IotConsumer.EventStoreRepo.all()
    |> Enum.map(&Map.take(&1, [:updated_at, :inserted_at, :temperature, :room, :humidity]))
  end
end
