﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Secure_Login : BasePage
{
    protected System.Xml.Linq.XElement xeErrors = null;
    protected string strRedirect = string.Empty;

    protected void Page_Init(object sender, EventArgs e)
    {
        string strLanguage = string.Empty;

        strLanguage = Request.QueryString.Get("lang");

        commonVariables.SelectedLanguage = string.IsNullOrEmpty(strLanguage) ? (string.IsNullOrEmpty(commonVariables.SelectedLanguage) ? "en-us" : commonVariables.SelectedLanguage) : strLanguage;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        xeErrors = commonVariables.ErrorsXML;
        System.Xml.Linq.XElement xeResources = null;
        commonCulture.appData.getLocalResource(out xeResources);

        #region initialiseVariables
        int intProcessSerialId = 0;
        string strProcessId = Guid.NewGuid().ToString().ToUpper();
        string strPageName = "ProcessLoginBySessionId";

        string strResultCode = string.Empty;
        string strResultDetail = string.Empty;
        string strErrorCode = string.Empty;
        string strErrorDetail = string.Empty;
        string strProcessRemark = string.Empty;
        bool isProcessAbort = false;
        bool isSystemError = false;

        //string strLanguage = string.Empty;
        string strSessionId = string.Empty;
        string strProcessCode = string.Empty;
        string strProcessMessage = string.Empty;

        #endregion

        if (!string.IsNullOrEmpty(Request.QueryString.Get("token")))
        {
            try
            {
                var cipherKey = commonEncryption.Decrypt(ConfigurationManager.AppSettings.Get("PrivateKeyToken"));
                strSessionId = commonEncryption.decryptToken(Request.QueryString.Get("token"), cipherKey);
                commonVariables.SetSessionVariable("CurrentMemberSessionId", strSessionId);

                var loginCode = UserSession.checkSession();

                if (loginCode != "1")
                {
                    commonVariables.ClearSessionVariables();
                    commonCookie.ClearCookies();
                    Response.Redirect("/_Secure/Login_app.aspx");
                }
                else
                {
                    Response.Redirect("/Deposit/Default_app.aspx");
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("/Deposit/Default_app.aspx");
            }

        }
        else
        {
            if (UserSession.IsLoggedIn())
            {
                if (sender.ToString().Contains("app"))
                {
                    Response.Redirect("/Deposit/Default_app.aspx");
                }
                else
                {
                    Response.Redirect("/Index");
                }
            }
        }

        if (string.IsNullOrEmpty(Request.QueryString.Get("redirect"))) { strRedirect = "/Index.aspx?lang=" + commonVariables.SelectedLanguage; }
        else { strRedirect = Request.QueryString.Get("redirect"); }

        if (!Page.IsPostBack)
        {
            lblUsername.Text = commonCulture.ElementValues.getResourceString("lblUsername", xeResources);
            lblPassword.Text = commonCulture.ElementValues.getResourceString("lblPassword", xeResources);
            lblCaptcha.Text = commonCulture.ElementValues.getResourceString("lblCaptcha", xeResources);
            btnSubmit.Text = commonCulture.ElementValues.getResourceString("btnLogin", xeResources);

            txtUsername.Focus();

            lblRegister.Text = commonCulture.ElementValues.getResourceString("btnRegister", xeResources);
        }
    }
}
