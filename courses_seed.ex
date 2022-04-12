alias College.Repo
alias College.App
alias Faker.Code
alias Faker.Nato
alias Faker.Lorem
alias College.Schemas.Course


  for _ <- 1..10 do
    App.student_register_course(%{
      "idc" => Enum.random(1..5),
      "ids" => Enum.random(1..10)
    })
  end
