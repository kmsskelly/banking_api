defmodule BankingApi.Users.Create do
  alias BankingApi.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

end
