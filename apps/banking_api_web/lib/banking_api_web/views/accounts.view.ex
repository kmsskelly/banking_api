defmodule BankingApiWeb.AccountsView do
  alias BankingApi.User

  def render("update.json", %{user: %User{id: user_id, balance: balance}}) do
    %{
      message: "Ballance changed successfully",
      id: user_id,
      balance: balance
    }
  end
end
