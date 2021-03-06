﻿using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Text;

public partial class _Lang : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        var divBuilder = new StringBuilder();
        var enabledLanguages = OperatorSettings.Get("EnabledLanguages");
        var availableLanguages = OperatorSettings.Get("LanguageSelection").Split('|');
        var countryCode = CountryCode;
        foreach (var language in availableLanguages)
        {
            switch (countryCode)
            {
                case "my":
                    divBuilder.Append(@"<div class='col-xs-6'>")
                        .Append(@"<span id='");

                    switch (language)
                    {
                        case "en-us":
                            divBuilder.Append(enabledLanguages.Contains("en-my") ? "en-my" : language);
                            break;
                        case "zh-cn":
                            divBuilder.Append(enabledLanguages.Contains("zh-my") ? "zh-my" : language);
                            break;
                        default:
                            divBuilder.Append(language);
                            break;
                    }

                    divBuilder.Append("' class='flags'></span>")
                        .Append(@"</div>");
                    break;
                default:
                    divBuilder.Append(@"<div class='col-xs-6'>")
                        .Append(@"<span id='")
                        .Append(language)
                        .Append("' class='flags'></span>")
                        .Append(@"</div>");
                    break;
            }
        }
        divLanguageContainer.InnerHtml = divBuilder.ToString();
    }

    private static NameValueCollection OperatorSettings
    {
        get
        {
            return ConfigurationManager.GetSection("OperatorGroupSettings/W88") as NameValueCollection;
        }
    }
}