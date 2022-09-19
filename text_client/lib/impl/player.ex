defmodule TextClient.Impl.Player do

  @type game :: Hangman.game()
  @type tally :: Hangman.tally()
  @typep state :: {game, tally}

  @spec start(game()) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congrats, you won!")
  end
  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("Sorry you lost...the word was #{tally.letters |> Enum.join}")
  end
  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

   guess = get_guess()
   updated_tally = Hangman.make_move(game, guess)
    interact({game, updated_tally})
  end

  def current_word(tally) do
    [
    "Word so far: ", tally.letters |> Enum.join(" "),
    "  turns left ", tally.turns_left |> to_string(),
    "  used so far ", tally.used |> Enum.join(" ")
    ]

  end

  def feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I'm thinking of a #{tally.letters |> length} letter word."
  end

  def feedback_for(%{game_state: :good_guess}), do: "Good guess"
  def feedback_for(%{game_state: :bad_guess}), do: "Bad guess"
  def feedback_for(%{game_state: :already_used}), do: "Already used"

  defp get_guess() do
    IO.gets("Next letter: ")
    |> String.trim("\n")
    |> String.downcase()
  end



  # @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

end
