defmodule ImplGameTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  def letters_in_ascii([]), do: true
  def letters_in_ascii([head | tail]) do
    if Regex.match?(~r/[a-z]/, head) do
      letters_in_ascii(tail)
    else
      false
    end
  end


  test "new game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end


  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ~w(w o m b a t)
  end

  test "each letter is a lowercase ASCII chars" do
    game = Game.new_game("combat")

    assert letters_in_ascii(game.letters)
  end

  test "game state won't change if won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters use" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")

    assert MapSet.equal?(game.used, MapSet.new(["x","y"]))
  end

  test "we recognize record in a word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "a")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in a word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "a")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "y")
    assert tally.game_state == :bad_guess
  end

 # hello
  test "can handle a sequence of move" do
  [ #guess | state   turns_left letters              used
   [ "a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
   [ "a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
   [ "e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
   [ "x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
  ]
  |> test_sequence_of_moves()
  end

  test "can handle a winning game" do
    [ #guess | state   turns_left letters              used
    [ "a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
    [ "a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
    [ "e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
    [ "x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    [ "h", :good_guess, 5, ["h", "e", "_", "_", "_"], ["a", "e", "x", "h"] |> Enum.sort],
    [ "l", :good_guess, 5, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "l"] |> Enum.sort],
    [ "t", :bad_guess, 4, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "t", "l"] |> Enum.sort]
   ]
   |> test_sequence_of_moves()
  end

  test "can handle a losing game" do
    [ #guess | state   turns_left letters              used
    [ "a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
    [ "a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
    [ "e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
    [ "x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    [ "h", :good_guess, 5, ["h", "e", "_", "_", "_"], ["a", "e", "x", "h"] |> Enum.sort],
    [ "l", :good_guess, 5, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "l"] |> Enum.sort],
    [ "t", :bad_guess, 4, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "t", "l"] |> Enum.sort],
    [ "f", :bad_guess, 3, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "t", "l", "f"] |> Enum.sort],
    [ "p", :bad_guess, 2, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "t", "l", "f", "p"] |> Enum.sort],
    [ "b", :bad_guess, 1, ["h", "e", "l", "l", "_"], ["a", "e", "x", "h", "t", "l", "f", "p", "b"] |> Enum.sort],
    [ "n", :lost, 0, ["h", "e", "l", "l", "o"], ["a", "e", "x", "h", "t", "l", "f", "p", "b", "n"] |> Enum.sort]

  ]

   |> test_sequence_of_moves()
  end

  defp test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end

  test "cannot accept uppercase letters" do
    game = Game.new_game("hangman")
    {game, _tally} = Game.make_move(game, "H")
    assert game.game_state == :not_valid_char

    {game, _tally} = Game.make_move(game, "U")
    assert game.game_state == :not_valid_char

    {game, _tally} = Game.make_move(game, "Y")
    assert game.game_state == :not_valid_char
  end
end
