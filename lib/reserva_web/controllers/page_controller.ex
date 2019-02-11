defmodule ReservaWeb.PageController do
  use ReservaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
