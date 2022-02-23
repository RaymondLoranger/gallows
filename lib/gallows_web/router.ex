# ┌──────────────────────────────────────────────────────────────┐
# │ Based on the course "Elixir for Programmers" by Dave Thomas. │
# └──────────────────────────────────────────────────────────────┘
defmodule GallowsWeb.Router do
  @moduledoc """
  Web client for the _Hangman Game_.

  ##### Based on the course [Elixir for Programmers](https://codestool.coding-gnome.com/courses/elixir-for-programmers) by Dave Thomas.
  """

  use GallowsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {GallowsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GallowsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/hangman", GallowsWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", HangmanController, :new_game
    post "/", HangmanController, :create_game
    put "/", HangmanController, :make_move
  end

  # Other scopes may use custom stacks.
  # scope "/api", GallowsWeb do
  #   pipe_through :api
  # end
end
