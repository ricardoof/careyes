defmodule CareyesWeb.UserLoginLive do
  use CareyesWeb, :live_view

  alias Careyes.Accounts

  def mount(socket) do
    socket
    |> to_form()
  end

  def render(assigns) do
    ~H"""
    <div>
      
    </div>
    """
  end
end
