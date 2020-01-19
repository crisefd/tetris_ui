defmodule TetrisUiWeb.TetrisLive do
  use Phoenix.LiveView
  alias Tetris.Brick
  alias Tetris.Shape
  alias TetrisUi.Shades

  @type shades :: Shades.t()
  @type point :: Brick.point()
  @type color :: Brick.color()
  @type shape :: Shape.t()
  @type brick :: Brick.t()
  @type socket :: Phoenix.LiveView.Socket.t()
  @type state :: :game_over | :starting | :playing | :paused
  @type rendered :: Phoenix.LiveView.Rendered.t()

  @drop_interval_duration 500

  ### LiveView

  @spec mount(any, socket) :: {:ok, socket}
  def mount(_session, socket) do
    :timer.send_interval(@drop_interval_duration, self(), :tick)
    {:ok, start_game(socket)}
  end

  @spec render(%{state: state}) :: rendered

  for {state, template} <-
        [
          starting: "starting.html",
          game_over: "game_over.html",
          playing: "initialized.html",
          paused: "initialized.html"
        ] do
    def render(assigns = %{state: unquote(state)}) do
      TetrisUiWeb.TetrisView.render(unquote(template), assigns)
    end
  end

  ### High-level game logic

  @spec start_game(socket) :: socket

  def start_game(socket) do
    assign(socket, state: :starting)
  end

  @spec pause_game(socket) :: socket

  def pause_game(socket), do: assign(socket, state: :paused)

  @spec continue_game(socket) :: socket

  def continue_game(socket), do: assign(socket, state: :playing)

  @spec new_game(socket) :: socket

  def new_game(socket) do
    socket
    |> assign(
      state: :playing,
      score: 0,
      bottom: %{}
    )
    |> new_brick
    |> display
  end

  @spec new_brick(socket) :: socket

  def new_brick(socket) do
    brick =
      Brick.new(:random)
      |> Map.put(:location, Brick.initial_location())
    next_brick =
      Brick.new(:random)
      |> Map.put(:location, Brick.initial_location())

    assign(socket, brick: brick, next_brick: next_brick)
  end

  @spec display(socket) :: socket

  def display(socket = %{assigns: %{brick: brick, next_brick: next_brick}}) do
    brick_color = brick |> Brick.color()
    next_brick_color = next_brick |> Brick.color()
    shape =
      brick
      |> Brick.prepare()
      |> Shape.traslate(brick.location)
      |> Shape.with_color(brick_color)

    next_shape =
      next_brick
        |> Brick.prepare()
        |> Shape.traslate({0, 1})
        |> Shape.with_color(next_brick_color)

    assign(socket, tetromino: shape, next: next_shape)
  end

  ###### Events & info handlers

  for {movement, key} <-
        [left: "ArrowLeft", right: "ArrowRight", turn: "ArrowUp", fast_drop: "ArrowDown"] do
    def handle_event("keydown", %{"key" => unquote(key)}, socket) do
      {:noreply, move(unquote(movement), socket)}
    end
  end

  def handle_event("keydown", %{"key" => "Escape"}, socket) do
    new_socket =
      case socket.assigns do
        %{state: :paused} ->
          continue_game(socket)

        %{state: :playing} ->
          pause_game(socket)

        _ ->
          socket
      end

    {:noreply, new_socket}
  end

  def handle_event("keydown", _, socket), do: {:noreply, socket}

  def handle_event("start", _, socket), do: {:noreply, new_game(socket)}

  def handle_info(:tick, socket = %{assigns: %{state: :playing}}) do
    {:noreply, move(:drop, socket)}
  end

  def handle_info(:tick, socket), do: {:noreply, socket}

  ####### Movements

  @spec drop(brick, brick, map, integer) :: map

  defp drop(brick, next_brick, bottom, score) do
    result = Tetris.drop(brick, next_brick, bottom, Brick.color(brick))

    %{
      state: if(result.game_over, do: :game_over, else: :playing),
      brick: result.brick,
      next_brick: result.next_brick,
      bottom: result.bottom,
      score: score + result.score
    }
  end

  @spec do_move(socket, atom) :: socket

  defp do_move(socket = %{assigns: %{brick: brick,
                                     next_brick: next_brick,
                                     bottom: bottom,
                                     score: score}}, :drop) do
    assign(socket, drop(brick, next_brick, bottom, score))
  end

  defp do_move(socket = %{assigns: %{brick: brick,
                                     next_brick: next_brick,
                                     bottom: bottom,
                                     score: score}}, :fast_drop) do
    result = drop(brick, next_brick, bottom, score)

    if Brick.initial_location() == result.brick.location do
      socket |> assign(result)
    else
      socket |> assign(result) |> do_move(:fast_drop)
    end
  end

  for {function, movement} <-
        [&Tetris.try_left/2, &Tetris.try_right/2, &Tetris.try_rotate/2]
        |> Enum.map(&Macro.escape/1)
        |> Enum.zip([:left, :right, :turn]) do
    defp do_move(socket = %{assigns: %{brick: brick, bottom: bottom}}, unquote(movement)) do
      assign(socket, brick: unquote(function).(brick, bottom))
    end
  end

  @spec move(atom, socket) :: socket

  defp move(_, socket = %{assigns: %{state: :paused}}), do: socket

  defp move(direction, socket) do
    socket
    |> do_move(direction)
    |> display()
  end
end
