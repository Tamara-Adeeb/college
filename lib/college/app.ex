defmodule College.App do
  alias College.Schemas.{Course, StudentsCourses, Teacher, Student}
  alias College.Schemas.User
  alias College.Repo
  import Ecto.Query

  def create_user(params) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end

  def get_by_username(username) do
    query = from(u in User, where: u.username == ^username)

    case Repo.one(query) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def get_by_id(id) do
    User |> Repo.get(id)
  end

  def authenticate_user(username, password) do
    with {:ok, user} <- get_by_username(username) do
      case validate_password(password, user.password) do
        true -> {:ok, user}
        false -> {:error, :unauthorized}
      end
    else
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  def validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end
end
