defmodule BankingApi.Accounts.Transaction do
  @moduledoc """
  This module makes transactions between users.
  """
  alias BankingApi.Accounts.TransactionsResponse
  alias BankingApi.{Repo, User}
  alias Ecto.Multi

  import Ecto.Query

  require Logger

  @doc """
  'call/1' function receives the users account IDs and the value of the transaction.
  First, a withdrawals is done in the origin account. Then, a deposit is done in the destination one.
  While the transaction is not finalized, the accounts are locked.
  """
  def call(%{"from" => from_id, "to" => to_id, "value" => value}) when is_integer(value) do
    Multi.new()
    |> Multi.run(:get_from_user, fn _repo, _changes ->
      get_user(from_id)
    end)
    |> Multi.run(:update_from_user, fn repo, %{get_from_user: user} ->
      params = %{balance: user.balance - value}

      params
      |> User.changeset(user)
      |> repo.update()
    end)
    |> Multi.run(:validate_from_balance, fn _repo, %{update_from_user: user} ->
      if user.balance >= 0 do
        {:ok, user}
      else
        {:error, :not_enough_funds}
      end
    end)
    |> Multi.run(:get_to_user, fn _repo, _changes ->
      get_user(to_id)
    end)
    |> Multi.run(:update_to_user, fn repo, %{get_to_user: user} ->
      params = %{balance: user.balance + value}
      params
      |> User.changeset(user)
      |> repo.update()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_to_user: _user}} ->
        {:ok, TransactionsResponse.build(from_id, to_id)}

      {:error, error} ->
        Logger.error("Error in transaction.", reason: inspect(error))
        {:error, error}

      {:error, step, error, _} ->
        Logger.error("Error executing transaction in #{step} step", reason: inspect(error))
        {:error, error}
    end
  end

  defp get_user(id) do
    User
    |> where([u], u.id == ^id)
    |> lock("FOR UPDATE")
    |> Repo.one()
    |> case do
      nil -> {:error, :user_not_found}
      %User{} = user -> {:ok, user}
    end
  end
end
