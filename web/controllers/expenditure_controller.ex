defmodule HomeAccounting.ExpenditureController do
  use HomeAccounting.Web, :controller

  alias HomeAccounting.Expenditure

  plug :scrub_params, "expenditure" when action in [:create, :update]

  def index(conn, _params) do
    expenditures = Repo.all(Expenditure)
    render(conn, "index.json", expenditures: expenditures)
  end

  def create(conn, %{"expenditure" => expenditure_params}) do
    changeset = Expenditure.changeset(%Expenditure{}, expenditure_params)

    case Repo.insert(changeset) do
      {:ok, expenditure} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", expenditure_path(conn, :show, expenditure))
        |> render("show.json", expenditure: expenditure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HomeAccounting.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    expenditure = Repo.get!(Expenditure, id)
    render(conn, "show.json", expenditure: expenditure)
  end

  def update(conn, %{"id" => id, "expenditure" => expenditure_params}) do
    expenditure = Repo.get!(Expenditure, id)
    changeset = Expenditure.changeset(expenditure, expenditure_params)

    case Repo.update(changeset) do
      {:ok, expenditure} ->
        render(conn, "show.json", expenditure: expenditure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HomeAccounting.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    expenditure = Repo.get!(Expenditure, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(expenditure)

    send_resp(conn, :no_content, "")
  end
end
