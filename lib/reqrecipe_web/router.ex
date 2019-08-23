defmodule ReqrecipeWeb.Router do
  use ReqrecipeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ReqrecipeWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/recipe", RecipeLive
    live "/count", CountLive
  end

  # Other scopes may use custom stacks.
   scope "/api", ReqrecipeWeb do
     pipe_through :api

     get "/random", ApiController, :random
     get "/number", ApiController, :number
     post "/max", ApiController, :max
     post "/min", ApiController, :min
     post "/filter", ApiController, :filter
     post "/digits", ApiController, :digits

   end
end
