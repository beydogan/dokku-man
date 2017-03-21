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
        console.log(data);
        if(data.reload_page && $(data.reload_element_check).length > 0){
          Turbolinks.visit(window.location, { action: "advance" })
          $(document).one('turbolinks:load', function(){
            notify(data.message, data.type)
          })
        }else{
          notify(data.message, data.type)
        }

        // Replaces an element in the page with the payload
        if(data.content_replace && $(data.content_replace_target).length > 0) {
            $(data.content_replace_target).replaceWith(data.content_replace_payload)
            $(data.content_replace_target).effect("highlight", 1000);
        }
    }
});
