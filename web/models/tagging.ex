defmodule HomeAccounting.Tagging do
  use HomeAccounting.Web, :model
  alias HomeAccounting.{Tag, Repo}

  schema "abstract table: taggings" do
    field :assoc_id, :integer
    belongs_to :tag, Tag
  end

  def update_taggings(taggable, tag_names) do
    Repo.transaction fn->
      taggable
      |> create_taggings(tag_names)
      |> delete_taggings(tag_names)
    end
  end

  defp create_taggings(taggable, tag_names) do
    for tag_name <- tag_names do
      tag_name
      |> get_or_create_tag_by_name
      |> create_tagging_if_not_exists(taggable)
    end

    taggable
  end

  defp delete_taggings(taggable, tag_names) do
    Repo.delete_all(
      from tagging in assoc(taggable, :taggings),
        join: tag in assoc(tagging, :tag),
        where: not tag.name in(^tag_names)
    )

    taggable
  end

  defp get_or_create_tag_by_name(name) do
    case Tag.get_by_name(name) do
      tag -> tag
      nil -> %Tag{name: name} |> Repo.insert!
    end
  end

  defp create_tagging_if_not_exists(tag, taggable) do
    unless Repo.get_by(assoc(taggable, :taggings), tag_id: tag.id) do
      build_assoc(taggable, :taggings, tag_id: tag.id) |> Repo.insert!
    end
  end
end
