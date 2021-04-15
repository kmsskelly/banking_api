defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/users", UsersController, :create
    post "/users/:id/withdraw", AccountsController, :withdraw

  end
end
