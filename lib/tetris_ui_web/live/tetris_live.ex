defmodule TetrisUiWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.Brick
  alias Tetris.Shape
  alias TetrisUi.Shades

  @type shades :: Shades.t()
  @type point :: Brick.point()
  @type color :: Brick.color()
  @type shape :: Shape.t()
  @type brick :: Brick.t()

  @box_height 20
  @box_width 20

  @debug true

  @shades_list [
    %Shades{light: "DB7160", dark: "AB574B"},
    %Shades{light: "83C1C8", dark: "66969C"},
    %Shades{light: "8BBF57", dark: "769359"},
    %Shades{light: "CB8E4E", dark: "AC7842"},
    %Shades{light: "A1A09E", dark: "7F7F7E"}
  ] 

  def mount(_session, socket) do
    { :ok, new_game(socket) }
  end

  def render(assigns = %{state: :game_over}) do
    ~L"""
      <h1>Game Over</h1>
      <%= debug(assigns) %>
    """
  end

  def render(assigns = %{state: :playing}) do
    ~L"""
      <h1><%= @score %></h1>
      <div phx-keydown="keydown" phx-target="window"> 
        <%= svg_header() |> raw() %>
        <%= @tetromino |> boxes() |> raw() %>
        <%= @bottom |> Map.values() |> boxes() |> raw() %>
        <%= svg_footer() |> raw() %>
      </div>
      <%= debug(assigns) %>
    """
  end

  def new_game(socket) do
    socket
    |> assign( state: :playing,
               score: 0,
               bottom: %{})
    |> initialize
  end

  @spec initialize(map) :: map

  def initialize(socket) do
    socket
    |> new_brick
    |> display
  end

  @spec new_brick(map) :: map

  def new_brick(socket) do
    brick = 
      Brick.new(:random)
      |> Map.put(:location, {3, -3})

    assign(socket, brick: brick)
  end

  @spec display(map) :: map

  def display(socket = %{assigns: %{brick: brick}}) do
    brick_color = brick |> Brick.color
    shape =
      brick
      |> Brick.prepare
      |> Shape.traslate(brick.location)
      |> Shape.with_color(brick_color)

    assign(socket, tetromino: shape)
  end

  @spec boxes(shape) :: binary

  def boxes(colored_shape) do
    colored_shape
    |> Enum.map(fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")
  end

  @spec svg_header :: binary

  def svg_header do
    """
      <svg
      version="1.0"
      style="background-color: #F8F8F8"
      id="Layer_1"
      xmlns="http://wwww.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      width="200" height="400"
      viewBox="0 0 200 400"
      xml:space="preserve">
    """
  end

  @spec svg_footer :: binary

  def svg_footer, do: "</svg>"

  @spec square(point, binary) :: binary

  def square(point, shade) do
    {x, y} = to_pixels(point)
    {w, h} = {@box_width, @box_height}

    """
     <rect
     x="#{x + 1}" y="#{y + 1}"
     style="fill:##{shade};"
     width="#{w - 2}" height="#{h - 1}"
     />
    """
  end

  @spec triangle(point, binary) :: binary

  def triangle(point, shade) do
    {x, y} = to_pixels(point)
    {w, h} = {@box_width, @box_height}

    """
      <polyline
      style="fill:##{shade};"
      points="#{x + 1}, #{y + 1}  #{x + w}, #{y + 1}  #{x + w},  #{y + h}"
      />
    """
  end

  @spec box(point, color) :: binary

  def box(point, color) do
    """
     #{square(point, shades(color).light)}
     #{triangle(point, shades(color).dark)}
    """
  end

  ####### Move the tetromino

  @spec drop(brick, map, integer) :: map

  def drop(brick, bottom, score) do
    result = Tetris.drop(brick, bottom, Brick.color(brick))
    %{state: (if result.game_over, do: :game_over, else: :playing),
      brick: result.brick,
      bottom: result.bottom,
      score: score + result.score }
  end

  @spec do_move(map, atom) :: map

  def do_move(socket = %{assigns: %{brick: brick, bottom: bottom, score: score}}, :down) do
    assign(socket, drop(brick, bottom, score))
  end

  for {function, movement} <- 
        [&Tetris.try_left/2, &Tetris.try_right/2, &Tetris.try_rotate/2]
        |> Enum.map(&Macro.escape/1)
        |> Enum.zip([:left, :right, :turn]) do

      def do_move(socket = %{assigns: %{brick: brick, bottom: bottom}}, unquote(movement)) do
        assign(socket, brick: unquote(function).(brick, bottom))
      end
  end

  @spec move(atom, map) :: map

  def move(direction, socket) do
    socket
    |> do_move(direction)
    |> display()
  end


  # def do_move(%{assigns: %{brick: brick}} = socket, :right) do
  #   assign(socket, brick: brick |> Brick.right)
  # end

  # def do_move(%{assigns: %{brick: brick}} = socket, :turn) do
  #   assign(socket, brick: brick |> Brick.rotate)
  # end

  ###### Event handlers

  for {movement, key} 
      <- [left: "ArrowLeft",
          right: "ArrowRight", 
          down: "ArrowDown",
          turn: "ArrowUp"] do

    def handle_event("keydown", %{"key" => unquote(key)}, socket) do
      {:noreply,  move(unquote(movement), socket)}
    end
  end

  def handle_event("keydown", _, socket), do: {:noreply, socket}

  # def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
  #   {:noreply,  move(:left, socket)}
  # end

  # def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
  #   {:noreply,  move(:right, socket)}
  # end

  # def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
  #   {:noreply,  move(:turn, socket)}
  # end

  ### Debug

  def debug(assigns), do: debug(assigns, @debug, Mix.env)
  def debug(assigns, true, :dev) do
    ~L"""
      <pre> <%= @tetromino |> inspect |> raw %> </pre>
      <pre> <%= @bottom |> inspect |> raw %> </pre>
     """
  end

  def debug(_, _, _), do: ""


  #### Private functions

  @spec to_pixels(point) :: point

  defp to_pixels({x, y}), do: {(x - 1) * @box_width, (y - 1) * @box_height}

  @spec shades(atom) :: shades

  for {shades, color} <-
        @shades_list
        |> Enum.map(&Macro.escape/1)
        |> Enum.zip(Brick.all_colors()) do
    defp shades(unquote(color)), do: unquote(shades)
  end
end
