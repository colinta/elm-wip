import Debug exposing (log)
import Html exposing (Html)
import Date
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

type alias Point = { x : Float, y : Float }
type alias PointStr = { x : String, y : String }

offset : Float -> Float -> (Float, Float) -> (Float, Float)
offset dx dy point =
  let
    (x, y) = point
  in
    (x + dx, y + dy)

pointStr : (Float, Float) -> PointStr
pointStr point =
  let
    (x, y) = point
  in
  { x = toString x, y = toString y }

view : Model -> Html Msg
view time =
  let
    date = Date.fromTime time
    secondsAngle =
      turns (toFloat <| Date.second date) / 60 - pi / 2
    minutesAngle =
      turns (toFloat <| Date.minute date) / 60 - pi / 2
    hoursAngle =
      turns (toFloat <| Date.hour date) / 12 - pi / 2

    seconds = pointStr <| offset 50 50 <| fromPolar (50, secondsAngle)
    minutes = pointStr <| offset 50 50 <| fromPolar (50, minutesAngle)
    hours = pointStr <| offset 50 50 <| fromPolar (40, hoursAngle)

  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 seconds.x, y2 seconds.y, stroke "#E31400" ] []
      , line [ x1 "50", y1 "50", x2 minutes.x, y2 minutes.y, stroke "#A1A1A1" ] []
      , line [ x1 "50", y1 "50", x2 hours.x, y2 hours.y, stroke "#FFFFFF" ] []
      ]
