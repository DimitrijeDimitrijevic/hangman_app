defmodule HangmanAppWeb.Live.Game.Alphabet do
  use HangmanAppWeb, :live_component

  def mount(socket) do
    letters = (?a..?z) |> Enum.map(&<<&1 :: utf8>>)
    socket = assign(socket, :letters, letters)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
    <h3> Letters: </h3>
    <p>
      <%= for l <- @letters do %>
        <a href="#" style="padding: 1rem;" phx-click="make_move" phx-value-key={l}> <%= l %> </a>
        <% end %>
    </p>
    </div>
    """
  end
end
