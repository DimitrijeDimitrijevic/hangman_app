defmodule Hangman.Impl.Game do

  alias Hangman.Type

  # Whole Module type
  # references to this module
  # The convetion is that the module type is t
  @type t :: %__MODULE__ {
    turns_left: integer(),
    game_state: Type.state,
    letters: list(String.t()),
    used: MapSet.t(String.t())
  }

  # This is Game
  # Ova struktura nam pokazuje igru,
  # njeno stanje, broj ostalih pokusaja
  # koja slova ima rec
  # iskoriscena slova
  # Njeno stanje se menja kada svaki put pokusamo da pogodimo rec dajuci jedno slovo
  # to vraca pricu. Prica je mapa od istih ovih polja kao struktura, samo sto nema inicijalne vrednosti
  # vec se uzimaju vrednosti od trenutne igre,
  defstruct(
    turns_left: 20,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    Dictionary.random_word()
    |> new_game()

  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ########################################

  @spec make_move(t, String.t) :: {t, Type.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:lost, :won] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    maybe_accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  #######################################

  defp maybe_accept_guess(game, guess, alredy_used_letter) do
    is_ascii_lowercase?(guess)
    |> accept_guess(game, guess, alredy_used_letter)
  end

  defp accept_guess(accept_or_not, game, guess, already_used_letter)
  defp accept_guess(_, game, _guess, true) do
    %{game | game_state: :already_used}
  end
  defp accept_guess(true, game, guess, false) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp accept_guess(false, game, _guess, _already_used) do
    %{game | game_state: :not_valid_char}
  end

  defp is_ascii_lowercase?(guess), do: Regex.match?(~r/[a-z]/, guess)

  defp score_guess(game, true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  #########################################

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp reveal_guessed_letters(game = %{game_state: :lost}) do
    game.letters
  end
  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(false, _letter), do: "_"
end
