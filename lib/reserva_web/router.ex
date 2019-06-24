defmodule ReservaWeb.Router do
  use ReservaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug ReservaWeb.Plugs.CasAuthentication, true
    # Can't add this here due to it needing values set in controller
    # instead we add it to all controllers in reserva_web.ex:32
    # plug ReservaWeb.Plugs.Authorization
  end

  pipeline :auth_not_required do
    plug ReservaWeb.Plugs.CasAuthentication, false
    # Can't add this here due to it needing values set in controller
    # instead we add it to all controllers in reserva_web.ex:32
    # plug ReservaWeb.Plugs.Authorization
  end

  scope "/", ReservaWeb do
    pipe_through [:browser, :auth_not_required]

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/rooms", RoomController, only: [:index]
    resources "/subjects", SubjectController, only: [:index]
    resources "/trimester", TrimesterController, only: [:index]
  end

  scope "/", ReservaWeb do
    pipe_through [:browser, :auth]

    get "/login", UserController, :login
    resources "/users", UserController, only: [:edit, :update]
    resources "/rooms", RoomController, only: [:new, :create, :edit, :update]
    resources "/subjects", SubjectController, only: [:new, :create, :edit, :update]
    resources "/trimester", TrimesterController, only: [:new, :create, :edit, :update]
  end
end
