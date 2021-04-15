defmodule BankingApi.Accounts.Withdraw do
  alias BankingApi.Repo
  alias BankingApi.User
  alias Ecto.Multi

  import Ecto.Query

  require Logger

  def call(%{"id" => id, "value" => value}) do
    Multi.new()
    |> Multi.run(:get_user, fn repo, _changes ->
      User
      |> where([u], u.id == ^id)
      |> lock("FOR UPDATE")
      |> repo.one()
      |> case do
        nil -> {:error, :user_not_found}
        %User{} = user -> {:ok, user}
      end
    end)
    |> Multi.run(:update_user, fn repo, %{get_user: user} ->
      params = %{balance: user.balance - value}

      params
      |> User.changeset(user)
      |> repo.update()
    end)
    |> Multi.run(:validate_balance, fn _repo, %{update_user: %User{balance: updated_balance}} ->
      if updated_balance >= 0 do
        {:ok, :balance_updated}
      else
        {:error, :not_enough_funds}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        Logger.info("Successfully done")
        :ok

      {:error, error} ->
        Logger.error("Error in withdraw.", reason: inspect(error))
        {:error, error}

      {:error, step, error, _} ->
        Logger.error("Error executing withdraw in #{step} step", reason: inspect(error))
        {:error, error}
    end
  end
end
