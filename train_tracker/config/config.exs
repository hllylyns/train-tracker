import Config

config :train_tracker, TrainLines.Repo,
  database: "train_tracker_repo",
  username: "user",
  password: "pass",
  hostname: "localhost", 

config :train_lines, ecto_repos: [TrainLines.Repo]
