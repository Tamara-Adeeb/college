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
    query = from u in User, where: u.username == ^username

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

  #####################################################################################
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

  def all_teachers(params) do
    query =
      from t in Teacher,
        order_by: [asc: t.inserted_at, asc: t.id]

    Repo.paginate(query,
      before: params["before"],
      after: params["after"],
      cursor_fields: [:inserted_at, :id],
      include_total_count: true,
      limit: 3
    )
  end

  def all_courses(params) do
    query =
      from c in Course,
        order_by: [asc: c.inserted_at, asc: c.id]

    Repo.paginate(query,
      before: params["before"],
      after: params["after"],
      cursor_fields: [:inserted_at, :id],
      include_total_count: true,
      limit: 3
    )
  end

  #####################################################################################

  def create_student(params) do
    %Student{}
    |> Student.changeset(params)
    |> Repo.insert()
  end

  def create_teacher(params) do
    %Teacher{}
    |> Teacher.changeset(params)
    |> Repo.insert()
  end

  def create_course(params) do
    %Course{}
    |> Course.changeset(params)
    |> Repo.insert()
  end

  def create_course_teacher(params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:teacher, %Teacher{} |> Teacher.changeset(params))
    |> Ecto.Multi.insert(:course, fn %{teacher: teacher} ->
      params = Map.put(params, "teacher_id", teacher.id)
      %Course{} |> Course.changeset(params)
    end)
    |> Repo.transaction()

    # Repo.transaction(fn ->
    #   with {:ok, teacher} <- create_teacher(params),
    #        params <- Map.put(params, "teacher_id", teacher.id),
    #        {:ok, course} <- create_course(params) do
    #     [course, teacher]
    #   else
    #     {:error, changeset} -> Repo.rollback(changeset)
    #   end
    # end)
  end

  #####################################################################################
  def delete_student(id) do
    case Repo.get(Student, id) do
      nil -> {:error, "not found"}
      student -> Repo.delete(student)
    end
  end

  def delete_teacher(id) do
    case Repo.get(Teacher, id) do
      nil -> {:error, "not found"}
      teacher -> Repo.delete(teacher)
    end
  end

  def delete_course(id) do
    case Repo.get(Course, id) do
      nil -> {:error, "not found"}
      course -> Repo.delete(course)
    end
  end

  #####################################################################################

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

  def update_course(params) do
    case Repo.get(Course, params["id"]) do
      nil ->
        {:error, "not found"}

      course ->
        course
        |> Course.changeset(params)
        |> Repo.update()
    end
  end

  def student_register_course(params) do
    %StudentsCourses{}
    |> StudentsCourses.changeset_foreign(params)
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

  def get_courses_for_teacher(id) do
    case Repo.get(Teacher, id) do
      nil ->
        {:error, "not found"}

      teacher ->
        {:ok, teacher |> Repo.preload(:courses)}
    end
  end

  def get_students_for_teacher(id) do
    case Repo.get(Teacher, id) do
      nil ->
        {:error, "not found"}

      teacher ->
        teacher = teacher |> Repo.preload(:courses)
        courses = teacher.courses |> Repo.preload(:students)

        students =
          Enum.flat_map(courses, fn course ->
            course.students
          end)

        {teacher, students}
    end
  end

  def update_semester(course) do
    metadata = Map.from_struct(course.metadata)
    Map.replace(course, :metadata, metadata)

  end
end
