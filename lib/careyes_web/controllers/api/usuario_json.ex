defmodule CareyesWeb.Api.UsuarioJSON do

  def login_success(%{dados: %{user: user, instituicao: inst, token: token}}) do
    %{
      instituicao: %{
        id: inst.id,
        nome: inst.nome
      },
      usuario: %{
        id: user.id,
        usuario: user.usuario,
        tipo: user.tipo
      },
      todas_configuracoes: %{
        # Assume que 'configuracoes' no banco já é um mapa salvo
        permissao: user.configuracoes
      },
      configuracoes: %{
        # Acessa a chave "permissao" dentro do mapa
        permissao: user.configuracoes["permissao"]
      },
      access_token: %{
        type: "bearer",
        token: token,
        refreshToken: nil
      }
    }
  end
end
