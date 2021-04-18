defmodule BankingApiWeb.UsersControllerTest do
  use BankingApiWeb.ConnCase, async: true

  alias BankingApi.Repo
  alias BankingApi.User


  describe "POST api/users" do
    test "return sucess when params are valid", ctx do
      params = %{
        name: "Fulano",
        email: "fulano@mail.com",
        password: "123456"
      }

      response =
        ctx.conn
        |> post("/api/users", params)
        |> json_response(201)

      assert %{
               "message" => "User created",
               "user" => %{
                 "balance" => 100_000,
                 "email" => "fulano@mail.com",
                 "id" => _id,
                 "name" => "Fulano"
               }
             } = response
    end

    test "fail when email is already taken", ctx do
      email = "fulano@mail.com"

      Repo.insert!(%User{email: email})

      params = %{
        name: "Fulano",
        email: "fulano@mail.com",
        password: "123456"
      }

      response =
        ctx.conn
        |> post("/api/users", params)
        |> json_response(400)

      assert %{
               "message" => %{"email" => ["has already been taken"]}
             } = response
    end

    test "fail when password have less than 6 characters", ctx do
      params = %{
        name: "Fulano",
        email: "fulano@mail.com",
        password: "123"
      }

      response =
        ctx.conn
        |> post("/api/users", params)
        |> json_response(400)

      assert %{
               "message" => %{"password" => ["should be at least 6 character(s)"]}
             } = response
    end
  end
end
