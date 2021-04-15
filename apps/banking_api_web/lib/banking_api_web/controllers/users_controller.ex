defmodule BankingApiWeb.UsersController do
  use BankingApiWeb, :controller

  alias BankingApi.User

  action_fallback BankingApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- BankingApi.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
