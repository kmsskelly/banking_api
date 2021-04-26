defmodule BankingApi.UserTest do
  use BankingApi.DataCase

  alias BankingApi.User

  describe "changeset/1" do
    test "create a valid changeset when it receives valid params and c" do
      assert BankingApi.Repo.all(User) == []

      params = %{
        name: "fulano",
        email: "fulano@mail.com",
        password: "1234567"
      }

      assert %Ecto.Changeset{
               valid?: true,
               changes: %{
                 email: "fulano@mail.com",
                 name: "fulano",
                 password: "1234567"
               }
             } = User.changeset(params)
    end

    test "when the password have less than 6 characters, return an error" do
      assert BankingApi.Repo.all(User) == []

      params = %{
        name: "Fulano",
        password: "12345",
        email: "fulano@mail.com"
      }

      assert %Ecto.Changeset{
               valid?: false,
               changes: _,
               errors: [password: {"should be at least %{count} character(s)", _other}]
             } = User.changeset(params)
    end

    test "when there is an invalid email, return an error" do
      params = %{
        name: "Fulano",
        password: "123456",
        email: "fulano@@mail.com"
      }

      assert %Ecto.Changeset{
               valid?: false,
               changes: _,
               errors: [{:email, {"has invalid format", [validation: :format]}}]
             } = User.changeset(params)
    end
  end
end
