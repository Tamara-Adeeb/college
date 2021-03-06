defmodule CollegeWeb.Router do
  use CollegeWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(College.Authentication.Pipeline)
  end

  scope "/api", CollegeWeb do
    pipe_through(:api)

    post("/users", UserController, :register)
    post("/session/new", SessionController, :new)
  end

  scope "/api", CollegeWeb do
    pipe_through([:api, :auth])

    post("/session/refresh", SessionController, :refresh)
    post("/session/delete", SessionController, :delete)

    get("person/students/:id", PersonController, :get_student)
    get("person/teachers/:id", PersonController, :get_teacher)

    resources("/students", StudentController, only: [:create, :delete, :update, :index, :show])
    post("/students/:student_id/courses/:course_id", StudentController, :register_course)
    delete("/students/:student_id/courses/:course_id", StudentController, :cancel_register_course)

    resources("/teachers", TeacherController, only: [:create, :delete, :update, :index, :show])
    get("/teachers/:id/courses", TeacherController, :all_courses_for_teacher)
    get("/teachers/:id/students", TeacherController, :all_students_for_teacher)

    resources("/courses", CourseController, only: [:create, :delete, :update, :index, :show])
    post("/courses/teachers", CourseController, :create_teaacher_with_course)
  end

  scope "/api/pokemons", CollegeWeb do
    pipe_through(:api)

    get("/", PokemonController, :index)
  end
end
