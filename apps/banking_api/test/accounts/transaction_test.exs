defmodule BankingApi.Accounts.TransactionTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.{Repo, User}
  alias BankingApi.Accounts.Transaction
  alias BankingApi.Accounts.TransactionsResponse

  describe "call/1" do
    test "when IDs and value are valid params, return success" do
      from_user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456"
        })

      to_user =
        Repo.insert!(%User{
          name: "Fulana",
          email: "fulana@mail.com",
          password: "123456"
        })

      params = %{"from" => from_user.id, "to" => to_user.id, "value" => 500}

      assert {:ok,
              %TransactionsResponse{
                from_user: %User{
                  name: "Fulano",
                  id: _id1,
                  balance: _balance1
                },
                to_user: %User{
                  name: "Fulana",
                  id: _id2,
                  balance: _balance2
                }
              }} = Transaction.call(params)
    end

    test "when some ID are invalid, return error in get_user" do
      params = %{"from" => "#{Ecto.UUID.generate()}", "to" => "#{Ecto.UUID.generate()}", "value" => 500}

      assert {:error, :user_not_found} = Transaction.call(params)
    end

    test "when there is no money in the origin account, returns not enough funds" do
      from_user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456",
          balance: 0
        })

      to_user =
        Repo.insert!(%User{
          name: "Fulana",
          email: "fulana@mail.com",
          password: "123456"
        })

      params = %{"from" => from_user.id, "to" => to_user.id, "value" => 500}

      assert {:error, :not_enough_funds} = Transaction.call(params)
    end
  end
end
