defmodule BankingApiWeb.AccountsController do
  use BankingApiWeb, :controller

  action_fallback(BankingApiWeb.FallbackController)

  def withdraw(conn, params) do
    with {:ok, user} <- BankingApi.withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("update.json", user: user)
    end
  end
end
