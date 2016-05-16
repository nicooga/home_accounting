defmodule HomeAccounting.ExpenditureController do
  use HomeAccounting.Web, :controller
  alias HomeAccounting.{Expenditure,Tag}
  use HomeAccounting.ResourceController

  defp resource_model, do: Expenditure
  defp resource_location(conn, :show, resource) do
    expenditure_path(conn, :show, resource)
  end

  defp after_action_success({:ok, resource, params}) do
    case params do
      %{"tag_names"=>tag_names} ->
        find_or_create_taggings(resource, tag_names)
      _ -> true
    end
  end

  defp find_or_create_taggings(expenditure, tag_names) do
    for tag_name <- tag_names do
      Repo.all(Tag |> Tag.find_by_name(tag_name))
      |> case do
        [tag] -> tag
        [] -> %Tag{name: tag_name} |> Repo.insert!
      end
      |> fn(tag)->
        build_assoc(expenditure, :taggings, tag_id: tag.id)
        |> HomeAccounting.Repo.insert!
      end.()
    end
  end
end
