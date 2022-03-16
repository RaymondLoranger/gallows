defmodule GallowsWeb.HangmanView do
  use GallowsWeb, :view

  import Phoenix.LiveView.Helpers

  alias Hangman.Game
  alias Phoenix.HTML
  alias Plug.Conn

  @ids [:arm1, :arm2, :leg1, :leg2, :body, :head, :rope]
  @indexed_ids Enum.with_index(@ids)

  ## Private functions

  @spec opacities(0..7) :: map
  defp opacities(turns_left) do
    for {id, index} <- @indexed_ids, into: %{} do
      {id, if(index < turns_left, do: "opacity-20", else: "opacity-100")}
    end
  end

  @spec game_over?(Game.tally()) :: boolean
  defp game_over?(%{game_state: game_state} = _tally),
    do: game_state in [:won, :lost]

  @spec new_game_button(Conn.t(), String.t()) :: HTML.safe()
  defp new_game_button(conn, width) do
    button("New Game",
      autofocus: true,
      class: "primary-btn #{width}",
      to: Routes.hangman_path(conn, :create_game)
    )
  end

  @spec submit_move :: HTML.safe()
  defp submit_move,
    do: submit("Guess letter", class: "primary-btn w-full")

  @spec space_letters([Game.letter() | charlist]) :: HTML.safe()
  defp space_letters(letters) do
    Enum.map_join(letters, " ", fn
      charlist when is_list(charlist) -> to_string(charlist) |> reveal()
      letter -> letter
    end)
    |> HTML.raw()
  end

  @spec game_state(tally :: Game.tally()) :: HTML.safe()
  defp game_state(%{game_state: :won}), do: state(success: "You Won!")
  defp game_state(%{game_state: :lost}), do: state(danger: "You Lost.")
  defp game_state(%{game_state: :good_guess}), do: state(success: "Good guess!")
  defp game_state(%{game_state: :bad_guess}), do: state(warning: "Bad guess.")
  defp game_state(%{game_state: :already_used}), do: state(info: "Prior guess.")
  defp game_state(_), do: HTML.raw(nil)

  @spec reveal(String.codepoint()) :: String.t()
  defp reveal(letter), do: ~s|<span class="opacity-40">#{letter}</span>|

  @spec state(Keyword.t()) :: HTML.safe()
  defp state([{type, message}]) do
    """
    <div class="state state-#{type}">
      #{message}
    </div>
    """
    |> HTML.raw()
  end
end
