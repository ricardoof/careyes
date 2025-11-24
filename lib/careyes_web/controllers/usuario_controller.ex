defmodule CareyesWeb.UsuarioController do
  use CareyesWeb, :controller

  alias Careyes.Accounts # Vamos criar a lógica aqui
  action_fallback CareyesWeb.FallbackController

  def login_usuario(conn, %{"usuario" => usuario_string, "senha" => senha}) do
    # Chama a função do contexto que traduzimos do Adonis
    case Accounts.login_com_prefixo(usuario_string, senha) do
      {:ok, result} ->
        conn
        |> put_status(:ok)
        |> render(:login_success, result: result)

      {:error, :bad_request, msg} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: msg})

      {:error, :forbidden, msg} ->
        conn
        |> put_status(:forbidden)
        |> json(%{message: msg})

      {:error, :not_found, msg} ->
        conn
        |> put_status(:forbidden) # Adonis retorna forbidden para user não encontrado
        |> json(%{message: msg})
    end
  end
end
