defmodule BankingApi.Users.Create do
  @moduledoc """
  Creates users in the database according to the defined scheme.
  """
  alias BankingApi.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

end
