defmodule LvWeb.Live.MemoryDisplay do
  use LvWeb, :live_view


  # Socket is a connection to the client
  # like a session in regular HTTP type controller
  def mount(_params, _session, socket) do
    current_time = DateTime.utc_now() |> DateTime.truncate(:second) |> to_string()
    Process.send_after(self(), :tick, 1000)
    socket = assign(socket, :current_time, current_time)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1> TIME: <%= @current_time %>  </h1>
    """
  end


  # handle_info callback returns no reply, we do
  # not return anything to the client
  def handle_info(:tick, socket) do
    IO.puts("HERE")
    Process.send_after(self(), :tick, 1000)
    current_time = DateTime.utc_now() |> DateTime.truncate(:second) |> to_string()
    socket = assign(socket, :current_time, current_time)
    {:noreply, socket}
  end
end
