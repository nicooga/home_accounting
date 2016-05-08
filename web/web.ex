defmodule HomeAccounting.Web do
  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias HomeAccounting.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import HomeAccounting.Router.Helpers
      import HomeAccounting.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import HomeAccounting.Router.Helpers
      import HomeAccounting.ErrorHelpers
      import HomeAccounting.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias HomeAccounting.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      import HomeAccounting.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
