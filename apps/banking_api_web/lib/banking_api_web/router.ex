defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/users", UsersController, :create

    post "/users/:id/deposit", AccountsController, :deposit
    post "/users/:id/withdraw", AccountsController, :withdraw
    post "/users/transaction", AccountsController, :transaction

  end
end
