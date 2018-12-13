using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;
using Xamarin.Forms;

namespace PrizeClaimScanner.Converter
{
    class IntStringConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is int)
                return value.ToString();
            return "";
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is string)
            {
                var newValue = Regex.Replace(value.ToString(), @"[^\d]", "");
                if (int.TryParse(newValue, out int num))
                {
                    return num;
                }
            }
            return null;
        }
    }
}
