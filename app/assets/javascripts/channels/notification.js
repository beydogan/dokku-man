App.notification = App.cable.subscriptions.create("NotificationChannel", {
    connected: function() {
        console.log("Listening notification channel")
    },

    disconnected: function() {
        // Called when the subscription has been terminated by the server
    },

    received: function(data) {
        this.handle_notification(data)
    },

    handle_notification: function(data){
        notify(data.message, data.type)
    }
});
