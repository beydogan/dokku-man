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
        if(data.reload){
          Turbolinks.visit(window.location, { action: "advance" })
          $(document).one('turbolinks:load', function(){
            notify(data.message, data.type)
          })
        }else{
          notify(data.message, data.type)
        }
    }
});
