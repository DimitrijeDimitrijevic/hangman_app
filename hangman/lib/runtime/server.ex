defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game
  use GenServer

  @type t :: pid()

  ### This is client process
  ### vezano je za klijenta koji pokrece
  ### ovim pozivom proces kreiranja igre
  ###
  ###
  ###
  ###
  ###

  @idle_timeout 60 * 60 * 1000 # 1 hour
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ### Server process code
  ### ove server kod
  # hendluje sve moguce poziva
  # potrebno da je svaki
  ## handle_call vrati
  ## {odgovor, novu_vrednost, novo stanje}
  def init(_) do
    watcher = Hangman.Runtime.Watchdog.start(@idle_timeout)
    game = Game.new_game()
    {:ok, {game, watcher}}
  end

  def handle_call({:make_move, guess}, _from, {game, watcher}) do
    Hangman.Runtime.Watchdog.im_alive(watcher)
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, {updated_game, watcher}}
  end

  def handle_call({:tally}, _from, {game, watcher}) do
    Hangman.Runtime.Watchdog.im_alive(watcher)
    {:reply, Game.tally(game), {game, watcher}}
  end
end
