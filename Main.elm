module Main where

import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)

import Time exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (..)

-- Model
type alias BrokerState =
  { userState: UserState
  , notifications: List( BrokerNotification )
  }

type alias UserState =
  { stateTimestamp : String
  , activity : String
  , visualAttn : String
  , auditoryAttn : String
  , noiseLevel : String
  }

type alias Notification =
  { notificationTimestamp : String
  , id : String
  , application : String
  , attnDemand : String
  }

type alias BrokerNotification =
  { notificationTimestamp : String
  , id : String
  , application : String
  , auditory : Bool
  , tactile : Bool
  , visual : Bool
  , userState : UserState
  }

initUserState =
  { stateTimestamp = ""
  , activity = ""
  , visualAttn = ""
  , auditoryAttn = ""
  , noiseLevel = ""
  }

initBrokerState =
  { userState = initUserState
  , notifications = []
  }



-- Action
type Action
  = UpdateUserState UserState
  | SendNotification Notification
  | UpdateWorld Float

type Update
  = TimeDelta Float

highAttnDemand : BrokerNotification -> Notification -> BrokerState -> BrokerNotification
highAttnDemand bn n bs =
  -- If user watching the phone, no need for auditory notification
  if bs.userState.visualAttn == "phone" then
    { bn | auditory = False }
  else
    bn

mediumAttnDemand : BrokerNotification -> Notification -> BrokerState -> BrokerNotification
mediumAttnDemand bn n bs =
    if (bs.userState.visualAttn /= "phone" && ( bs.userState.noiseLevel == "loud" || bs.userState.activity == "walking")) then
      -- If user not watching the phone and sorroundings noisy, send notification with
      -- every possible way
      bn
    else
      { bn | auditory = False }

lowAttnDemand : BrokerNotification -> Notification -> BrokerState -> BrokerNotification
lowAttnDemand bn n bs =
  if bs.userState.activity == "walking" then
    { bn | auditory = False }
  else
    { bn |
        auditory = False
      , visual = False }

setNotificationLevels : BrokerNotification -> Notification -> BrokerState -> BrokerNotification
setNotificationLevels bn n bs =
  if n.attnDemand == "high" then
    highAttnDemand bn n bs
  else if n.attnDemand == "medium" then
    mediumAttnDemand bn n bs
  else
    lowAttnDemand bn n bs

generateBrokerNotification : Notification -> BrokerState -> BrokerState
generateBrokerNotification notification model =
  let
    brokerNotification =
      { notificationTimestamp = notification.notificationTimestamp
      , id = notification.id
      , application = notification.application
      , auditory = True
      , tactile = True
      , visual = True
      , userState = model.userState
      }
    in
      { model | notifications = model.notifications ++ [( setNotificationLevels brokerNotification notification model )]}



actions =
  Signal.mergeMany
    [
      Signal.map UpdateUserState dispatchUpdateUserState
    , Signal.map SendNotification dispatchSendNotification
    ]

update action model =
  case action of
    UpdateUserState userState ->
      { model | userState = userState }
    SendNotification notification ->
      if notification.attnDemand == "high" then
        generateBrokerNotification notification model
      else if notification.attnDemand == "medium" then
        generateBrokerNotification notification model
      else
        generateBrokerNotification notification model
    _ ->
      model


brokerChanges =
  Signal.foldp update initBrokerState actions

-- View

notificationElement : BrokerNotification -> Html
notificationElement bn =
  div [ attribute "class" "notification"]
    [ div [ attribute "class" "notification_type" ]
      [ span [] [ Html.text ( String.concat [ "Timestamp: ", bn.notificationTimestamp, ", NotificationID: ", bn.id ,", Application: ", bn.application ])]
      ]
    , div [ attribute "class" "notification_modalities"]
      [span [] [ Html.text "Modalities: "]
      , span [] [ Html.text ( if bn.tactile then "tactile, " else "" )]
      , span [] [ Html.text ( if bn.visual then "visual, " else "" )]
      , span [] [ Html.text ( if bn.auditory then "auditory" else "" )]]
    , span [] [ Html.text ( toString bn.userState )]
    , br [] []
    ]

view : BrokerState -> Html
view model =
  let insert = div [] []
  in
    div
      []
      ( List.map notificationElement model.notifications )

main : Signal Html
main =
  Signal.map view brokerChanges
-- Ports

port brokerNotificationsChanges : Signal (List BrokerNotification)
port brokerNotificationsChanges = Signal.dropRepeats (Signal.map .notifications brokerChanges)
-- Send read command to JSs
port readFile : Signal Float
port readFile = Signal.foldp (+) 0 (fps 30)
-- Receive from JS
port dispatchUpdateUserState : Signal UserState
port dispatchSendNotification : Signal Notification
