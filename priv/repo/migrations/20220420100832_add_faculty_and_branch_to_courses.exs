defmodule College.Repo.Migrations.AddFacultyAndBranchToCourses do
  use Ecto.Migration

  def change do
    alter table(:courses) do
      add :faculty, :string, null: false, default: ""
      add :branch, :string
    end
  end
end
