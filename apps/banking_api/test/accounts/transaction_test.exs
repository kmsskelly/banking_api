defmodule BankingApi.Accounts.TransactionTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.Accounts.Transaction
  alias BankingApi.Accounts.TransactionsResponse
  alias BankingApi.{Repo, User}

  describe "call/1" do
    setup do
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

      {:ok, first_user: first_user.id, second_user: second_user.id}
    end

    test "when IDs and value are valid params, return success", ctx do
      from_id = ctx.first_user
      to_id = ctx.second_user
      params = %{"from" => from_id, "to" => to_id, "value" => 50_000}

      assert {:ok,
              %TransactionsResponse{
                from_user: %User{
                  name: "Fulano",
                  id: ^from_id,
                  balance: 50_000
                },
                to_user: %User{
                  name: "Fulana",
                  id: ^to_id,
                  balance: 50_000
                }
              }} = Transaction.call(params)
    end

    test "when some ID are invalid, return error in get_user" do
      params = %{
        "from" => "#{Ecto.UUID.generate()}",
        "to" => "#{Ecto.UUID.generate()}",
        "value" => 500
      }

      assert {:error, :user_not_found} = Transaction.call(params)
    end

    test "when there is no money in the origin account, returns not enough funds", ctx do
      from_id = ctx.second_user
      to_id = ctx.first_user
      params = %{"from" => from_id, "to" => to_id, "value" => 50_000}

      assert {:error, :not_enough_funds} = Transaction.call(params)
    end
  end
end
