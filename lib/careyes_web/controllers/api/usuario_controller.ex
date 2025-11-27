defmodule CareyesWeb.Api.UsuarioController do
  use CareyesWeb, :controller
  alias Careyes.Accounts

  # Recebe o POST com "usuario" e "senha"
  def login_usuario(conn, %{"usuario" => usuario_completo, "senha" => senha}) do

    # Chama nossa lógica de negócio
    case Accounts.login_com_prefixo(usuario_completo, senha) do
      {:ok, dados} ->
        conn
        |> put_status(:ok)
        |> render(:login_success, dados: dados)

      {:error, status, mensagem} ->
        conn
        |> put_status(status) # :forbidden (403) ou :bad_request (400)
        |> json(%{message: mensagem})
    end
  end
end
