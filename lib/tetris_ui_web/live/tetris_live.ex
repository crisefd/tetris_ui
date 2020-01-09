defmodule TetrisUiWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.Brick
  alias TetrisUi.Shades

  @type shades :: Shades.t
  @type point :: Brick.point


  @box_height 20
  @box_width 20

  @shades_list [
    %Shades{light: "DB7160", dark: "AB574B"},
    %Shades{light: "83C1C8", dark: "66969C"},
    %Shades{light: "8BBF57", dark: "769359"},
    %Shades{light: "CB8E4E", dark: "AC7842"},
    %Shades{light: "A1A09E", dark: "7F7F7E"},
  ]

  def mount(_session, socket) do
    {
      :ok,
      assign(socket,
            tetromino: Brick.new(:random) |> Brick.to_string())
    }
  end

  def render(assigns) do
    ~L""" 
      <h1>Tetromino</h1>
      <pre><%= @tetromino %></pre>
      <div> 
      <%= raw svg_header() %>
      <%= raw box({1, 1}, :red) %> 
      <%= raw svg_footer() %>
      </div>
    """
  end

  @spec svg_header :: binary
  def svg_header do
    """
      <svg
      version="1.0"
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
    width="#{w - 2}" height="#{h - 2}"
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

   @spec box(point, binary) :: binary

   def box(point, color) do

     """
      #{square(point, shades(color).light)}
      #{triangle(point, shades(color).dark)}
     """
   end

  @spec to_pixels(point) :: point

  defp to_pixels({x, y}), do: {x * @box_width, y * @box_height}

  @spec shades(atom) :: shades

  for {shades, color} <- @shades_list 
                        |> Enum.map(&Macro.escape/1)
                        |> Enum.zip(Brick.all_colors) do
    defp shades(unquote(color)), do: unquote(shades)

  end

end