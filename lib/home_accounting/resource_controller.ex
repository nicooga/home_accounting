defmodule HomeAccounting.ResourceController do
  defmacro __using__(_env) do
    quote do
      use HomeAccounting.Web, :controller
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
        expenditure = Repo.get!(resource_model, id)
        handle_action conn, data, expenditure, action: &(Repo.update(&1))
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
            after_action_success({:ok, resource, resource_params})

            conn
            |> put_resp_header("location", resource_location(conn, :show, resource))
            |> render(:show, data: resource)

          {:error, resource} ->
            after_action_success({:error, resource, resource_params})

            conn
            |> put_status(:unprocessable_entity)
            |> render(:errors, data: resource)
        end
      end

      #defp after_action_success(_result), do: :nothing
    end
  end
end
