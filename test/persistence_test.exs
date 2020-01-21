defmodule TetrisUi.PersistenceTest do
  use ExUnit.Case
  import Mock
  import TetrisUi.Persistence

  test "reading the rankings works" do
    with_mock File, [read:
                    fn ("../../assets/csv/ranking.csv") ->
                      {:ok,
                        """
                        mary;6000
                        joe;5000
                        sam;2000
                        tom;500
                        """
                      }
                    end ] do
        expected = [ [player: "mary", score: 6000],
                     [player: "joe", score: 5000],
                     [player: "sam", score: 2000],
                     [player: "tom", score: 500]]
        actual = read_rankings()
        assert actual == expected
    end
  end

  test "writing rankings works" do
    rankings = [ [player: "mary", score: 6000],
                  [player: "joe", score: 5000],
                  [player: "sam", score: 2000],
                  [player: "chris", score: 10000],
                  [player: "tom", score: 500]]
    with_mock File, [write:
                     fn (file_path, _content) ->
                      :ok
                    end] do
      write_rankings(rankings)
      assert called(
        File.write("../../assets/csv/ranking.csv",
                  "chris;10000\nmary;6000\njoe;5000\nsam;2000\ntom;500"))

    end
  end

end
