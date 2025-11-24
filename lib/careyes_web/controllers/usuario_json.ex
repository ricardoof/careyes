defmodule CareyesWeb.UsuarioJSON do

  def login_success(%{result: data}) do
    %{
      instituicao: %{
        id: data.instituicao.id,
        nome: data.instituicao.nome
      },
      usuario: %{
        id: data.user.id,
        usuario: data.user.usuario, # O nome de usuário sem prefixo
        tipo: data.user.tipo
      },
      todas_configuracoes: %{
        permissao: data.user.configuracoes # Supondo que seja um mapa
      },
      configuracoes: %{
        permissao: data.user.configuracoes["permissao"],
        submenu: data.user.configuracoes["permissao_usuario"]
      },
      access_token: %{
        type: "bearer",
        token: data.token,
        refreshToken: nil
      }
    }
  end
end
