defmodule BankingApiWeb.AccountsControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.AccountsController
  alias BankingApi.Repo
  alias BankingApi.User

  describe "POST api/users/:id/withdraw" do
    setup %{conn: conn} do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@mail.com"
      }

      {:ok, %User{id: user_id}} = BankingApi.create_user(params)
      {:ok, conn: conn, id: user_id}
    end

    test "when all params are valid, make the deposit", %{conn: conn, id: user_id} do
      params = %{"value" => 5000}

      response =
        conn
        |> post("/api/users/#{user_id}/withdraw", params)
        |> json_response(:ok)

      assert %{
               "balance" => _balance,
               "id" => _id,
               "message" => "Ballance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, id: user_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post("/api/users/#{user_id}/withdraw", params)
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
