defmodule CareyesWeb.PageController do
  use CareyesWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
