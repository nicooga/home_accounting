defmodule HomeAccounting.ExpenditureController do
  use HomeAccounting.Web, :controller

  alias HomeAccounting.Expenditure

  def index(conn, _params) do
    render conn, data: Repo.all(Expenditure)
  end

  def show(conn, %{"id" => id}) do
    render conn, data: Repo.get(Expenditure, id)
  end

  def create(conn, %{"data" => data}) do
    expenditure_params = JaSerializer.Params.to_attributes(data)
    changeset = Expenditure.changeset(%Expenditure{}, expenditure_params)

    case Repo.insert(changeset) do
      {:ok, expenditure} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", expenditure_path(conn, :show, expenditure))
        |> render(:show, data: expenditure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"id" => id, "expenditure" => expenditure_params}) do
    expenditure = Repo.get!(Expenditure, id)
    changeset = Expenditure.changeset(expenditure, expenditure_params)

    case Repo.update(changeset) do
      {:ok, expenditure} ->
        render(conn, data: expenditure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    Repo.get!(Expenditure, id) |> Repo.delete!()
    send_resp(conn, :no_content, "")
  end
end
