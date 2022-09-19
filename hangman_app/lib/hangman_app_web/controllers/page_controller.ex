defmodule HangmanAppWeb.PageController do
  use HangmanAppWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn: conn)
    render(conn, "index.html", name: "Dimitrije")
  end

end
