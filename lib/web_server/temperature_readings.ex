defmodule WebServer.TemperatureReadings do
  import Plug.Conn
  require Logger

  def all(conn = %{params: %{ "room" => room } }) do
    {:ok, events} = :nil
      |> UUID.uuid5(room)
      |> EventStore.read_stream_forward()

    response = events |> Poison.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, response)
  end
  def all(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, %{error: "Must specify the query param 'room' to query rooms"} |> Poison.encode!())
  end
end
