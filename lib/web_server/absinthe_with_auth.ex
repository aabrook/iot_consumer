defmodule WebServer.AbsintheWithAuth do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context =
      build_context(conn)

    conn
    |> Absinthe.Plug.put_options(context: context)
  end

  defp build_context(conn) do
    with ["bearer " <> token] <- get_req_header(conn, "authorization"),
         true <- authorize(token) do
      %{authenticated: true}
    else
      _ -> %{authenticated: false}
    end
  end

  defp authorize(token) do
    token == System.get_env("BEARER_TOKEN")
  end
end
