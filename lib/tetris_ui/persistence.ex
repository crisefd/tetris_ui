defmodule TetrisUi.Persistence do

  @file_path "../../assets/csv/ranking.csv"

  @spec read_rankings :: list

  def read_rankings do
    with {:ok, contents} <- File.read(@file_path),
          lines <- String.split(contents, "\n", trim: true) do
          for [player, score] <-
              Enum.map(lines, &String.split(&1, ";", trim: true)) do
              [player: player, score: String.to_integer(score) ]
          end
        else
          []
    end
  end

  @spec write_rankings(list) :: :ok | {:error, any}

  def write_rankings(rankings) do
    rankings
    |> Enum.sort(fn ([{:player, _player1}, {:score, score1}],
                     [{:player, _player2}, {:score, score2}]) ->
      score1 > score2
    end )
    |> Enum.reduce("", fn ranking, content ->
      [{:player, player}, {:score, score}] = ranking
      case content do
        "" -> content <> "#{player};#{score}"
        _ -> content <> "\n" <> "#{player};#{score}"
      end
    end)
    |> case do content ->
      File.write(@file_path, content)
    end
  end

end
