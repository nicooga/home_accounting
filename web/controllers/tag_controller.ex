defmodule HomeAccounting.TagController do
  use HomeAccounting.Web, :controller
  alias HomeAccounting.Tag

  use HomeAccounting.ResourceController, %{
    resource_model: Tag,
    resource_location: &(tag_path(&1, :show, &2))
  }
end
