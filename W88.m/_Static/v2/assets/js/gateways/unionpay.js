﻿window.w88Mobile.Gateways.UnionPay = UnionPay();
var _w88_unionpay = window.w88Mobile.Gateways.UnionPay;

function UnionPay() {

    var unionpay;

    try {
        unionpay = Object.create(new w88Mobile.Gateway(_w88_paymentSvcV2));
    } catch (err) {
        unionpay = {};
    }

    unionpay.init = function (gatewayId) {
        $(".pay-note").show();
        $("#paymentNote").text($.i18n("LABEL_PAYMENT_NOTE"));

        if (!_.isUndefined(gatewayId)) {
            if (gatewayId == "120223") {
                $("#paymentNoteContent").html($.i18n("LABEL_MSG_120223")); //SD pay
                $("#securePayAndroid").html($.i18n("LABEL_ANDROID_DOWNLOAD_SECURE_PAY"));
                $("#securePayiOS").html($.i18n("LABEL_IOS_DOWNLOAD_SECURE_PAY"));
            }
        }
    };

    unionpay.createDeposit = function () {
        var _self = this;
        var params = _self.getUrlVars();
        var data = {
            Amount: params.Amount,
            ThankYouPage: params.ThankYouPage,
        };

        _self.methodId = params.MethodId;
        _self.changeRoute();
        _self.deposit(data, function (response) {
            switch (response.ResponseCode) {
                case 1:
                    if (response.ResponseData.VendorRedirectionUrl) {
                        window.open(response.ResponseData.VendorRedirectionUrl);
                    } else {
                        if (response.ResponseData.PostUrl) {
                            w88Mobile.PostPaymentForm.create(response.ResponseData.FormData, response.ResponseData.PostUrl, "body");
                            w88Mobile.PostPaymentForm.submit();
                        } else if (response.ResponseData.DummyURL) {
                            w88Mobile.PostPaymentForm.create(response.ResponseData.FormData, response.ResponseData.DummyURL, "body");
                            w88Mobile.PostPaymentForm.submit();
                        }
                    }

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
                pubsub.publish('stopLoadItem', { selector: "" });
            });
    }

    return unionpay;
}
