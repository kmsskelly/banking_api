defmodule BankingApiWeb.AccountsControllerTest do
  use BankingApiWeb.ConnCase, async: true

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

    test "when all params are valid, make the withdraw", %{conn: conn, id: user_id} do
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

    test "when ID does not exist, return an error", %{conn: conn, id: _user_id} do
      params = %{"value" => 5000}
      any_id = Ecto.UUID.generate()

      response =
        conn
        |> post("/api/users/#{any_id}/withdraw", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "user_not_found"
             } = response
    end
  end

  describe "POST api/users/:id/deposit" do
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
        |> post("/api/users/#{user_id}/deposit", params)
        |> json_response(:ok)

      assert %{
               "balance" => _balance,
               "id" => _id,
               "message" => "Ballance changed successfully"
             } = response
    end
  end
end
