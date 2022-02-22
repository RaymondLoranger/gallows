defmodule GallowsWeb.HangmanController do
  use GallowsWeb, :controller

  alias Hangman.{Engine, Game}
  alias Plug.Conn

  require Logger

  @spec new_game(Conn.t(), map) :: Conn.t()
  def new_game(conn, _params) do
    render conn, "new_game.html"
  end

  @spec create_game(Conn.t(), Conn.params()) :: Conn.t()
  def create_game(conn, _params) do
    game_name = Game.random_name()
    :ok = Logger.info("Starting game #{game_name}...")
    Engine.new_game(game_name)
    tally = Engine.tally(game_name)
    render conn, "game_field.html", tally: tally, game_name: game_name
  end

  @spec make_move(Conn.t(), Conn.params()) :: Conn.t()
  def make_move(conn, params) do
    game_name = params["make_move"]["game_name"]
    guess = params["make_move"]["guess"]
    tally = Engine.make_move(game_name, guess)
    conn = put_in(conn.params["make_move"]["guess"], "")
    render conn, "game_field.html", tally: tally, game_name: game_name
  end
end
