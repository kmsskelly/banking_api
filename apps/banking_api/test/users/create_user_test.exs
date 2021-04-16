defmodule BankingApi.Users.CreateUserTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Users.Create

  describe "call/1" do
<<<<<<< HEAD
    test "when all params are valid, return an user" do
=======
    test "when all params are valid, returns an user" do
>>>>>>> 8b09eb1e916ff3922b20ccffe0c117a7e354335c
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@mail.com"
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      assert %User{name: "Fulano", id: ^user_id, email: "fulano@mail.com"} = user
    end

<<<<<<< HEAD
    test "make balance 100000 when create account" do
=======
    test "when create the user, balance is 100000" do
>>>>>>> 8b09eb1e916ff3922b20ccffe0c117a7e354335c
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

<<<<<<< HEAD
    test "when the password have less than 6 characters, return an error" do
=======
    test "when the password have less than 6 characters, returns an error" do
>>>>>>> 8b09eb1e916ff3922b20ccffe0c117a7e354335c
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

<<<<<<< HEAD
    test "when there is an invalid email, return an error" do
=======
    test "when there is an invalid email, returns an error" do
>>>>>>> 8b09eb1e916ff3922b20ccffe0c117a7e354335c
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
<<<<<<< HEAD

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
=======
>>>>>>> 8b09eb1e916ff3922b20ccffe0c117a7e354335c
  end
end
