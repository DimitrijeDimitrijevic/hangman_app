defmodule HangmanAppWeb.Live.Game do
  use HangmanAppWeb, :live_view

  alias HangmanAppWeb.Live.Game.{Figure, Alphabet}

  def mount(_params, _session, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket
    |> assign(%{game: game, tally: tally})
    |> then(fn socket -> {:ok, socket} end)
  end

  def handle_event("make_move", %{"key" => key}, socket) do
    game = socket.assigns.game
    tally = Hangman.make_move(game, key)
    socket = assign(socket, tally: tally)
    {:noreply, socket}
  end

  def handle_event("restart_game", _params, socket) do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    socket = assign(socket, %{game: game, tally: tally})
    {:noreply, socket}
  end

  def handle_event("redirect", _params, socket) do
    socket = redirect(socket, to: Routes.page_path(socket, :index))
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <div phx-window-keyup="make_move">
      <%= live_component(Figure, tally: @tally, id: 1) %>
      <%= live_component(Alphabet, tally: @tally, id: 2) %>
      <%= live_component(HangmanAppWeb.Live.Game.WordsSoFar, tally: @tally, id: 3) %>
      <button phx-click="restart_game">
        New game
      </button>

      <a href="#" phx-click="redirect"> Redirect </a>
      </div>
    """
  end


end
