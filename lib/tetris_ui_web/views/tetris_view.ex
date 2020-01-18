defmodule TetrisUiWeb.TetrisView do
  use TetrisUiWeb, :view
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.Shape
  alias Tetris.Brick
  alias TetrisUi.Shades

  @debug Application.get_env(:tetris_ui, :debug)

  @type shades :: Shades.t()
  @type point :: Brick.point()
  @type color :: Brick.color()
  @type shape :: Shape.t()

  @box_height 20
  @box_width 20

  @shades_list [
    %Shades{light: "DB7160", dark: "AB574B"},
    %Shades{light: "83C1C8", dark: "66969C"},
    %Shades{light: "8BBF57", dark: "769359"},
    %Shades{light: "CB8E4E", dark: "AC7842"},
    %Shades{light: "A1A09E", dark: "7F7F7E"}
  ]

  ### SVGs

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

  ### Debug

  def debug(assigns), do: debug(assigns, @debug)

  def debug(assigns, true) do
    TetrisUiWeb.TetrisView.render("debug.html", assigns)
  end

  def debug(_, _), do: ""

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
