defmodule BankingApi.Accounts.Withdraw do
  alias BankingApi.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:withdraw)
  end
end