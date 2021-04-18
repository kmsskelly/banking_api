defmodule BankingApiWeb.UsersViewTest do
  use BankingApiWeb.ConnCase, async: true

  import Phoenix.View

  alias BankingApi.User
  alias BankingApiWeb.UsersView

  test "renders create.json" do
    params = %{
      name: "Fulano",
      password: "123456",
      email: "fulano@mail.com"
    }

    {:ok, %User{id: user_id} = user} =
      BankingApi.create_user(params)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        id: user_id,
        name: "Fulano",
        email: "fulano@mail.com",
        balance: 100000
      }
    }

    assert expected_response == response
  end
end
