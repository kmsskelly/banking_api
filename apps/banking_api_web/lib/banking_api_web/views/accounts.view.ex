defmodule BankingApiWeb.AccountsView do
  alias BankingApi.User

  def render("update.json", %{user: %User{id: user_id, balance: balance}}) do
    %{
      message: "Ballance changed successfully",
      id: user_id,
      balance: balance
    }
  end

  def render("transaction.json", %{transaction: %{to_user: to_user, from_user: from_user}}) do
    %{
      message: "Transaction done successfully",
      transaction: %{
        from_user: %{
          name: from_user.name,
          id: from_user.id,
          balance: from_user.balance
        },
        to_user: %{
          name: to_user.name,
          id: to_user.id,
          balance: to_user.balance
        }
      }
    }
  end
end
