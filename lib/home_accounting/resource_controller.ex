defmodule HomeAccounting.ResourceController do
  defmacro __using__({:%{}, _, opts_list}) do
    quote do
      use Phoenix.Controller
      alias HomeAccounting.Repo

      def index(conn, params) do
        render conn, data: Repo.all(resource_collection(params))
      end

      def show(conn, %{"id"=>id}) do
        render conn, data: Repo.get(resource_model, id)
      end

      def create(conn, %{"data" => data}) do
        handle_action conn, data, struct(resource_model), action: &(Repo.insert(&1))
      end

      def update(conn, %{"id"=>id, "data"=>data}) do
        resource = Repo.get!(resource_model, id)
        handle_action conn, data, resource, action: &(Repo.update(&1))
      end

      def delete(conn, %{"id" => id}) do
        Repo.get!(resource_model, id) |> Repo.delete!()
        send_resp(conn, :no_content, "")
      end

      defp handle_action(conn, data, resource, keyword_list) do
        action = keyword_list[:action]

        resource_params = JaSerializer.Params.to_attributes(data)
        changeset = resource_model.changeset(resource, resource_params)

        case action.(changeset) do
          {:ok, resource} ->
            after_action_success resource, resource_params

            conn
            |> put_resp_header("location", resource_location(conn, resource))
            |> render(:show, data: resource)

          {:error, resource} ->
            after_action_error resource, resource_params

            conn
            |> put_status(:unprocessable_entity)
            |> render(:errors, data: resource)
        end
      end

      defp resource_collection(params) do
        case get_opt_func(:resource_collection) do
          {:ok, func} -> func.(params)
          :not_found -> resource_model
        end
      end

      defp resource_model do
        unquote(opts_list) |> Keyword.fetch!(:resource_model)
      end

      defp after_action_error(resource, resource_params) do
        case get_opt_func(:after_action_error) do
          {:ok, func} -> func.(resource, resource_params)
          :not_found -> :nothing
        end
      end

      defp after_action_success(resource, resource_params) do
        case get_opt_func(:after_action_success) do
          {:ok, func} -> func.(resource, resource_params)
          :not_found -> :nothing
        end
      end

      defp resource_location(conn, resource) do
        case get_opt_func(:resource_location) do
          {:ok, func} -> func.(conn, resource)
        end
      end

      defp get_opt_func(name) do
        case unquote(opts_list) |> Keyword.fetch(name) do
          {:ok, func} when is_function(func) -> {:ok, func}
          :error -> :not_found
        end
      end
    end
  end
end
