defmodule XxxxXxxxWeb.PageController do
  use XxxxXxxxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", welcome_text: "Welcome to Phoenix!")
  end

  def test(conn, _params) do
    render(conn, "test.html", welcome_text: "Welcome to Phoenix!")
  end
end
