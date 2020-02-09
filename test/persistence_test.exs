defmodule TetrisUi.PersistenceTest do
  use ExUnit.Case
  import Mock
  import TetrisUi.Persistence

  test "reading the rankings works" do
    with_mock File, [read:
                    fn (_path) ->
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
        actual = read_ranking()
        assert actual == expected
    end
  end

  test "writing rankings works" do
    ranking = [ [player: "mary", score: 6000],
                  [player: "joe", score: 5000],
                  [player: "sam", score: 2000],
                  [player: "chris", score: 10000],
                  [player: "tom", score: 500]]
    with_mock File, [write:
                     fn (_file_path, _content) ->
                      :ok
                    end] do
      result = write_ranking(ranking)

      assert result == :ok

    end
  end

end
