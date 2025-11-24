defmodule Careyes.Accounts do
  alias Careyes.Repo
  alias Careyes.Accounts.User
  alias Careyes.Institutions.Instituicao # Supondo que você criará este Schema
  alias Bcrypt

  # Função principal que traduz o `loginUsuario` do Adonis
  def login_com_prefixo(usuario_completo, senha) do
    with {:ok, prefixo, usuario_nome} <- separar_prefixo(usuario_completo),
         {:ok, instituicao} <- buscar_instituicao(prefixo),
         {:ok, user} <- buscar_usuario(usuario_nome, instituicao.id),
         :ok <- verificar_bloqueio(user, instituicao),
         :ok <- verificar_senha(user, senha),
         :ok <- verificar_permissao_familia(user, instituicao) do

      # Se chegou aqui, passou por todas as validações do Adonis!

      # Gerar Token (Aqui usamos um simples, mas em prod use Phoenix.Token ou Guardian)
      token = Phoenix.Token.sign(CareyesWeb.Endpoint, "user_auth", user.id)

      # Retornamos os dados prontos para o Controller
      {:ok, %{
        user: user,
        instituicao: instituicao,
        token: token
      }}
    end
  end

  # --- Funções Privadas (Passo a passo do Adonis) ---

  # JS: if ((usuario_prefixo || '').indexOf('_') === -1)
  defp separar_prefixo(str) do
    case String.split(str, "_", parts: 2) do
      [prefixo, nome] -> {:ok, prefixo, nome}
      _ -> {:error, :forbidden, "Usuario inválido"}
    end
  end

  # JS: Instituicao.query().where('prefixo', `${prefixo}_`).first()
  defp buscar_instituicao(prefixo) do
    # Nota: No Adonis ele busca por "prefixo_", no Elixir faremos igual
    prefixo_busca = "#{prefixo}_"

    case Repo.get_by(Instituicao, prefixo: prefixo_busca) do
      nil -> {:error, :bad_request, "Usuario inválido"} # Mensagem original do Adonis
      instituicao -> {:ok, instituicao}
    end
  end

  # JS: Usuario.query().where('usuario', usuario).where('instituicao_id', ...).first()
  defp buscar_usuario(nome, instituicao_id) do
    case Repo.get_by(User, usuario: nome, instituicao_id: instituicao_id) do
      nil -> {:error, :forbidden, "Usuario não cadastrado"}
      user -> {:ok, user}
    end
  end

  # JS: if (user.bloqueado && instituicao.bloqueado)
  defp verificar_bloqueio(user, instituicao) do
    if user.bloqueado && instituicao.bloqueado do
      {:error, :forbidden, "Sem permissões de acesso"}
    else
      :ok
    end
  end

  # JS: if (!await Hash.verify(senha, user.senha))
  defp verificar_senha(user, senha) do
    if Bcrypt.verify_pass(senha, user.password_hash) do
      :ok
    else
      {:error, :forbidden, "Dados inválidos"}
    end
  end

  # JS: if (user.configuracoes.permissao === 'paciente' && !hasAdditional...)
  defp verificar_permissao_familia(user, instituicao) do
    # Supondo que o campo configuracoes seja um Map no banco
    permissao = user.configuracoes["permissao"]

    # Lógica simulada do hasAdditional (teria que ver o que essa função faz no JS)
    # Vamos assumir que passa por enquanto
    if permissao == "paciente" && !tem_adicional?(instituicao) do
      {:error, :forbidden, "A empresa não utiliza o serviço de compartilhamento..."}
    else
      :ok
    end
  end

  defp tem_adicional?(_instituicao), do: true # Implementar lógica real depois
end
