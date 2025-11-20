defmodule CareyesWeb.UserLoginLive do
  use CareyesWeb, :live_view

  alias Careyes.Accounts

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"usuario" => "", "senha" => ""})
    {:ok, assign(socket, form: form)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex min-h-screen w-full flex-col md:flex-row">
      <div class="flex w-full items-center justify-center bg-white p-6 md:w-1/2 md:p-12 lg:p-24">
        <div class="w-full max-w-sm">
          <img
            src={~p"/images/logo-careyes.png"}
            alt="CareYes"
            class="mx-auto w-full max-w-[180px]"
          />
          <div class="mt-12 text-left md:mt-16">
            <h2 class="mb-8 text-lg font-semibold text-gray-700">
              Por favor, faça login na sua conta.
            </h2>

            <.form
              for={@form}
              phx-submit="login"
              class="flex flex-col gap-5"
            >
              <.input
                field={@form[:usuario]}
                type="text"
                label="Usuário"
                placeholder="Seu usuário"
              />
              <.input
                field={@form[:senha]}
                type="password"
                label="Senha"
                placeholder="*******"
              />
              <button
                type="submit"
                phx-disable-with="Entrando..."
                class="mt-3 h-10 w-full rounded-full bg-gradient-to-r from-cyan-500 to-blue-600 px-6 text-[15px] font-bold text-white normal-case transition-all hover:from-cyan-600 hover:to-blue-700"
              >
                Entrar no CareYes
              </button>
              <button
                type="button"
                class="mt-2 h-10 w-full rounded-full bg-transparent text-sm font-normal text-gray-500 normal-case transition-all hover:bg-gray-100"
              >
                Esqueceu a senha?
              </button>
            </.form>
          </div>
        </div>
      </div>

      <div class="relative flex w-full items-center justify-center bg-cover bg-center p-12 md:w-1/2 md:p-6 lg:p-20"
           style={"background-image: url(" <> ~p"/images/care-background.jpg" <> ");"}>
        <div class="absolute inset-0 bg-gradient-to-r from-blue-700 to-cyan-600 opacity-90"></div>
        <div class="relative w-full max-w-md">
          <h1 class="text-3xl font-bold text-white md:text-4xl">
            Gestão inteligente para sua Home Care.
          </h1>
          <p class="mt-6 hidden text-base leading-relaxed text-white/90 md:block">
            O CareYes surgiu para acabar com planilhas e reduzir a “papelada” nas empresas de
            Home Care e Assistência Domiciliar de Saúde.
          </p>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("login", %{"usuario" => email, "senha" => password}, socket) do
    case Accounts.authenticate_user(email, password) do
      # Sucesso: O Mock/API retorna um mapa com "user" e "token"
      {:ok, api_response} ->
        user = api_response["user"]
        # Dependendo de como você fez o mock, o token pode estar aninhado ou direto
        # Vamos tentar pegar de forma segura
        token_data = api_response["token"]
        token = if is_map(token_data), do: token_data["token"], else: token_data

        {:noreply,
         socket
         |> put_flash(:info, "Login realizado!")
         # Redireciona para /acompanhamentos e salva ID e Token na sessão
         |> push_redirect(to: "/acompanhamentos", session: %{
              "user_id" => user["id"],
              "auth_token" => token
            })}

      # Erro: Login falhou
      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "Usuário ou senha inválidos.")}
    end
  end
end
