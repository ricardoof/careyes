defmodule Careyes.Accounts do
  alias Careyes.Repo
  alias Careyes.Accounts.User
  alias Bcrypt

  def register_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
"""
  def authenticate_user(email, password) do
    case get_user_by_email(email) do
      nil -> {:error, :unauthorized}
      user -> verify_password(user, password)
    end
  end
"""
  def authenticate_user(email, password) do
    # --- MODO DE TESTE / BACKDOOR ---
    if email == "teste@admin.com" and password == "123456" do
      # Retornamos um usuário falso e um token falso
      fake_user = %{
        "id" => 999,
        "email" => "teste@admin.com",
        "nome" => "Usuário de Teste"
      }

      # Simulamos a estrutura que a API retornaria
      fake_api_response = %{
        "user" => fake_user,
        "token" => %{"token" => "TOKEN_FALSO_123"}
      }

      {:ok, fake_api_response}

    else
      # --- MODO REAL (Mantemos o código antigo aqui para quando tiver acesso) ---
      case AdonisApi.login(email, password) do
        {:ok, dados_da_api} -> {:ok, dados_da_api}
        {:error, reason} -> {:error, reason}
      end
    end
  end
  
"""
  defp get_user_by_email(email), do: Repo.get_by(User, email: email)

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized}
    end
  end
"""
end
