defmodule CareyesWeb.Router do
  use CareyesWeb, :router

  pipeline :public do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CareyesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :private do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CareyesWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CareyesWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Rotas que todos podem ver, como login, registro, etc.
  scope "/", CareyesWeb do
    pipe_through :public

    live "/login", UserLoginLive
  end

  # Rotas que SÓ usuários logados podem ver.
  scope "/", CareyesWeb do
    pipe_through :private

    get "/", PageController, :home
    get "/logout", SessionController, :delete
    live "/acompanhamentos", AcompanhamentoLive.Index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CareyesWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:careyes, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :public

      live_dashboard "/dashboard", metrics: CareyesWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
