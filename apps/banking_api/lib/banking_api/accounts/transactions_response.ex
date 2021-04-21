defmodule BankingApi.Accounts.TransactionsResponse do
  @moduledoc """
  Defines a struct to help the view of the transaction.
  """
  alias BankingApi.{Repo, User}

  import Ecto.Query

  defstruct [:from_user, :to_user]

  def build(from_id, to_id) do
    from_user = get_user(from_id)
    to_user = get_user(to_id)

    %__MODULE__{
      from_user: from_user,
      to_user: to_user
    }
  end

  defp get_user(id) do
    User
    |> where([u], u.id == ^id)
    |> Repo.one()
    |> case do
      nil -> {:error, :receiver_user_not_found}
      %User{} = user -> user
    end
  end

end
