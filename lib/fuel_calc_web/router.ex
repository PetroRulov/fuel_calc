defmodule FuelCalcWeb.Router do
  @moduledoc false

  use FuelCalcWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FuelCalcWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FuelCalcWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/fuel", FcController, :define_routes
    post "/fuel", FcController, :calculate
    get "/fuel/:result", FcController, :result
  end

  # scope "/api", FuelCalcWeb do
  #  pipe_through :api
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
