# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Loginservice.Repo.insert!(%Loginservice.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Loginservice.Registration.Campaign
alias Loginservice.Repo

if Repo.all(Campaign) == [] do

  Repo.insert!(%Campaign{
    name: "Default recruitment campaign",
    url: "default",
    active: true,
    description_short: "Signup to our app!",
    description_long: "Really, sign up to our app!"
  })
end