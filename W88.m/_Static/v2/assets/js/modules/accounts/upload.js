﻿var _w88_upload = w88Mobile.Upload = Upload();

function Upload() {
    var upload = {};

    upload.init = function () {
        _w88_validator.initiateValidator("#form1");

        // Script for Upload field
        $(".btn-upload").click(function () {
            var upload = $(this).parent().siblings('input[type="file"]');
            upload.click();

            $(document).on('change', upload, function () {
                var filename = upload.val().replace(/C:\\fakepath\\/i, '')
                upload.siblings('.input-upload').val(filename);
            });
        });

        $('#form1').validator().on('submit', function (e) {
            if (!e.isDefaultPrevented()) {
                e.preventDefault();

                upload.uploadImage();
            }
        });
    };

    upload.uploadImage = function () {
        var data = new FormData();
        var file = $('[id$="fileUpload"]')[0].files[0];
        data.append('UploadedImage', file);
        data.append('Remarks', $('[id$="txtRemarks"]').val());

        var url = w88Mobile.APIUrl + "/user/upload";

        $.ajax({
            type: "Post",
            url: url,
            data: data,
            beforeSend: function () {
                pubsub.publish('startLoadItem');
            },
            processData: false, // Don't process the files
            contentType: false, // Set content type to false as jQuery will tell the server its a query string request
            success: function (response) {
                switch (response.ResponseCode) {
                    case 1:
                        w88Mobile.Growl.shout(response.ResponseMessage);

                        $('#form1')[0].reset();
                        break;
                    default:
                        if (_.isArray(response.ResponseMessage))
                            w88Mobile.Growl.shout(w88Mobile.Growl.bulletedList(response.ResponseMessage));
                        else
                            w88Mobile.Growl.shout(response.ResponseMessage);
                        break;
                }
            },
            error: function () {
                console.log("Error connecting to api");
            },
            complete: function () {
                pubsub.publish('stopLoadItem');
            }
        });
    };

    return upload;
}