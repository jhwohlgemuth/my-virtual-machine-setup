IO.puts(
  IO.ANSI.red_background() <> IO.ANSI.white() <> " Good Luck with Elixir!!! \n" <> IO.ANSI.reset()
)

Application.put_env(:elixir, :ansi_enabled, true)

IEx.configure(
  colors: [
    syntax_colors: [
      number: :yellow,
      atom: :cyan,
      string: :green,
      boolean: :magenta,
      nil: :red
    ],
    eval_result: [:green, :bright],
    eval_error: [[:red, :bright, "✘ ERROR\n"]],
    eval_info: [:yellow, :bright]
  ],
  continuation_prompt: "    ",
  default_prompt:
    [
      "\e[G",
      :white,
      "(%counter) ",
      :magenta,
      "%prefix =>",
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)
