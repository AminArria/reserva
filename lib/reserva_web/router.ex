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
    plug ReservaWeb.Plugs.CasAuthentication
  end

  scope "/", ReservaWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
  end

  scope "/", ReservaWeb do
    pipe_through [:browser, :auth]

    get "/login", UserController, :login
    resources "/users", UserController, only: [:edit, :update]
  end
end
