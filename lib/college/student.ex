defmodule College.Student do
  alias College.Repo
  import Ecto.Query
  alias College.Schemas.{Student, StudentsCourses}

  def all_students(params) do
    query =
      from s in Student,
        order_by: [asc: s.inserted_at, asc: s.id]

    Repo.paginate(query,
      before: params["before"],
      after: params["after"],
      cursor_fields: [:inserted_at, :id],
      include_total_count: true,
      limit: 3
    )
  end

  def get_student(id) do
    Repo.get(Student, id)
  end

  def create_student(params) do
    %Student{}
    |> Student.changeset(params)
    |> Repo.insert()
  end

  def delete_student(id) do
    case Repo.get(Student, id) do
      nil -> {:error, "not found"}
      student -> Repo.delete(student)
    end
  end

  def update_student(params) do
    case Repo.get(Student, params["id"]) do
      nil ->
        {:error, "not found"}

      student ->
        student
        |> Student.changeset(params)
        |> Repo.update()
    end
  end

  def student_register_course(params) do
    %StudentsCourses{}
    |> StudentsCourses.changeset(params)
    |> Repo.insert()
  end

  def cancel_register_course(student_id, course_id) do
    query =
      from sc in StudentsCourses,
        where: sc.student_id == ^student_id and sc.course_id == ^course_id

    case Repo.one(query) do
      nil -> {:error, "not found"}
      result -> Repo.delete(result)
    end
  end
end
