using System;
using System.Collections.Generic;
using System.Text;

namespace PrizeClaimScanner.Service
{
    public sealed class CalDLParserService : DLParserServiceBase
    {
        public readonly string FirstName = "DAC";
        public readonly string LastName = "DCS";
        public readonly string Suffix = "DCU";
        public readonly string Address1 = "DAG";
        public readonly string DOB = "DBB";
        public readonly string City = "DAI";
        public readonly string State = "DAJ";
        public readonly string Gender = "DBC";
        public readonly string Country = "DCG";
        public readonly string Zipcode = "DAK";

        public CalDLParserService(string input) : base(input)
        {
        }
    }
}
