defmodule TetrisUi.Shades do
    @type t :: %TetrisUi.Shades{ light: binary, dark: binary}
    defstruct light: "", dark: ""
end