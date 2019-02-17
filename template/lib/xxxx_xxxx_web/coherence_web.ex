defmodule XxxxXxxxWeb.Coherence do
  @moduledoc false

  def view do
    quote do
      use Phoenix.View, root: "lib/xxxx_xxxx_web/templates"
      # Import convenience functions from controllers

      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import XxxxXxxxWeb.ErrorHelpers
      import XxxxXxxxWeb.Gettext
      import XxxxXxxxWeb.Coherence.ViewHelpers

      alias XxxxXxxxWeb.Router.Helpers, as: Routes
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, except: [layout_view: 2]
      use Coherence.Config
      use Timex

      import Ecto
      import Ecto.Query
      import Plug.Conn
      import XxxxXxxxWeb.Gettext
      import Coherence.Controller

      alias Coherence.Config
      alias Coherence.Controller
      alias XxxxXxxxWeb.Router.Helpers, as: Routes

      require Redirects
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
