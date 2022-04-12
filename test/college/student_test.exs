defmodule College.StudentTest do
  use College.DataCase
  alias College.App
  alias College.Pagination

  alias College.Repo

  describe "students" do
    alias College.Schemas.Student

    @valid_attrs %{
      first_name: "Ali",
      last_name: "Adeeb",
      email: "test@gmail.com",
      date_of_birth: "2000-01-01"
    }
    @update_attrs %{first_name: "Reem"}
    @invalid_email_attrs %{
      first_name: "Ali",
      last_name: "Adeeb",
      email: "testgmail.com",
      date_of_birth: "2000-01-01"
    }
    @invalid_required_attrs %{}

    def student_fixture(attrs \\ %{}) do
      {:ok, student} =
        attrs
        |> Enum.into(@valid_attrs)
        |> App.create_student()

      student |> Repo.preload(:courses)
    end

    test "create_student/1 with valid data creates a student" do
      assert {:ok, %Student{} = student} = App.create_student(@valid_attrs)
      assert student.first_name == "Ali"
      assert student.last_name == "Adeeb"
      assert student.email == "test@gmail.com"
      assert student.date_of_birth == ~D[2000-01-01]
    end

    test "email must contain @ to be valid format" do
      changeset = Student.changeset(%Student{}, @invalid_email_attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "email, first name and date of birth are required" do
      changeset = Student.changeset(%Student{}, @invalid_required_attrs)

      assert %{
               email: ["can't be blank"],
               date_of_birth: ["can't be blank"],
               first_name: ["can't be blank"]
             } = errors_on(changeset)
    end
  end
end
