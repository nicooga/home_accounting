defmodule HomeAccounting.Router do
  use HomeAccounting.Web, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", HomeAccounting do
    pipe_through :api
    resources "/expenditures", ExpenditureController, except: [:new, :edit]
    resources "/tags", TagController, except: [:new, :edit]
  end
end
