defmodule College.Teacher do
  alias College.Repo
  import Ecto.Query
  alias College.Schemas.Teacher

  def all_teachers(params) do
    query =
      from(t in Teacher,
        order_by: [asc: t.inserted_at, asc: t.id]
      )

    Repo.paginate(query,
      before: params["before"],
      after: params["after"],
      cursor_fields: [:inserted_at, :id],
      include_total_count: true,
      limit: 3
    )
  end

  def get_teacher(id) do
    Repo.get(Teacher, id)
  end

  def create_teacher(params) do
    %Teacher{}
    |> Teacher.changeset(params)
    |> Repo.insert()
  end

  def delete_teacher(id) do
    case Repo.get(Teacher, id) do
      nil -> {:error, "not found"}
      teacher -> Repo.delete(teacher)
    end
  end

  def update_teacher(params) do
    case Repo.get(Teacher, params["id"]) do
      nil ->
        {:error, "not found"}

      teacher ->
        teacher
        |> Teacher.changeset(params)
        |> Repo.update()
    end
  end

  def get_courses_for_teacher(id) do
    case Repo.get(Teacher, id) do
      nil ->
        {:error, "not found"}

      teacher ->
        teacher = teacher |> Repo.preload(:courses)
        {:ok, teacher.courses}
    end
  end

  def get_students_for_teacher(id) do
    case Repo.get(Teacher, id) do
      nil ->
        {:error, "not found"}

      teacher ->
        teacher = teacher |> Repo.preload(:courses)

        teacher.courses
        |> Repo.preload(:students)
        |> Enum.flat_map(fn course ->
          course.students
        end)
        |> Enum.uniq()
    end
  end
end
