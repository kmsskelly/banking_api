defmodule BankingApi.Accounts.TransactionsResponse do
  @moduledoc """
  Defines a struct to help the view of the transaction.
  """
  defstruct [:from_user, :to_user]

  def build(from_user, to_user) do
    %__MODULE__{
      from_user: from_user,
      to_user: to_user
    }
  end
end
