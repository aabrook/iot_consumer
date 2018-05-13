defmodule WebServer.SuperSimpleAuth do
  require Logger
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    if conn
       |> get_bearer
       |> is_auth do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, %{error: "Unauthorized"} |> Poison.encode!())
      |> halt()
    end
  end

  defp get_bearer(%{req_headers: headers}) do
    {_, bearer} =
      headers
      |> Enum.find({"authorization", ""}, fn {header, _} ->
        header |> String.downcase() == "authorization"
      end)

    bearer
    |> String.downcase()
  end

  defp is_auth("bearer " <> token), do: token == System.get_env("BEARER_TOKEN")
  defp is_auth(_), do: false
end
