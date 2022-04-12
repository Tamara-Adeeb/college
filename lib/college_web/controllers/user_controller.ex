defmodule CollegeWeb.UserController do
  use CollegeWeb, :controller
  alias College.App

  def register(conn, params) do
    case App.create_user(params) do
      {:ok, user} ->
        json(conn, %{status: "User registerd successfully with username: #{user.username}"})

      {:error, reason} ->
        errors =
          Enum.map(reason.errors, fn message ->
            {
              field,
              {text, validation}
            } = message

            "field #{field}: #{text} #{inspect(validation)}"
          end)

        json(conn, errors)
    end
  end
end
