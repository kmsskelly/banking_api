defmodule BankingApi.Accounts.Withdraw do
  @moduledoc """
  Uses the Operation module to make withdrawals.
  """
  alias BankingApi.Accounts.Operation

  def call(params) do
    params
    |> Operation.call(:withdraw)
  end
end
