// Simpler way to read the file

var rawUserStates = [];
var rawNotifications = [];

var _raw_user_states = ["1 walking street unknown loud",
                    "55 sitting street silent medium",
                    "60 sitting phone silent medium",
                    "71 sitting street silent medium",
                    "81 sitting street talking medium",
                    "85 standing street unknown loud",
                    "92 walking tram_inside unknown loud",
                    "105 sitting tram_inside silent quiet",
                    "121 sitting phone silent quiet",
                    "146 sitting tram_inside silent quiet",
                    "150 sitting phone silent quiet",
                    "200 sitting tram_inside silent quiet",
                    "203 standing tram_inside silent quiet",
                    "210 walking tram_inside unknown medium",
                    "215 walking street unknown loud",
                    "260 standing street talking medium",
                    "314 walking street talking loud",
                    "320 walking library silent quiet",
                    "333 standing library silent quiet",
                    "350 walking library silent medium",
                    "355 walking library silent quiet",
                    "360 walking phone silent quiet ",
                    "370 walking library silent quiet",
                    "391 standing library silent quiet",
                    "392 walking library silent quiet",
                    "398 standing library silent quiet",
                    "401 walking library silent quiet",
                    "410 standing library silent quiet",
                    "447 walking library silent quiet",
                    "460 sitting library silent quiet",
                    "473 sitting phone silent quiet",
                    "510 sitting library silent quiet",
                    "520 standing library silent quiet",
                    "521 walking library silent quiet",
                    "550 standing library silent quiet",
                    "564 walking street unknown loud",
                    "630 standing street unknown loud",
                    "638 standing phone unknown loud",
                    "655 standing phone talking loud",
                    "690 standing phone silent medium"];

var _raw_notifications = [ "5 1 facebook low",
                          "10 2 facebook low",
                          "41 3 call high",
                          "70 4 facebook medium",
                          "72 5 facebook medium",
                          "102 6 sms high",
                          "110 7 sms high",
                          "270 8 call high",
                          "310 9 facebook low",
                          "321 10 facebook low",
                          "410 11 facebook medium",
                          "432 12 facebook low",
                          "441 13 twitter medium",
                          "442 14 twitter medium",
                          "443 15 twitter medium",
                          "444 16 facebook low",
                          "532 17 facebook low",
                          "533 18 os_updates low",
                          "535 19 facebook low",
                          "644 20 facebook low",
                          "654 21 facebook low",
                          "656 22 facebook low",
                          "700 23 sms high"];

for (var i = 0; i < _raw_user_states.length; i++) {
  rawUserStates.push(_raw_user_states[i].split(" "));
}
for (var j = 0; j < _raw_notifications.length; j++) {
  rawNotifications.push(_raw_notifications[j].split(" "));
}
