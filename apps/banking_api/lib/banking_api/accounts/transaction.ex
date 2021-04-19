defmodule BankingApi.Accounts.Transaction do
  alias BankingApi.Accounts.{Deposit, Withdraw}
  alias BankingApi.Accounts.TransactionsResponse

  require Logger

  def call(%{"from" => from_id, "to" => to_id, "value" => value}) when is_integer(value) do
    params_withdraw = %{"id" => from_id, "value" => value}
    params_deposit = %{"id" => to_id, "value" => value}

    params_withdraw
    |> Withdraw.call()
    |> case do
      {:ok, from_user} ->
        Deposit.call(params_deposit)
        |> case do
          {:ok, to_user} ->
            Logger.info("Successfully done")
            {:ok, TransactionsResponse.build(from_user, to_user)}

          {:error, error} ->
            Logger.error("Error in transaction.", reason: inspect(error))
            {:error, error}
        end

      {:error, error} ->
        Logger.error("Error in withdraw.", reason: inspect(error))
        {:error, error}
      end
  end
end
