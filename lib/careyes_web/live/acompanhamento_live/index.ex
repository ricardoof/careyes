defmodule CareyesWeb.AcompanhamentoLive.Index do
  use CareyesWeb, :live_view
  alias Careyes.AdonisApi

  @impl true
  def mount(_params, _session, socket) do
    # Chamamos nossa API falsa
    {:ok, lista} = AdonisApi.listar_acompanhamentos("token_qualquer")

    {:ok, assign(socket, :acompanhamentos, lista)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-10">
      <div class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-cyan-700">Acompanhamentos</h1>
        <div class="text-sm text-gray-500">Bem-vindo ao sistema</div>
      </div>

      <div class="grid gap-4">
        <%= for item <- @acompanhamentos do %>
          <div class="bg-white border border-gray-200 rounded-lg p-4 shadow-sm hover:shadow-md transition-shadow">
            <h2 class="text-xl font-semibold text-gray-800"><%= item["titulo"] %></h2>
            <div class="mt-2 text-gray-600">
              <p>📅 Data: <%= item["data"] %></p>
              <p>👩‍⚕️ Responsável: <%= item["responsavel"] %></p>
            </div>
          </div>
        <% end %>
      </div>

      <div class="mt-8">
        <.link href={~p"/logout"} class="text-red-600 hover:underline">
          Sair do Sistema (Logout)
        </.link>
      </div>
    </div>
    """
  end
end
