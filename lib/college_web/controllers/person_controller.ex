defmodule CollegeWeb.PersonController do
  use CollegeWeb, :controller
  alias College.App

  def get_student(conn, %{"id" => id}) do
    case App.get_student(id) do
      nil ->
        json(conn, %{error: "not found"})

      student ->
        student = College.Person.get(student) |> IO.inspect()
        render(conn, "show.json", data: student)
    end
  end

  def get_teacher(conn, %{"id" => id}) do
    case App.get_teacher(id) do
      nil ->
        json(conn, %{error: "not found"})

      teacher ->
        teacher = College.Person.get(teacher)
        render(conn, "show.json", data: teacher)
    end
  end
end
