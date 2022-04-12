alias College.Repo
alias College.App
alias Faker.Person
alias Faker.Internet
alias Faker.Date
alias Faker.Name
alias Faker.Code
alias Faker.Nato
alias Faker.Lorem
alias Faker.Random

for _ <- 1..20 do
  App.create_student(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email(),
    "date_of_birth" => Date.date_of_birth()
  })
end

for _ <- 1..10 do
  App.create_teacher(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email()
  })
end

for _ <- 1..10 do
  App.create_course(%{
    "name" => Lorem.word,
    "code" => Code.isbn(),
    "semester" => Nato.digit_code_word(),
    "description" => Lorem.paragraph(1..2),
    "teacher_id" => Enum.random(1..8)
  })

end

for _ <- 1..10 do
  App.student_register_course(%{
    "course_id" => Enum.random(1..5),
    "student_id" => Enum.random(1..10)
  })
end

for _ <- 1..5 do
  App.create_course_teacher(%{
    "first_name" => Person.first_name(),
    "last_name" => Person.last_name(),
    "email" => Internet.email(),
    "name" => Lorem.word,
    "code" => Code.isbn(),
    "semester" => Nato.digit_code_word(),
    "description" => Lorem.paragraph(1..2)
  })
end
