defmodule College.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :password, :string, null: false
      timestamps()
    end

    create unique_index(:users, [:username])

    create table(:students) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :gender, :string
      add :address, :string
      add :email, :string, null: false
      add :date_of_birth, :date, null: false
      timestamps()
    end

    create index(:students, [:inserted_at, :id])
    create unique_index(:students, [:email])

    create table(:teachers) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :email, :string, null: false
      add :gender, :string
      add :address, :string
      add :date_of_birth, :date
      timestamps()
    end

    create index(:teachers, [:inserted_at, :id])
    create unique_index(:teachers, [:email])

    create table(:courses) do
      add :name, :string, null: false
      add :code, :string, null: false
      add :semester, :string, null: false
      add :metadata, :map, null: false
      add :description, :text
      add :teacher_id, references(:teachers)
      timestamps()
    end

    create index(:courses, [:inserted_at, :id])
    create unique_index(:courses, [:code])

    create table(:students_courses) do
      add :course_id, references(:courses, on_delete: :delete_all), primary_key: true
      add :student_id, references(:students, on_delete: :delete_all), primary_key: true
      timestamps()
    end

    create index(:students_courses, [:course_id])
    create index(:students_courses, [:student_id])
    create unique_index(:students_courses, [:course_id, :student_id], name: :student_id_course_id)
  end
end
