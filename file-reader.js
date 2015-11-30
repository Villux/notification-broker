var defaultValues = {
  dispatchSendNotification: {
    notificationTimestamp: "",
    id: "",
    application: "",
    attnDemand: ""
  },
  dispatchUpdateUserState: {
    stateTimestamp: "",
    activity: "",
    visualAttn: "",
    auditoryAttn:"",
    noiseLevel: ""
  }
}
var div = document.getElementById('notification-broker');
var elmApp = Elm.embed(Elm.Main, div, defaultValues);


var iterations = 0;
elmApp.ports.readFile.subscribe(function(frame) {
    var eventTime = iterations++;
    for (var i = 0; i < rawUserStates.length; i++) {
      if (parseInt(rawUserStates[i][0]) === eventTime) {
        console.log("Send to elm");
        elmApp.ports.dispatchUpdateUserState.send({
          stateTimestamp: rawUserStates[i][0],
          activity: rawUserStates[i][1],
          visualAttn: rawUserStates[i][2],
          auditoryAttn:rawUserStates[i][3],
          noiseLevel: rawUserStates[i][4]
        });
      }
    }
    for (var j = 0; j < rawNotifications.length; j++) {
      if (parseInt(rawNotifications[j][0]) === eventTime) {
        console.log("Send to elm");
        elmApp.ports.dispatchSendNotification.send({
          notificationTimestamp: rawNotifications[j][0],
          id: rawNotifications[j][1],
          application: rawNotifications[j][2],
          attnDemand: rawNotifications[j][3]
        });
      }
    }
});
