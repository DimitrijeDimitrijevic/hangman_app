defmodule HangmanAppWeb.Live.Game.Figure do
  use HangmanAppWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <h1> In figure </h1>
    """
  end
end
