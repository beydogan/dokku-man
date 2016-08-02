App.app_logger = App.cable.subscriptions.create({channel: "AppLoggerChannel", room: "app_" + gon.app_id }, {
    connected: function() {
        this.perform("subscribed_to_app", {app_id: gon.app_id});
        console.log("I'm connected to app logger")
    },

    disconnected: function() {
        console.log("I'm disconnected from app logger")
    },

    received: function(data) {
        this.log_data(data)
    },

    log_data: function(data){
        if(data.action == "log"){
            $(".log-box").append(data.message);
            $(".log-box").append("<br/>");
        }
    }
});
