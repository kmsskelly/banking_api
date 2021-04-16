defmodule BankingApi.Users.CreateUserTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Users.Create

  describe "call/1" do
    test "when all params are valid, returns an user" do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@mail.com"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Fulano", id: ^user_id, email: "fulano@mail.com"} = user
    end

    test "when create the user, balance is 100000" do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@mail.com"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Fulano", id: ^user_id, email: "fulano@mail.com", balance: 100_000} =
               user
    end

    test "when the password have less than 6 characters, returns an error" do
      params = %{
        name: "Fulano",
        password: "12345",
        email: "fulano@mail.com"
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        password: ["should be at least 6 character(s)"]
      }

      assert errors_on(changeset) == expected_response
    end

    test "when there is an invalid email, returns an error" do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@@mail.com"
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        email: ["has invalid format"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
