﻿using Factories.Slots;
using Helpers;
using Helpers.GameProviders;
using Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Xml.Linq;

/// <summary>
/// Summary description for Banner
/// </summary>
public class Banner
{
    private XElement promoResource;
    public string slider = string.Empty;
    private string BannerTemplate = string.Empty;
    public Banner()
    {
        commonCulture.appData.getRootResource("leftMenu", out promoResource);
        BannerTemplate = "<a href=\"{link}\" class=\"slick-slide\">" +
            "<img src=\"{img}\" alt=\"\">" +
        "</a>";
        SetBanners();
    }

    public string GetBanners()
    {
        return slider;
    }

    public void setTemplate(string CustomTemplate)
    {
        BannerTemplate = CustomTemplate;
        slider = string.Empty;
        SetBanners();
    }

    private void SetBanners()
    {

        try
        {
            IEnumerable<System.Xml.Linq.XElement> promoNode = promoResource.Element("PromoBanner").Elements();
            foreach (System.Xml.Linq.XElement promo in promoNode)
            {
                var imageRoot = "/_Static/Images/promo-banner/";
                var imageSrc = promo.Element("imageSrc").Value;
                var url = promo.Element("url").Value;
                var mainText = promo.Element("title").Value;
                var descText = promo.Element("description").Value;
                var linkClass = promo.Element("class").Value;
                var content = "";
                var description = "";

                try
                {
                    if (promo.Attribute("PromoStart") != null)
                    {
                        var promoStart = promo.Attribute("PromoStart").Value;
                        DateTime start = DateTime.Parse(promoStart, null);
                        if (start > DateTime.Now)
                            continue;

                    }

                    if (promo.Attribute("PromoEnd") != null)
                    {
                        var promoEnd = promo.Attribute("PromoEnd").Value;
                        DateTime end = DateTime.Parse(promoEnd, null);
                        if (end <= DateTime.Now)
                            continue;
                    }

                }
                catch (Exception e) { }

                if (promo.Attribute("Id") != null)
                {
                    var provider = string.Empty;
                    if (promo.Attribute("provider") != null)
                        provider = promo.Attribute("provider").Value;

                    url = BuildUrl(promo, provider);
                }

                var hasCurrency = (promo.HasAttributes && promo.Attribute("currency") != null);
                var isPublic = (promo.HasAttributes && promo.Attribute("public") != null);

                if (hasCurrency && !string.IsNullOrEmpty(commonVariables.CurrentMemberSessionId))
                {
                    var currencies = promo.Attribute("currency").Value;
                    if (!string.IsNullOrEmpty(currencies))
                    {
                        if (string.IsNullOrEmpty(commonCookie.CookieCurrency)) continue;
                        var currenciesArr = currencies.ToString().Split(',');
                        var test = Array.Find(currenciesArr, element => element.StartsWith(commonCookie.CookieCurrency, StringComparison.Ordinal));
                        if (string.IsNullOrEmpty(test)) continue;
                    }
                }
                if (isPublic && string.IsNullOrEmpty(commonVariables.CurrentMemberSessionId))
                {
                    var publicAttr = promo.Attribute("public").Value;
                    if (!string.IsNullOrEmpty(publicAttr))
                    {
                        if (publicAttr != "1")
                        {
                            continue;
                        }
                    }
                }

                StringBuilder sliderTemplate = new StringBuilder(BannerTemplate);
                sliderTemplate.Replace("{link}", url);
                sliderTemplate.Replace("{img}", imageRoot + imageSrc);
                sliderTemplate.Replace("{description}", description);
                sliderTemplate.Replace("{content}", content);
                sliderTemplate.Replace("{description}", descText);

                //if (!string.IsNullOrWhiteSpace(descText)) description = "<p>" + descText + "</p>";
                //if (!string.IsNullOrWhiteSpace(mainText)) content = "<div class=\"slide-title\"><h2>" + mainText + "</h2>" + description + "</div>";

                //var bannerText = "";
                //if (!string.IsNullOrWhiteSpace(content) || !string.IsNullOrWhiteSpace(content))
                //{
                //    bannerText = "<div class=\"slide_content\"><div class=\"textarea\">" + content + description + "</div></div>";
                //}

                //slider += "<div class=\"slide\">" +
                //            "<a href=\"" + url + "\" data-ajax=\"false\" class=\"" + linkClass + "\">" +
                //            content +
                //                "<img src=\"/_Static/Images/promo-banner/" + imageSrc + "\" alt=\"banner\" class=\"img-responsive\"> " +
                //            "</a>" +
                //        "</div>";
                slider += sliderTemplate.ToString();
            }
        }
        catch (Exception)
        {
        }


    }

    private string BuildUrl(XElement element, string provider)
    {

        if (provider.ToLower() == GameProvider.GPI.ToString().ToLower())
        {
            var funUrl = GameSettings.GetGameUrl(GameProvider.GPI, GameLinkSetting.Fun);
            var realUrl = GameSettings.GetGameUrl(GameProvider.GPI, GameLinkSetting.Real);

            var gpi = new Gpi(new GameLinkInfo
            {
                Fun = funUrl,
                Real = realUrl,
                MemberSessionId = commonVariables.CurrentMemberSessionId
            });

            return string.IsNullOrWhiteSpace(commonVariables.CurrentMemberSessionId)
                ? gpi.BuildUrl(funUrl, element, GameLinkSetting.Fun)
                : gpi.BuildUrl(realUrl, element, GameLinkSetting.Real);
        }

        return string.Empty;
    }
}