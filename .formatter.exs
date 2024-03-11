[
  import_deps: [:phoenix],
  inputs: [
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "priv/*/seeds.exs"
  ],
  heex_line_length: 72,
  plugins: [Phoenix.LiveView.HTMLFormatter]
]
