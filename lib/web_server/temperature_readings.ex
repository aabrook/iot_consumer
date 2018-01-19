defmodule WebServer.TemperatureReadings do
  import Plug.Conn

  def all(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
