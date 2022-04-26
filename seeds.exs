alias College.Repo
alias College.{Student, Course, Teacher, Seed}
alias Faker.Person
alias Faker.Internet
alias Faker.Date
alias Faker.Name
alias Faker.Code
alias Faker.Nato
alias Faker.Lorem
alias Faker.Random

gender = ["male", "female"]
semester = ["first", "second", "third", "fourth"]
faculty = ["history", "engineering", "art", "science", "law"]

for _ <- 1..10 do
  Student.create_student(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email(),
    "date_of_birth" => Date.date_of_birth(),
    "gender" => Enum.random(gender),
    "address" => Faker.Address.state()
  })
end

for _ <- 1..10 do
  Teacher.create_teacher(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email(),
    "date_of_birth" => Date.date_of_birth(),
    "gender" => Enum.random(gender),
    "address" => Faker.Address.state()
  })
end

for _ <- 1..10 do
  faculty_r = Enum.random(faculty)
  semester_r = Enum.random(semester)

  Course.create_course(%{
    "name" => Lorem.word(),
    "code" => Code.isbn(),
    "faculty" => faculty_r,
    "branch" => Seed.branch(faculty_r),
    "semester" => semester_r,
    "metadata" => Seed.metadata(semester_r),
    "description" => Lorem.paragraph(1..2),
    "teacher_id" => Enum.random(1..8)
  })
end

list = Enum.to_list(1..30)

for _ <- 1..5 do
  num = Enum.random(1..10)
  list = List.delete(list, num)

  Student.student_register_course(%{
    "course_id" => Enum.random(1..5),
    "student_id" => num
  })
end

for _ <- 1..5 do
  faculty_r = Enum.random(faculty)
  semester_r = Enum.random(semester)

  Course.create_course_teacher(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email(),
    "date_of_birth" => Date.date_of_birth(),
    "gender" => Enum.random(gender),
    "address" => Faker.Address.state(),
    "name" => Lorem.word(),
    "code" => Code.isbn(),
    "faculty" => faculty_r,
    "branch" => Seed.branch(faculty_r),
    "semester" => semester_r,
    "metadata" => Seed.metadata(semester_r),
    "description" => Lorem.paragraph(1..2)
  })
end
