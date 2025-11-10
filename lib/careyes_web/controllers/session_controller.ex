defmodule CareyesWeb.SessionController do
  use CareyesWeb, :controller

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Logout realizado com sucesso.")
    |> redirect(to: ~p"/login")
  end
end
