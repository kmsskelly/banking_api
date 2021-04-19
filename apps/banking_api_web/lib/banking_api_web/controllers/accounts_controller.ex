defmodule BankingApiWeb.AccountsController do
  use BankingApiWeb, :controller

  action_fallback(BankingApiWeb.FallbackController)

  def deposit(conn, params) do
    with {:ok, user} <- BankingApi.deposit(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", user: user)
    end
  end

  def withdraw(conn, params) do
    with {:ok, user} <- BankingApi.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", user: user)
    end
  end

  def transaction(conn, params) do
    with {:ok, transaction} <- BankingApi.transaction(params) do
      conn
      |> put_status(:ok)
      |> render("transaction.json", transaction: transaction)
    end
  end
end
