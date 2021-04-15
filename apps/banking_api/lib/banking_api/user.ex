defmodule BankingApi.User do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :email, :password]

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :balance, :integer, default: 100000

    timestamps()
  end

  def changeset(params, struct \\ %__MODULE__{}) do
    struct
    |> cast(params, [:name, :email, :password, :balance])
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> unique_constraint([:email])
    |> check_constraint(:balance, name: :balance_must_be_positive_or_zero)
  end
end
