defmodule BankingApiWeb.UsersView do
  alias BankingApi.User

  def render("create.json", %{
        user: %User{
          id: id,
          name: name,
          email: email,
          balance: balance
        }
      }) do
    %{
      message: "User created",
      user: %{
        id: id,
        name: name,
        email: email,
        balance: balance
      }
    }
  end
end
