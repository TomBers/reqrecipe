defmodule ReqrecipeWeb.PageController do
  use ReqrecipeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
