defmodule Careyes.AdonisApi do
  require Logger

  # --- CONFIGURAÇÃO ---
  defp base_url do
    Application.fetch_env!(:careyes, :adonis_api)[:base_url]
  end

  # --- LOGIN ---
  def login(email, password) do
    # 1. MOCK (Simulação)
    if email == "teste@admin.com" and password == "123456" do
      Logger.info("✅ MOCK LOGIN: Sucesso simulado!")

      # Retorna a estrutura exata que o Adonis costuma retornar
      fake_response = %{
        "user" => %{"id" => 999, "email" => email, "nome" => "Tester"},
        "token" => %{"token" => "TOKEN_FALSO_123"}
      }
      {:ok, fake_response}

    else
      # 2. REAL (Conecta no Adonis)
      url = base_url() <> "/login"

      # Usamos Req.post (sem exclamação) para tratar erros de conexão
      case Req.post(url, json: %{email: email, password: password}) do
        {:ok, %{status: 200, body: body}} ->
          {:ok, body} # Sucesso real

        {:ok, %{status: 401}} ->
          {:error, :unauthorized} # Senha errada no banco real

        {:error, _reason} ->
          {:error, :server_error} # Adonis desligado ou erro de rede

        _ ->
          {:error, :server_error}
      end
    end
  end

  # --- LISTAR ---
  def listar_acompanhamentos(token) do
    # 1. MOCK (Simulação)
    # Se o token for aquele que geramos no login falso...
    if token == "TOKEN_FALSO_123" or token == "token_qualquer" do
      Logger.info("✅ MOCK LISTAGEM: Retornando dados falsos...")

      dados_fakes = [
        %{
          "id" => 1,
          "titulo" => "Visita Dona Maria",
          "data_hora" => "2023-11-21 14:00",
          "criada_por_usuario" => "Enf. Joana",
          "paciente_id" => 50,
          "campos" => []
        },
        %{
          "id" => 2,
          "titulo" => "Fisioterapia Sr. João",
          "data_hora" => "2023-11-22 09:30",
          "criada_por_usuario" => "Dr. Carlos",
          "paciente_id" => 51,
          "campos" => []
        }
      ]
      {:ok, dados_fakes}

    else
      # 2. REAL (Conecta no Adonis)
      url = base_url() <> "/acompanhamento-familia" # A rota que vimos no arquivo de rotas

      # O segredo aqui é passar o Header de Autorização
      headers = [{"Authorization", "Bearer #{token}"}]

      case Req.get(url, headers: headers) do
        {:ok, %{status: 200, body: body}} ->
          {:ok, body} # O Adonis retorna a lista JSON aqui

        {:ok, %{status: 401}} ->
          {:error, :unauthorized} # Token expirou ou é inválido

        _ ->
          {:error, :server_error}
      end
    end
  end
end
