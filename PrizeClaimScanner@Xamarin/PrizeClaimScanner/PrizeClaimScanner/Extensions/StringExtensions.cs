using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace PrizeClaimScanner.Extensions
{
    public static class StringExtensions
    {
        public static string SplitCamelCase(this string str)
        {
            return Regex.Replace(
                Regex.Replace(
                    str,
                    @"(\P{Ll})(\P{Ll}\p{Ll})",
                    "$1 $2"
                ),
                @"(\p{Ll})(\P{Ll})",
                "$1 $2"
            );
        }

        public static string ExtractString(this string text, int start, int? length = null)
        {
            if(string.IsNullOrEmpty(text))
            {
                return "";
            }

            if (text.Length >= (start + 1))
            {
                var remainingLength = text.Length - start;

                if (length == null || remainingLength < length)
                {
                    return text.Substring(start);
                }
                return text.Substring(start, length ?? 0);
            }
            return "";
        }
    }
}
