﻿window.w88Mobile.Gateways.NextPay = NextPay();
var _w88_nextpay = window.w88Mobile.Gateways.NextPay;

function NextPay() {

    var nextpay = Object.create(new w88Mobile.Gateway(_w88_paymentSvc));

    nextpay.createDeposit = function () {
        var _self = this;
        var params = _self.getUrlVars();
        var data = {
            Amount: params.Amount,
            Bank: { Text: params.BankText, Value: params.BankValue },
        };

        _self.methodId = params.MethodId;
        _self.changeRoute();
        _self.deposit(data, function (response) {
            switch (response.ResponseCode) {
                case 1:
                    w88Mobile.PostPaymentForm.createv2(response.ResponseData.FormData, response.ResponseData.PostUrl, "body");
                    w88Mobile.PostPaymentForm.submit();
                    break;
                default:
                    if (_.isArray(response.ResponseMessage))
                        w88Mobile.Growl.shout(w88Mobile.Growl.bulletedList(response.ResponseMessage), _self.shoutCallback);
                    else
                        w88Mobile.Growl.shout(response.ResponseMessage, _self.shoutCallback);

                    break;
            }
        },
        function () {
            GPInt.prototype.HideSplash();
        });
    }

    return nextpay;
}