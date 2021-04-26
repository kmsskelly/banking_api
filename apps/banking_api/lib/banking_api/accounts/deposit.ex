defmodule BankingApi.Accounts.Deposit do
  @moduledoc """
  Uses the Operation module to make deposits.
  """
  alias BankingApi.Accounts.Operation

  def call(params), do: Operation.call(params, :deposit)
end
