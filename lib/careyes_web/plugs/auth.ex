defmodule CareyesWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Você precisa estar logado para acessar essa página.")
        |> redirect(to: "/login")
        |> halt()
      _user_id -> conn
      end
  end
end
