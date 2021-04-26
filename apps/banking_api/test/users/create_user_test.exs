defmodule BankingApi.Users.CreateUserTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Users.Create

  describe "call/1" do
    test "when all params are valid, return an user" do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@mail.com"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Fulano", id: ^user_id, email: "fulano@mail.com"} = user
    end

    test "make balance 100000 when create account" do
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

    test "when the password have less than 6 characters, return an error" do
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

    test "when there is an invalid email, return an error" do
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

    test "when email is already taken, return an error" do
      Repo.insert!(%User{
        name: "Fulano",
        email: "fulano@mail.com",
        password: "123456"
      })

      params = %{
        name: "Fulano",
        email: "fulano@mail.com",
        password: "123456"
      }

      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                changes: _,
                errors: [email: {"has already been taken", _other}]
              }} = Create.call(params)
    end
  end
end
