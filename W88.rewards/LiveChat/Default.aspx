﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="LiveChat_Default" Async="true"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Live Chat</title>
    <!--#include virtual="~/_static/head.inc" -->
    <script>
        $(function() {
            $('#liveChatFrame').height($(document).height());
        });
    </script>
</head>
<body>
    <div data-role="page" data-theme="b">
        <!--#include virtual="~/_static/header.shtml" -->
        <iframe id="liveChatFrame" src="<%=LiveChatLink%>"></iframe>
    </div>
</body>
</html>
