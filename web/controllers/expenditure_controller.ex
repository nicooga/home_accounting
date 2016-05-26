defmodule HomeAccounting.ExpenditureController do
  use HomeAccounting.Web, :controller
  alias HomeAccounting.{Expenditure, Tagging}

  use HomeAccounting.ResourceController, %{
    resource_model: Expenditure,

    resource_location: &(tag_path(&1, :show, &2)),

    resource_collection: fn(params) ->
      case params do
        %{"filters"=> filters} ->
          Expenditure |> Expenditure.Search.apply_filters(filters)
        _ -> resource_model
      end
    end,

    after_action_success: fn(resource, params) ->
      case params do
        %{"tag_names"=>tag_names} ->
          resource |> Tagging.update_taggings(tag_names)
        _ -> :nothing
      end
    end
  }
end
