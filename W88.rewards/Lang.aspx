﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Lang.aspx.cs" Inherits="_Lang" %>
<%@ Import Namespace="W88.BusinessLogic.Shared.Helpers" %>

<!DOCTYPE html>
<html>
<head>
    <title><%=CultureHelpers.ElementValues.GetResourceString("brand", LeftMenu) + CultureHelpers.ElementValues.GetResourceString("language", LeftMenu)%></title>
    <!--#include virtual="~/_static/head.inc" -->
</head>
<body>
    <div data-role="page" data-theme="b">
        <!--#include virtual="~/_static/header.shtml" -->
        <form id="form1" runat="server">
            <section class="main-content">
                <div class="container">
                    <div class="page-title">
                        <h3 class="text-center"><%=CultureHelpers.ElementValues.GetResourceString("selectLanguage", LeftMenu)%></h3>
                    </div>
                    <div class="language-box">
                        <div runat="server" ID="divLanguageContainer" class="row"></div>
                    </div>
                </div>
            </section>
        </form>
    </div>
    <script>
        $(function () {
            $('#divLanguageContainer div.col-xs-6 a').each(function () {
                $(this).on('click', function () {
                    var imgSrcSplit = $(this).children()[0].src.split('/'),
                        shortLangCode = imgSrcSplit[imgSrcSplit.length - 1].split('.')[0],
                        langCode = 'en-us';
                    switch (shortLangCode) {
                        case 'en':
                            langCode = 'en-us';
                            break;
                        case 'id':
                            langCode = 'id-id';
                            break;
                        case 'jp':
                            langCode = 'ja-jp';
                            break;
                        case 'kh':
                            langCode = 'km-kh';
                            break;
                        case 'kr':
                            langCode = 'ko-kr';
                            break;
                        case 'th':
                            langCode = 'th-th';
                            break;
                        case 'vn':
                            langCode = 'vi-vn';
                            break;
                        case 'cn':
                            langCode = 'zh-cn';
                            break;
                    }
                    Cookies().setCookie('language', langCode);
                    window.location.href = '/Index.aspx?lang=' + langCode;
                });
            });
        });
    </script>
</body>
</html>