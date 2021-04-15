defmodule BankingApiWeb.FallbackController do
  use BankingApiWeb, :controller

  def call(conn, {:error, result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(BankingApiWeb.ErrorView)
    |> render("400.json", result: result)
  end
end
