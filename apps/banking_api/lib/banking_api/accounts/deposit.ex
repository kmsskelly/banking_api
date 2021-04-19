defmodule BankingApi.Accounts.Deposit do
  alias BankingApi.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:deposit)
  end
end
