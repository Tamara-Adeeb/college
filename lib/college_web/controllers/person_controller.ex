defmodule CollegeWeb.PersonController do
  use CollegeWeb, :controller
  alias College.{Student, Teacher}
  alias College.Schemas.{Student, Teacher}

  def get_student(conn, %{"id" => id}) do
    case College.Person.get(%Student{}, id) do
      {:ok, student} -> render(conn, "show.json", data: student)
      {:error, _} -> json(conn, %{error: "not found"})
    end
  end

  def get_teacher(conn, %{"id" => id}) do
    case College.Person.get(%Teacher{}, id) do
      {:ok, teacher} -> render(conn, "show.json", data: teacher)
      {:error, _} -> json(conn, %{error: "not found"})
    end
  end
end
