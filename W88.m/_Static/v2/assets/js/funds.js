﻿var _w88_funds = w88Mobile.Funds = Funds();

function Funds() {

    var wallets = [];
    var task = "";

    return {
        init: init,
        wallets: getWallets
    }

    function init() {
        fetchWallets({selector: "funds-wallet-lists"});
    }

    function send(resource, method, data, success, error, complete) {

        if (_.isUndefined(error)) {
            error = function () {
                console.log("Error connecting to api");
            }
        }
        var selector = "";
        if (!_.isUndefined(data.selector)) {
            selector = _.clone(data.selector);
            delete data["selector"];
        }

        var url = w88Mobile.APIUrl + resource;

        var headers = {
            'Token': window.User.token,
            'LanguageCode': window.User.lang
        };

        $.ajax({
            type: method,
            url: url,
            data: data,
            beforeSend: function () {
                pubsub.publish('startLoadItem', {selector: selector});
            },
            headers: headers,
            success: success,
            error: error,
            complete: function () {
                if(!_.isUndefined(complete)) complete();
                pubsub.publish('stopLoadItem', { selector: selector });
            }
        });
    }

    function fetchWallets(data) {
        var resource = "/user/wallets?isSelection=true";
        send(resource, "GET", data, function (response) {
            if (_.isUndefined(response.ResponseData)) {
                console.log('Unable to fetch wallets.');
                return;
            }
            wallets = response.ResponseData;
            pubsub.publish("fundsLoaded");
        });
    }

    function getWallets() {
        return wallets;
    }

}