import Debug exposing (log)
import Html exposing (Html, text, div, p, i)
import Date
import Mouse
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

type alias Model = {
    time : Maybe Time,
    position : Maybe Mouse.Position
  }


init : (Model, Cmd Msg)
init =
  ({ time = Nothing, position = Nothing }, Cmd.none)


-- UPDATE

type Msg
  = MouseMove Mouse.Position
  | Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MouseMove position ->
      ({ model | position = Just position }, Cmd.none)
    Tick time ->
      ({ model | time = Just time}, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [Time.every second Tick, Mouse.moves MouseMove]


-- VIEW

view : Model -> Html Msg
view model =
  let
    time = case model.time of
      Just t -> p [] [text "The time is ", i [] [text (toString t)]]
      Nothing -> text ""
    mouse = case model.position of
      Just pos -> p [] [text ("{" ++ (toString pos.x) ++ "," ++ (toString pos.y) ++ "}")]
      Nothing -> text ""
  in
    div [] [time, mouse]
