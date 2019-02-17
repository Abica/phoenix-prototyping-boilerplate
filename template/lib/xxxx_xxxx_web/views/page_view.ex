defmodule XxxxXxxxWeb.PageView do
  use XxxxXxxxWeb, :view

  def avatar(name \\ "unknown", size \\ 128) do
    "https://api.adorable.io/avatars/#{size}/#{name}"
    "https://api.adorable.io/avatars/#{size}/#{name}@adorable.png"
  end
end
