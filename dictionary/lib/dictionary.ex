defmodule Dictionary do

  @opaque t :: Server.t

  defdelegate random_word(), to: Dictionary.Runtime.Server
end
