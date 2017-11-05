defmodule AuthenticationKataWeb.Router do
  use AuthenticationKataWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuthenticationWebKata.Auth, repo: AuthenticationKata.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthenticationKataWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UsersController
  end

  # Other scopes may use custom stacks.
  # scope "/api", AuthenticationKataWeb do
  #   pipe_through :api
  # end
end
