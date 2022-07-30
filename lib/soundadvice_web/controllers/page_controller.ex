defmodule SoundadviceWeb.PageController do
  use SoundadviceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
