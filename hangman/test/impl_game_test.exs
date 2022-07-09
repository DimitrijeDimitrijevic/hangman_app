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
end
