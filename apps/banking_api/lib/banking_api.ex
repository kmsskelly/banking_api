defmodule BankingApi do
  @moduledoc """
  BankingApi keeps the contexts that define the domain
  and business logic.
  """

  alias BankingApi.Users.Create, as: UserCreate
  alias BankingApi.Accounts.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call

end
