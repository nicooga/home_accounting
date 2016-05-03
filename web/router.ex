defmodule HomeAccounting.Router do
  use HomeAccounting.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", HomeAccounting do
    pipe_through :api
  end
end
