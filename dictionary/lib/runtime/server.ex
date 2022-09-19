defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  alias Dictionary.Impl.WordList
  use Agent
  # Abbrevitaion for naming the whole module
  @me __MODULE__


  # Ova funkcija se poziva da se ukljuci proces
  # start_link povezuje procese, sto znaci da ce
  # ovaj proces da bude pokrenut od strane parent procesa.
  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  def random_word() do
    Agent.get(@me, fn state -> WordList.random_word(state) end)
  end
end
