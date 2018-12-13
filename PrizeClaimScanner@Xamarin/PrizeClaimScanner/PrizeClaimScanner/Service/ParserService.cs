using PrizeClaimScanner.Model;
using PrizeClaimScanner.ViewModel;
using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace PrizeClaimScanner.Service
{

    public class ParserService
    {

        public string LastErrorMessage { get; private set; } = "";

        public bool ParseTicket(string input, PrizeClaimFormViewModel model)
        {
            var success = true;
            
            if(input.Length == 16)
            {
                model.Ticket.IsScratcher = false;
                model.Ticket.TicketNumber = input;
                model.Ticket.TicketNumber += "35";
                model.Ticket.CheckDigit = string.Empty;
            } else if(input.Length >=14 )
            {
                model.Ticket.IsScratcher = true;
                //get only first 14 numbers of scratcher number, the rest are check digits
                model.Ticket.TicketNumber = input.Substring(0, 14);
            }

            return success;
        }

        public bool ParseDL(string input, PrizeClaimFormViewModel model)
        {
            var success = true;

            var kl = new CalDLParserService(input);

            model.Player.FirstName  = kl.ExtractDLData(kl.FirstName);
            model.Player.LastName   = kl.ExtractDLData(kl.LastName);
            model.Player.Suffix     = kl.ExtractDLData(kl.Suffix);
            model.Player.Address1   = kl.ExtractDLData(kl.Address1);
            model.Player.City       = kl.ExtractDLData(kl.City);
            model.Player.State      = kl.ExtractDLData(kl.State);
            model.Player.Country    = kl.ExtractDLData(kl.Country);

            var zipcode = kl.ExtractDLData(kl.Zipcode);

            if (zipcode.Length >= 5)
            {
                model.Player.Zipcode1 = zipcode.Substring(0, 5);
                if (zipcode.Length >= 9)
                {
                    model.Player.Zipcode2 = zipcode.Substring(5);
                }
            }

            var gender = kl.ExtractDLData(kl.Gender);
            if (!string.IsNullOrEmpty(gender))
            {
                try
                {
                    model.Player.Gender = (Gender)Enum.ToObject(typeof(Gender), int.Parse(gender));
                } catch(Exception e)
                {
                    success = false;
                    LastErrorMessage += "Error During Gender Parsing\n";
                }
            }

            var DOB = kl.ExtractDLData(kl.DOB);
            try
            {
                if (DOB.Length == 8)
                {
                    var start = 0;
                    var length = 2;
                    model.Player.Month = int.Parse(DOB.Substring(start, length));
                    start += length;
                    model.Player.Day = int.Parse(DOB.Substring(start, length));
                    start += length;
                    model.Player.Year = int.Parse(DOB.Substring(start));

                }
            }
            catch (Exception e)
            {
                success = false;
                LastErrorMessage += "Error During DOB Parsing\n";
            }

            return success;
        }

        public void ClearErrors()
        {
            LastErrorMessage = "";
        }
    }
}
