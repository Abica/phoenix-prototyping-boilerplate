defmodule XxxxXxxxWeb.Router do
  use XxxxXxxxWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(Coherence.Authentication.Session)
    plug Texas.Plug
  end

  pipeline :protected do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Coherence.Authentication.Session, protected: true)
    plug Texas.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through(:browser)
    coherence_routes()
  end

  scope "/" do
    pipe_through(:protected)
    coherence_routes(:protected)
  end

	# public routes
  scope "/", XxxxXxxxWeb do
    pipe_through(:browser)

  end

	# protected routes
  scope "/", XxxxXxxxWeb do
    pipe_through(:protected)
#    get "/", PageController, :index
#    get "/test", PageController, :test

    get "/", TodoController, :index
    post "/update", TodoController, :update
  end
end
