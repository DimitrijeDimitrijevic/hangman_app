defmodule B1Web.HangmanView do
  use B1Web, :view

  @status_fields %{
    initializing: "initializing",
    good_guess: "Good guess!",
    bad_guess: "Sorry, thats a bad guess",
    won: "You won",
    lost: "Sorry, you lost",
    already_used: "You already used that letter"
  }
  def move_status(state) do
    msg = @status_fields[state]

    "<span> #{msg} </span>"
    |> Phoenix.HTML.raw()
  end

  def continue_or_try_again(conn, status) when status in [:won, :lost] do
    button("Try again", to: Routes.hangman_path(conn, :new))

  end
  def continue_or_try_again(conn, _) do
      form_for(conn, Routes.hangman_path(conn, :update), [as: "make_move", method: :put], fn f ->
      [
        text_input(f, :guess),
        submit "Make next guess"
      ]
       end)
  end
  def figure_for(0) do
    ~s{

      ____
      |  |
      |  |
      |  |
      0  |
     /|\\ |
     / \\ |
     ____|__

    }

  end

  def figure_for(1) do
    ~s{

      ____
      |  |
      |  |
      |  |
      0  |
     /|\\|
     /   |
     ____|__

    }
  end

  def figure_for(2) do
    ~s{

      ____
      |  |
      |  |
      |  |
      0  |
     /|\\|
         |
     ____|__

    }
  end

  def figure_for(_), do: "Obesi me"

end
