using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace PrizeClaimScanner.Service
{
    public class DLParserServiceBase
    {
        public string Input { get; set; }

        public DLParserServiceBase(string input)
        {
            Input = input;
        }

        public virtual string ExtractDLData(string keyword)
        {
            var pattern = string.Format(@"\b(\n{0})([^\n]*)\b", keyword);
            var match = Regex.Match(Input, pattern);
            if (match.Success)
            {
                var split = match.Value.Split(new[] { keyword }, StringSplitOptions.RemoveEmptyEntries);
                return (split.Length > 1 ? split[1] : "");
            }
            return "";
        }
    }
}
