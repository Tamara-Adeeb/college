defmodule College.Repo.Migrations.AlterStudentTeacher do
  use Ecto.Migration

  def change do
    alter table("students") do
      add(:gender, :string , default: "female")
      add(:address, :string, default: "")
    end

    alter table("teachers") do
      add(:gender, :string , default: "female")
      add(:address, :string, default: "")
      add(:date_of_birth, :date , default: "2000-01-01")
    end

  end

end
