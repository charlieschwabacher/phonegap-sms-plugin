var sms = {
    send: function(phone, message, method, callback) {
    	// iOS plugin used to accept comma-separated phone numbers, keep the
    	// compatibility
    	if (typeof phone === 'string' && phone.indexOf(',') !== -1) {
    	    phone = phone.split(',');
    	}
        if (Object.prototype.toString.call(phone) !== '[object Array]') {
            phone = [phone];
        }
        
        this.didFinishWithResult = function(result) {
            if (typeof callback === "function") {
                callback(result);
            }
        };
        
        cordova.exec(
            function(){alert("success");},
            function(){alert("error");},
            'Sms',
            'send',
            [phone, message, method]
        );
        
        this.didFinishWithResult = null;
    }
};

module.exports = sms;
