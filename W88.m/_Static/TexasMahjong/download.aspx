﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="download.aspx.cs" Inherits="_Static_TexasMahjong_download" %>
<!DOCTYPE html>
<html>
<head>
    <title><%=commonCulture.ElementValues.getResourceString("brand", commonVariables.LeftMenuXML).Replace(" -", "")/* + commonCulture.ElementValues.getResourceString("home", commonVariables.LeftMenuXML)*/%></title>
    <!--#include virtual="~/_static/head.inc" -->
</head>
<body>
    <div id="divMain" data-role="page" data-theme="b" data-ajax="false">
        <!--#include virtual="~/_static/header.shtml" -->
        <div class="ui-content" role="main">
            <div class="static-content">
                <div >
                    <img src="/_Static/Images/Download/MobileSite-DownloadPage-TM-<%=commonVariables.SelectedLanguage.ToLower() %>.jpg" alt="banner" class="img-responsive">
                </div>
                <div class="downloadmsg">
                    <span runat="server" id="spanMsg"></span>
                    <a href="#" id="sDownload" class="ui-btn btn-primary" runat="server" data-ajax="false" target="_blank"></a>
                </div>
            </div>
        </div>
        <!-- /content -->
        <!--#include virtual="~/_static/navMenu.shtml" -->
    </div>
    <!-- /page -->
</body>
</html>
