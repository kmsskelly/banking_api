defmodule BankingApiWeb.AccountsControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.{Repo, User}

  import Ecto.Query

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

    test "when all params are valid, make the withdraw", %{
      conn: conn,
      id: user_id
    } do
      params = %{"value" => 5_000}

      response =
        conn
        |> post("/api/users/#{user_id}/withdraw", params)
        |> json_response(:ok)

      assert %{
               "balance" => 95_000,
               "id" => ^user_id,
               "message" => "Ballance changed successfully"
             } = response
    end

    test "after make a withdrawal, when doing a query in BD, return the updated user",
         %{
           conn: conn,
           id: user_id
         } do
      params = %{"value" => 5_000}
      id = user_id

      conn
      |> post("/api/users/#{user_id}/withdraw", params)

      response =
        User
        |> where([u], u.id == ^id)
        |> Repo.one()

      assert %User{
               name: "Fulano",
               password: "123456",
               id: ^user_id,
               balance: 95_000
             } = response
    end

    test "when ID does not exist, return an error", %{conn: conn, id: _user_id} do
      params = %{"value" => 5_000}
      any_id = Ecto.UUID.generate()

      response =
        conn
        |> post("/api/users/#{any_id}/withdraw", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "user_not_found"
             } = response
    end

    test "when there is not enough money, return an error", %{
      conn: conn,
      id: user_id
    } do
      params = %{"value" => 100_001}

      response =
        conn
        |> post("/api/users/#{user_id}/withdraw", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "not_enough_funds"
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

    test "when all params are valid, make the deposit", %{
      conn: conn,
      id: user_id
    } do
      params = %{"value" => 5_000}

      response =
        conn
        |> post("/api/users/#{user_id}/deposit", params)
        |> json_response(:ok)

      assert %{
               "balance" => 105_000,
               "id" => ^user_id,
               "message" => "Ballance changed successfully"
             } = response
    end

    test "after make a deposit, when doing a query in BD, return the updated user",
         %{
           conn: conn,
           id: user_id
         } do
      params = %{"value" => 5_000}
      id = user_id

      conn
      |> post("/api/users/#{user_id}/deposit", params)

      response =
        User
        |> where([u], u.id == ^id)
        |> Repo.one()

      assert %User{
               name: "Fulano",
               password: "123456",
               id: ^user_id,
               balance: 105_000
             } = response
    end

    test "when ID does not exist, return an error", %{conn: conn, id: _user_id} do
      params = %{"value" => 5_000}
      any_id = Ecto.UUID.generate()

      response =
        conn
        |> post("/api/users/#{any_id}/deposit", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "user_not_found"
             } = response
    end
  end

  describe "POST api/users/transaction" do
    setup %{conn: conn} do
      first_user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456"
        })

      second_user =
        Repo.insert!(%User{
          name: "Fulana",
          email: "fulana@mail.com",
          password: "123456",
          balance: 0
        })

      {:ok, conn: conn, first_id: first_user.id, second_id: second_user.id}
    end

    test "when all params are valid, make the transaction", ctx do
      from_id = ctx.first_id
      to_id = ctx.second_id
      params = %{"from" => from_id, "to" => to_id, "value" => 5_000}

      response =
        ctx.conn
        |> post("/api/users/transaction", params)
        |> json_response(:ok)

      assert %{
               "message" => "Transaction done successfully",
               "transaction" => %{
                 "from_user" => %{
                   "balance" => 95_000,
                   "name" => "Fulano",
                   "id" => ^from_id
                 },
                 "to_user" => %{
                   "balance" => 5_000,
                   "name" => "Fulana",
                   "id" => ^to_id
                 }
               }
             } = response
    end

    test "after make a transaction, when doing a query in BD, return the updated users",
         ctx do
      from_id = ctx.first_id
      to_id = ctx.second_id

      stream =
        User
        |> where([u], u.id == ^from_id or u.id == ^to_id)
        |> Repo.stream()

      response = Repo.transaction(fn -> Enum.to_list(stream) end)

      assert {:ok,
              [
                %User{
                  name: "Fulano",
                  password: "123456",
                  id: ^from_id,
                  balance: 100_000
                },
                %User{
                  name: "Fulana",
                  password: "123456",
                  email: "fulana@mail.com",
                  id: ^to_id,
                  balance: 0
                }
              ]} = response
    end

    test "when there is not enough money in the sender's account, return an error",
         ctx do
      from_id = ctx.second_id
      to_id = ctx.first_id
      params = %{"from" => from_id, "to" => to_id, "value" => 5_000}

      response =
        ctx.conn
        |> post("/api/users/transaction", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "not_enough_funds"
             } = response
    end

    test "when the sender's ID is not valid, return an error", ctx do
      from_id = Ecto.UUID.generate()
      to_id = ctx.second_id
      params = %{"from" => from_id, "to" => to_id, "value" => 5_000}

      response =
        ctx.conn
        |> post("/api/users/transaction", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "user_not_found"
             } = response
    end

    test "when the receiver's ID is not valid, return an error", ctx do
      from_id = ctx.first_id
      to_id = Ecto.UUID.generate()
      params = %{"from" => from_id, "to" => to_id, "value" => 5_000}

      response =
        ctx.conn
        |> post("/api/users/transaction", params)
        |> json_response(:bad_request)

      assert %{
               "message" => "user_not_found"
             } = response
    end
  end
end
