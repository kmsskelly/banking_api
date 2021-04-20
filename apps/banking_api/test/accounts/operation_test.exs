defmodule BankingApi.Accounts.OperationTest do
  @moduledoc """
  Tests the operations of withdrawal and deposit.
  """
  use BankingApi.DataCase, async: true

  alias BankingApi.Accounts.Operation
  alias BankingApi.{Repo, User}

  describe "call/2" do
    setup do
      user =
        Repo.insert!(%User{
          name: "Fulano",
          email: "fulano@mail.com",
          password: "123456"
        })

      {:ok, id: user.id}
    end

    test "when ID and value are valid params, return success", ctx do
      id = ctx.id
      params = %{"id" => id, "value" => 5_000}

      assert {:ok,
              %User{
                email: "fulano@mail.com",
                name: "Fulano",
                id: ^id,
                balance: 95_000,
                password: "123456"
              }} = Operation.call(params, :withdraw)
    end

    test "when ID are invalid, return error in get_user" do
      params = %{"id" => "#{Ecto.UUID.generate()}", "value" => 5_000}

      assert {:error, :user_not_found} = Operation.call(params, :withdraw)
    end

    test "when there is no money in the account, returns not enough funds", ctx do
      params = %{"id" => ctx.id, "value" => 200_000}

      assert {:error, :not_enough_funds} = Operation.call(params, :withdraw)
    end
  end
end
