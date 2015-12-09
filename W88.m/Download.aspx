﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Download.aspx.cs" Inherits="_Index" %>

<!DOCTYPE html>
<html>
<head>
    <title><%=commonCulture.ElementValues.getResourceString("brand", commonVariables.LeftMenuXML).Replace(" -", "")/* + commonCulture.ElementValues.getResourceString("home", commonVariables.LeftMenuXML)*/%></title>
    <!--#include virtual="~/_static/head.inc" -->
    <script type="text/javascript" src="/_Static/Js/Main.js"></script>
    <script type="application/javascript" src="/_Static/Js/add2home.js"></script>
    <script type="text/javascript">
        var cache = [];
        $(function () {
            $('.div-product-header').each(function () {
                $(this).bind('click touch', function () {
                    $('.div-product-header').not(this).next().hide();
                    $(this).next().toggle();
                    $('.div-product-scroll').each(function () {
                        $(this).attr('id', $(this).attr('data-rel'));
                        var scrollObj = new IScroll('#' + $(this).attr('data-rel'), { eventPassthrough: true, scrollX: true, scrollY: false, preventDefault: false, speedRatioX: 9000 });
                        cache.push(scrollObj);
                    });
                });
            });
        });

        $(window).resize(function () { $('.div-promo-row > a > div:last-child > div').css({ maxWidth: ($(window).width() - 200) + 'px' }); });
        function timerV2(pid, start_date, end_date) { if (new Date('<%=System.DateTime.Now.ToString(commonVariables.DateTimeFormat)%>') < new Date(start_date) || new Date('<%=System.DateTime.Now.ToString(commonVariables.DateTimeFormat)%>') > new Date(end_date)) { $('div#' + pid).hide(); } }
        function getPromos() {
            $.get('/_Static/Promotions/promotions.<%=(string.IsNullOrEmpty(commonVariables.SelectedLanguage) ? "en-us" : commonVariables.SelectedLanguage) + (string.Compare(commonVariables.GetSessionVariable("CountryCode"), "my", true) == 0 ? ".my" : "")%>.htm', function (html) { })
              .done(function (data) {
                  data = data.replace(/<img src=/g, '<img rel=');
                  var listObj = $("#divPromotions").append('<ul></ul>').find('ul');
                  $(data).find('.mobile_show').each(function (index) {
                      $(this).find('script').each(function () { $.globalEval(this.text || this.textContent || this.innerHTML || ''); });
                      var strPromoTitle = $(this).find('div.promotion_title').text();
                      var strPromoContent = $(this).find('div.promotion_content').text();
                      var strPromoDetail = $(this).find('div.promotion_detail').html().substr(0, 4) == '<br>' ? $(this).find('div.promotion_detail').html().substring(4) : $(this).find('div.promotion_detail').contents();
                      var objImage = $(this).find('img')[0];
                      var strImageSrc = null;
                      if (objImage != null) { if (/\/promotions\/img\/W88-Promotion(s)*-/i.test($(objImage).attr('rel'))) { strImageSrc = $(objImage).attr('rel').replace(/\/promotions\/img\/W88-Promotion(s)*-/i, '/promotions/mobile/images/w88-mobile-'); } }
                      var liPromo = $('<li />');
                      var divPromoWrapper = $('<div />', { id: $(this).attr('id'), class: index % 2 == 0 ? 'div-promo-row' : 'div-promo-row div-promo-row-alt' });
                      var divPromoImg = $('<div />', { class: 'div-promo-img' });
                      var imgPromo = $('<img />', { src: strImageSrc });
                      var hrefPromo = $('<a />', { href: "/Promotions#" + $(this).attr('id'), 'data-ajax': false });
                      var divPromoTitle = $('<div />', { class: 'div-promo-header' }).text(strPromoTitle);
                      var divPromoContent = $('<div />', { class: 'div-promo-desc' }).text(strPromoContent);
                      var divPromoDetail = $('<div />', { class: 'div-promo-content' }).html(/<img rel=/g.test(strPromoDetail) ? strPromoDetail.replace(/<img rel=/g, '<img src=') : strPromoDetail);
                      listObj.append($(liPromo).append($(divPromoWrapper).append($(hrefPromo).append($(divPromoImg).append(imgPromo)).append($('<div />', {}).append(divPromoTitle).append(divPromoContent)))));
                      $('.div-promo-row > a > div:last-child > div').css({ maxWidth: ($(window).width() - 160) + 'px' });
                      $(this).find('script').each(function () { $.globalEval(this.text || this.textContent || this.innerHTML || ''); });
                  });
                  if (location.hash != '') {
                      $(location.hash).next().slideToggle();
                      var divObj = $(location.hash).find('div')[1];
                      if ($(divObj).css('background-image').indexOf('arrow-up') > 0) { $(divObj).css('background-image', "url('/_Static/Images/arrow-down.png')"); }
                      else { $(divObj).css('background-image', "url('/_Static/Images/arrow-up.png')"); }
                  }
              })
              .always(function (data) { $('#promoLoader').hide(); });
        }

        function OpenPromoDetails(obj) { $(obj).parent().next().slideToggle(); }
        function PromoClaimNow(obj) { $(obj).hide(); $(obj).next().show(); }
        function PromoCancelClaim(obj) { $(obj).parent().hide(); $(obj).parent().prev().show(); }
        function PromoClaim(obj) {
            var strCode = $(obj).parent().children().first().text();
            var strComment = null;
            if ($(obj).parent().children().find('textarea').length == 0) { strComment = $(obj).parent().children().find('input[type="radio"]:checked').val(); }
            else { strComment = $(obj).parent().children().find('textarea').val(); }

            $.ajax({
                type: 'POST',
                url: '/AjaxHandlers/RegisterPromo.ashx',
                data: { sCode: strCode, Comment: strComment },
                beforeSend: function () { PromoCancelClaim(); },
                success: function (data) {
                    switch (parseInt(data)) {
                        case 1: // success
                            alert('<%=commonCulture.ElementValues.getResourceXPathString("/Promotion/RegisterSuccess", xeErrors)%>');
                            $(obj).parent().hide();
                            break;
                        case 10: // multiple submit
                            alert('<%=commonCulture.ElementValues.getResourceXPathString("/Promotion/SubmitOnce", xeErrors)%>');
                            $(obj).parent().hide();
                            break;

                        default: // error
                            alert('<%=commonCulture.ElementValues.getResourceString("ServerError", xeErrors)%>');
                            $(obj).parent().hide();
                            break;
                    }
                },
                error: function (data) { },
                complete: function (data) { PromoCancelClaim(); }
            });
        }
    </script>
</head>
<body>
    <!--#include virtual="~/_static/splash.shtml" -->
    <div id="divMain" data-role="page" data-theme="b" data-ajax="false">
        <!--#include virtual="~/_static/header.shtml" -->
        <div class="ui-content" role="main">

            <section class="section banner-slider">
                <div class="slide">
                    <a rel="clubpalazzo" href="/_static/palazzo/casino.aspx" data-ajax="false">
                        <img src="/_Static/Images/Download/W88-Mobile-ClubPalazzo-Casino.jpg" alt="banner" class="img-responsive">
                    </a>
                </div>
                <div class="slide">
                    <a rel="clbW" href="/_static/ClubW/casino.aspx" data-ajax="false">
                        <img src="/_Static/Images/Download/W88-Mobile-ClubW-Casino.jpg" alt="banner" class="img-responsive">
                    </a>
                </div>
                <div class="slide">
                    <a href="https://livegames.gameassists.co.uk/MobileClient/MobileRedirector/index.aspx?AppID=W88Diamond&ClientID=5&UL=en" data-ajax="false">
                        <img src="/_Static/Images/Download/W88-Mobile-ClubPalazzo-Slots.jpg" alt="banner" class="img-responsive">
                    </a>
                </div>
            </section>

        <% if (string.IsNullOrEmpty(commonVariables.CurrentMemberSessionId)) {
            var queryString = commonVariables.GetSessionVariable("AffiliateId") == string.Empty ? "" : "?affiliateId=" + commonVariables.GetSessionVariable("AffiliateId"); %>
            <div class="row row-no-padding action-btn">
                <div class="col">
                    <a href="/_Secure/Register.aspx<%= queryString %>" class="ui-btn btn-secondary" role="button" data-ajax="false">
                        <%=commonCulture.ElementValues.getResourceString("joinnow", commonVariables.LeftMenuXML)%>
                    </a>
                </div>
                <div class="col">
                    <a href="/_Secure/Login.aspx" class="ui-btn btn-primary" role="button" data-rel="dialog" data-transition="slidedown">
                        <%=commonCulture.ElementValues.getResourceString("login", commonVariables.LeftMenuXML)%>
                    </a>
                </div>
            </div>
        <% } %>
            <form runat="server">
                <div class="row ">
                    <div class="col">
                        <div class="app" style="text-align:left">
                            <img src="/_Static/Images/w88-appicon-<%=commonVariables.SelectedLanguageShort%>.png" alt="app-icon" class="img-responsive" style="width:120px">
                            <h5>3 Easy Steps to Play Club W Download Version</h5>
                             1. Click the Download button below.
                            <br />2. Install by clicking Run or Save it in your local hard drive.
                            <br />3. Login with your web username & password.

                            <div style="margin: 8px 0 0; text-align:left;">
                            <br/>
                            <asp:CheckBox ID="clubW_msg_chk" runat="server" Width="35px" Height="11px"/>Do not show again
		                    </div>

                        </div>

                        <div class="row">
                            <div class="col">
                                     <asp:LinkButton ID="Cancel_Btn"  runat="server" class="ui-btn btn-bordered" OnClick="Cancel_Btn_Click">Cancel</asp:LinkButton>
                            </div>
                            <div class="col">
                                     <asp:LinkButton ID="Download_Btn" Text ="Cancel" runat="server" class="ui-btn btn-primary" OnClick="Download_Btn_Click">Download</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
              </form>


            <ul class="hide">
                <li class="li-pokerIOS" runat="server" id ="pokerIOS_link">
                    <a rel="PokerIOS" href="#" data-ajax="false" target="_blank" runat="server" id ="pokerIOS">
                        <div><%=commonCulture.ElementValues.getResourceXPathString("Products/Poker/Label", commonVariables.ProductsXML)%></div>
                    </a>
                </li>
                <li class="li-pokerAndroid" runat="server" id ="pokerAndroid_link" >
                    <a rel="PokerAndroid" href="#" data-ajax="false" target="_blank" runat="server" id ="pokerAndroid">
                        <div><%=commonCulture.ElementValues.getResourceXPathString("Products/Poker/Label", commonVariables.ProductsXML)%></div>
                    </a>
                </li>
            </ul>

        </div>

        <!--#include virtual="~/_static/footer.shtml" -->
        <!--#include virtual="~/_static/navMenu.shtml" -->

        <script src="/_Static/Js/vendor/slick.min.js"></script>
        <script>
            // Slick - Slider Banner
            $(document).ready(function(){
                $('.banner-slider').slick({
                    dots: true
                });
            });
        </script>

    </div>
</body>
</html>