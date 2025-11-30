defmodule Careyes.Accounts do
  import Ecto.Query, warn: false
  alias Careyes.Repo
  alias Careyes.Accounts.User
  alias Careyes.Institutions.Instituicao
  alias Bcrypt # Certifique-se de ter {:bcrypt_elixir, "~> 3.0"} no mix.exs

  def login_com_prefixo(usuario_input, senha) do
    # Usamos `with` para garantir que todos os passos funcionem em sequência
    with {:ok, prefixo, usuario_sem_prefixo} <- separar_prefixo(usuario_input),
         {:ok, instituicao} <- buscar_instituicao(prefixo),
         {:ok, user} <- buscar_usuario(usuario_sem_prefixo, instituicao.id),
         :ok <- verificar_bloqueio(user, instituicao) do

      # Sucesso! Gera o token
      token = Phoenix.Token.sign(CareyesWeb.Endpoint, "user_auth", user.id)

      # Retorna o pacote completo para o controller
      {:ok, %{user: user, instituicao: instituicao, token: token}}
    else
      # Se qualquer passo falhar, retorna o erro
      error -> error
    end
  end

  # --- Funções Privadas (A Lógica detalhada) ---

  # 1. Separa "my_joao.silva" -> "my" e "joao.silva"
  defp separar_prefixo(input) do
    case String.split(input, "_", parts: 2) do
      [prefixo, nome] -> {:ok, prefixo, nome}
      _ -> {:error, :bad_request, "Formato de usuário inválido"}
    end
  end

  # 2. Busca a Instituição pelo prefixo (adicionando o "_" que o banco espera)
  defp buscar_instituicao(prefixo) do
    prefixo_busca = "#{prefixo}_"
    case Repo.get_by(Instituicao, prefixo: prefixo_busca) do
      nil -> {:error, :bad_request, "Instituição não encontrada"}
      inst -> {:ok, inst}
    end
  end

  # 3. Busca o usuário que pertence àquela instituição
  defp buscar_usuario(nome, instituicao_id) do
    case Repo.get_by(User, usuario: nome, instituicao_id: instituicao_id) do
      nil -> {:error, :forbidden, "Usuário não cadastrado"}
      user -> {:ok, user}
    end
  end

  # 4. Verifica bloqueios
  defp verificar_bloqueio(user, instituicao) do
    if user.bloqueado || instituicao.bloqueado do
      {:error, :forbidden, "Sem permissões de acesso"}
    else
      :ok
    end
  end

end
