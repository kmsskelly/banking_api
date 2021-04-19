defmodule BankingApi.Accounts.Deposit do
  @moduledoc """
  Uses the Operation module to make deposits.
  """
  alias BankingApi.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:deposit)
  end
end
