defmodule BankingApi.Accounts.WithdrawTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.{Repo, User}
  alias BankingApi.Accounts.Withdraw

  describe "call/1" do
    test "when ID and value are valid params, return success" do
      user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456"
        })

      params = %{"id" => user.id, "value" => 5000}

      assert {:ok, %User{email: "fulano@mail.com", name: "Fulano", id: _, balance: _, password: "123456"}} = Withdraw.call(params)
    end

    test "when ID are invalid, return error in get_user" do
      params = %{"id" => "#{Ecto.UUID.generate()}", "value" => 5000}

      assert {:error, _error} = Withdraw.call(params)
    end

    test "when there is no money in the account, returns not enough funds" do
      user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456",
          balance: 0
        })

      params = %{"id" => user.id, "value" => 5000}

      assert {:error, _} = Withdraw.call(params)
    end
  end
end
