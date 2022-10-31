module TUI where

import Brick
import Brick.Widgets.Border
import Brick.Widgets.Border.Style
import Brick.Widgets.Center
import CLI

ui :: Widget ()
ui =
  joinBorders $
    withBorderStyle unicodeRounded $
      borderWithLabel
        (str "λ :: HTime")
        ( vBox [center (str "Left Up"), hBorder, center (str "Left Down")]
            <+> vBorder
            <+> center (str "Right")
        )

runTUI :: CLIOptions -> IO ()
runTUI _ = simpleMain ui
