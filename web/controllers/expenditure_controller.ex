defmodule HomeAccounting.ExpenditureController do
  use HomeAccounting.Web, :controller
  alias HomeAccounting.{Expenditure, Tagging}
  use HomeAccounting.ResourceController

  def resource_model, do: Expenditure
  def resource_location(conn, :show, resource) do
    expenditure_path(conn, :show, resource)
  end

  def resource_collection(params) do
    case params do
      %{"filters"=> filters} ->
        Expenditure |> Expenditure.Search.apply_filters(filters)
      _ -> resource_model
    end
  end

  def after_action(:success, resource, params) do
    case params do
      %{"tag_names"=>tag_names} ->
        resource |> Tagging.update_taggings(tag_names)
      _ -> :nothing
    end
  end
end
