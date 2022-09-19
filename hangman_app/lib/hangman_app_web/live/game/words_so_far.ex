defmodule HangmanAppWeb.Live.Game.WordsSoFar do
  use HangmanAppWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      <div>
      <p>
      Turns left:
      <%= @tally.turns_left %>
      </p>
      <p> State:
      <%= @tally.game_state %>
      </p>
      <p>
        Used: <%= @tally.used |> Enum.join(", ") %>
      </p>
      <p> Letters:
        <%= for letter <- @tally.letters do %>
          <%= letter %>
        <% end %>
      </p>

      </div>
    """
  end
end
