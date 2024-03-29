﻿using Xamarin.Forms;

namespace PrizeClaimScanner
{
    public class CustomWebView : WebView
    {
        public static readonly BindableProperty UriProperty = BindableProperty.Create("Uri", typeof(string), typeof(CustomWebView), default(string));

        public string Uri
        {
            get { return (string)GetValue(UriProperty); }
            set { SetValue(UriProperty, value); }
        }

    }
}
