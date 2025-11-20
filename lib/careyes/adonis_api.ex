defmodule Careyes.AdonisApi do
  # Removemos o @base_url fixo

  def login(email, password) do
    url = base_url() <> "/login" # Constrói a URL dinamicamente

    # Req.post! faz uma requisição POST
    response = Req.post!(url, json: %{email: email, password: password})

    case response do
      %{status: 200, body: body} ->
        # O Adonis retornou sucesso!
        # IMPORTANTE: O corpo geralmente traz o token e o usuário.
        # Ex: %{"token" => "...", "user" => %{"id" => 1, ...}}
        {:ok, body}

      %{status: 401} ->
        {:error, :unauthorized}

      _ ->
        {:error, :server_error}
    end
  end

  def listar_acompanhamentos(_token) do
    # Vamos fingir que a API retornou isso:
    dados_fakes = [
      %{
        "id" => 1,
        "titulo" => "Visita Dona Maria",
        "data" => "2023-11-21",
        "responsavel" => "Enfermeira Joana"
      },
      %{
        "id" => 2,
        "titulo" => "Fisioterapia Sr. João",
        "data" => "2023-11-22",
        "responsavel" => "Dr. Carlos"
      }
    ]

    {:ok, dados_fakes}
  end

  # Função privada para buscar a URL correta dependendo do ambiente
  defp base_url do
    Application.fetch_env!(:careyes, :adonis_api)[:base_url]
  end
end
