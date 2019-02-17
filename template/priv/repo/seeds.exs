# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     XxxxXxxx.Repo.insert!(%XxxxXxxx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

XxxxXxxx.Repo.delete_all(XxxxXxxx.Coherence.User)

%XxxxXxxx.Coherence.User{}
|> XxxxXxxx.Coherence.User.changeset(%{
  name: "Test User",
  email: "a@b.com",
  password: "secret",
  password_confirmation: "secret"
})
|> XxxxXxxx.Repo.insert!()

