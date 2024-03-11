defmodule TetrisUiWeb.CustomComponents do
  use Phoenix.Component
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.Shape
  alias Tetris.Brick
  alias TetrisUi.Shades

  @type shades :: Shades.t()
  @type point :: Brick.point()
  @type color :: Brick.color()
  @type shape :: Shape.t()
  @type rendered :: Phoenix.LiveView.Rendered.t()

  # @debug Application.get_env(:tetris_ui, :debug, false)
  @box_height 20
  @box_width 20

  @shades_list [
    %Shades{light: "DB7160", dark: "AB574B"},
    %Shades{light: "83C1C8", dark: "66969C"},
    %Shades{light: "8BBF57", dark: "769359"},
    %Shades{light: "CB8E4E", dark: "AC7842"},
    %Shades{light: "A1A09E", dark: "7F7F7E"}
  ]

  # Components

  def starting(assigns) do
    ~H"""
    <h2>Welcome!</h2>
    <form phx-submit="start">
      <label>Player: </label>
      <input type="text" name="player_name" required />
      <input type="submit" required value="Start" />
    </form>
    """
  end

  attr :tetromino, :map, required: true
  attr :bottom, :map, required: true
  attr :player, :string, default: "anon"
  attr :score, :integer, default: 0

  def initialized(assigns) do
    ~H"""
    <div phx-window-keydown="keydown" class="game-field">
      <%= svg_header() |> raw() %>
      <%= @tetromino |> boxes() |> raw() %>
      <%= @bottom |> Map.values() |> boxes() |> raw() %>
      <%= svg_footer() |> raw() %>
    </div>
    <div class="next">
      <h3><b> Player: </b></h3>
      <span><%= @player %></span>
      <h3><b> Score: </b></h3>
      <span><%= @score %></span>
      <h3><b> Next: </b></h3>
      <div>
        <%= svg_header({0, 0, 100, 100}) |> raw() %>
        <%= @next |> boxes() |> raw() %>
        <%= svg_footer() |> raw() %>
      </div>
    </div>

    <%!-- <%= debug(assigns) %> --%>
    """
  end

  attr :ranking, :map, required: true
  attr :score, :integer, default: 0

  def game_over(assigns) do
    ~H"""
    <h1>Game Over</h1>
    <h2>Your final score is: <%= @score %></h2>

    <table>
      <tr>
        <th>Player</th>
        <th>Score</th>
      </tr>
      <%= for [player: player, score: score] <- @ranking do %>
        <tr>
          <td><%= player %></td>
          <td><%= score %></td>
        </tr>
      <% end %>
    </table>

    <button phx-click="start_again">New game</button>
    <%= debug(assigns) %>
    """
  end

  attr :tetromino, :map, required: true
  attr :bottom, :map, required: true
  attr :debug_mode, :boolean, required: true

  def debug(assigns) do
    ~H"""
    <div :if={@debug_mode}>
      <pre> <%=  @tetromino |> inspect |> raw %> </pre>
      <pre> <%= @bottom |> inspect |> raw %> </pre>
    </div>
    """
  end

  ### Helpers

  @spec boxes(shape) :: binary

  defp boxes(colored_shape) do
    colored_shape
    |> Enum.map(fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")
  end

  @spec svg_header({number, number, number, number}) :: binary

  defp svg_header(view_box \\ {0, 0, 200, 400})

  defp svg_header({x, y, w, h}) do
    """
      <svg
      version="1.0"
      style="background-color: #F8F8F8"
      id="Layer_1"
      xmlns="http://wwww.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      width="#{w}" height="#{h}"
      viewBox="#{x} #{y} #{w} #{h}"
      xml:space="preserve">
    """
  end

  @spec svg_footer :: binary

  defp svg_footer, do: "</svg>"

  @spec square(point, binary) :: binary

  defp square(point, shade) do
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

  defp triangle(point, shade) do
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

  defp box(point, color) do
    """
     #{square(point, shades(color).light)}
     #{triangle(point, shades(color).dark)}
    """
  end

  ### Debug

  # @spec debug(%{tetromino: shape, bottom: map}) :: rendered

  # defp debug(assigns), do: debug(assigns, @debug)

  # @spec debug(%{tetromino: shape, bottom: map}, boolean) :: rendered

  # defp debug(assigns, true) do
  #   TetrisUiWeb.TetrisView.render("debug.html", assigns)
  # end

  # defp debug(_, false), do: ""

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
