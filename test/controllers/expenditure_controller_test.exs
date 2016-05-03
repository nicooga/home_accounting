defmodule HomeAccounting.ExpenditureControllerTest do
  use HomeAccounting.ConnCase

  alias HomeAccounting.Expenditure
  @valid_attrs %{amount: "some content", desc: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, expenditure_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    expenditure = Repo.insert! %Expenditure{}
    conn = get conn, expenditure_path(conn, :show, expenditure)
    assert json_response(conn, 200)["data"] == %{"id" => expenditure.id,
      "desc" => expenditure.desc,
      "amount" => expenditure.amount}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, expenditure_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, expenditure_path(conn, :create), expenditure: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Expenditure, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, expenditure_path(conn, :create), expenditure: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    expenditure = Repo.insert! %Expenditure{}
    conn = put conn, expenditure_path(conn, :update, expenditure), expenditure: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Expenditure, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    expenditure = Repo.insert! %Expenditure{}
    conn = put conn, expenditure_path(conn, :update, expenditure), expenditure: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    expenditure = Repo.insert! %Expenditure{}
    conn = delete conn, expenditure_path(conn, :delete, expenditure)
    assert response(conn, 204)
    refute Repo.get(Expenditure, expenditure.id)
  end
end
