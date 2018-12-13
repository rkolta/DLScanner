using iText.Forms;
using iText.Forms.Fields;
using iText.Kernel.Pdf;
using PrizeClaimScanner.ViewModel;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using Xamarin.Forms;
using PrizeClaimScanner.Extensions;
using PrizeClaimScanner.Model;
using System.Threading.Tasks;

namespace PrizeClaimScanner.Service.PDF
{
    public class ClaimFormPdf : PdfBaseService
    {
        public PrizeClaimFormViewModel Model { set; get; }

        public ClaimFormPdf(PrizeClaimFormViewModel Model) : base()
        {
            this.Model = Model;
        }

        public override void CreateAnnotatedPdf(string inputFilename, string outputFilename)
        {

            //Create PDF in temp location
            var location = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), outputFilename);

            //Read Template PDF and set Destination to create Filled PDF
            using (var stream = OpenTemplatePdfStream(inputFilename))
            {
                var reader = new PdfReader(stream);
                var writer = new PdfWriter(location);
                PdfDocument document = new PdfDocument(reader, writer);

                PdfAcroForm form = PdfAcroForm.GetAcroForm(document, false);
                IDictionary<string, PdfFormField> fields = form.GetFormFields();
                foreach (var field in fields)
                {
                    System.Diagnostics.Debug.WriteLine("{0} and {1}", field.Key, field.Value);
                }
                Init(form);
                document.Close();
                reader.Close();
                writer.Close();
            }
        }


        private void Init(PdfAcroForm form)
        {
            SetPlayerInfo(form);
            SetTicketInfo(form);
            SetRace(form);
            SetHouseholdIncome(form);
            SetEducation(form);
            SetOccupation(form);
            RemovePrintBtn(form);
        }

        private void RemovePrintBtn(PdfAcroForm form)
        {
            foreach(var fname in ClaimFormFields.Clear)
            {
                form.GetField(fname)?.SetVisibility(PdfFormField.HIDDEN);
            }
        }

        private void SetPlayerInfo(PdfAcroForm form)
        {
            form.GetField(ClaimFormFields.FirstName)?.SetValue(Model.Player.FirstName ?? "");
            form.GetField(ClaimFormFields.LastName)?.SetValue(Model.Player.LastName ?? "");
            form.GetField(ClaimFormFields.Suffix)?.SetValue(Model.Player.Suffix ?? "");
            form.GetField(ClaimFormFields.Month)?.SetValue(Model.Player.Month?.ToString() ?? "");
            form.GetField(ClaimFormFields.Day)?.SetValue(Model.Player.Day?.ToString() ?? "");
            form.GetField(ClaimFormFields.Year)?.SetValue(Model.Player.Year?.ToString() ?? "");
            form.GetField(ClaimFormFields.Address1)?.SetValue(Model.Player.Address1 ?? "");
            form.GetField(ClaimFormFields.Address2)?.SetValue(Model.Player.Address2 ?? "");
            form.GetField(ClaimFormFields.City)?.SetValue(Model.Player.City ?? "");
            form.GetField(ClaimFormFields.Country)?.SetValue(Model.Player.Country ?? "");
            form.GetField(ClaimFormFields.Email)?.SetValue(Model.Player.Email ?? "");
            form.GetField(ClaimFormFields.State)?.SetValue(Model.Player.State ?? "");
            form.GetField(ClaimFormFields.Zipcode1)?.SetValue(Model.Player.Zipcode1 ?? "");
            form.GetField(ClaimFormFields.Zipcode2)?.SetValue(Model.Player.Zipcode2 ?? "");
            form.GetField(ClaimFormFields.Phone1)?.SetValue(Model.Player.Phone.ExtractString(0, 3));
            form.GetField(ClaimFormFields.Phone2)?.SetValue(Model.Player.Phone.ExtractString(3, 3));
            form.GetField(ClaimFormFields.Phone3)?.SetValue(Model.Player.Phone.ExtractString(6));

            foreach (var fname in ClaimFormFields.SSN)
            {
                if (form.GetField(fname) != null)
                {
                    var field = form.GetField(fname) as PdfTextFormField;
                    field.SetPassword(false);
                }
            }

            form.GetField(ClaimFormFields.SSN[0])?.SetValue(Model.Player.SSN.ExtractString(0, 3));
            form.GetField(ClaimFormFields.SSN[1])?.SetValue(Model.Player.SSN.ExtractString(3, 2));
            form.GetField(ClaimFormFields.SSN[2])?.SetValue(Model.Player.SSN.ExtractString(5));

            if (Model.Player.NoSSN)
            {
                form.GetField(ClaimFormFields.NoSSN)?.SetValue("On");
            }

            if (Model.Player.NonCitizen)
            {
                form.GetField(ClaimFormFields.NonCitizen)?.SetValue("On");
            }

            if (Model.IsLotteryRetailer)
            {
                form.GetField(ClaimFormFields.IsLotteryRetailer[0])?.SetValue("On");
            }
            else
            {
                form.GetField(ClaimFormFields.IsLotteryRetailer[1])?.SetValue("On");
            }

            if (Model.IsLotteryRetailerEmployee)
            {
                form.GetField(ClaimFormFields.IsLotteryRetailerEmployee[0])?.SetValue("On");
            }
            else
            {
                form.GetField(ClaimFormFields.IsLotteryRetailerEmployee[1])?.SetValue("On");
            }

            if (Model.IsLotteryRetailerRelated)
            {
                form.GetField(ClaimFormFields.IsLotteryRetailerRelated[0])?.SetValue("On");
            }
            else
            {
                form.GetField(ClaimFormFields.IsLotteryRetailerRelated[1])?.SetValue("On");
            }

            if (Model.Player.Gender == PrizeClaimScanner.Model.Gender.Female)
            {
                form.GetField(ClaimFormFields.Female)?.SetValue("On");
            }

            if (Model.Player.Gender == PrizeClaimScanner.Model.Gender.Male)
            {
                form.GetField(ClaimFormFields.Male)?.SetValue("On");
            }
        }

        private void SetTicketInfo(PdfAcroForm form)
        {
            var ticket = Model.Ticket.TicketNumber ?? "";
            var prizeClaimed = Model.Ticket.PrizeClaimed.ToString();
            string[] ticketFields;
            string[] prizeFields;
            if (Model.Ticket.IsScratcher)
            {
                ticketFields = ClaimFormFields.ScratcherTicket;
                prizeFields = ClaimFormFields.ScratcherPrizeClaimed;
                form.GetField(ClaimFormFields.CheckDigit)?.SetValue(Model.Ticket.CheckDigit ?? "");
            }
            else
            {
                ticketFields = ClaimFormFields.GameTicket;
                prizeFields = ClaimFormFields.GamePrizeClaimed;
            }

            int i = 0;

            while (i < ticketFields.Length && i < ticket.Length)
            {
                var num = ticket.Substring(i, 1);
                form.GetField(ticketFields[i])?.SetValue(num);
                i++;
            }

            i = 0;
            while (i < prizeFields.Length && i < prizeClaimed.Length)
            {
                var num = prizeClaimed.Substring(i, 1);
                form.GetField(prizeFields[i])?.SetValue(num);
                i++;
            }

        }

        private void SetRace(PdfAcroForm form)
        {
            if(Model.Race.IsAfricanAmerican)
            {
                form.GetField(ClaimFormFields.Race["AA"])?.SetValue("On");
            }

            if(Model.Race.IsAsian)
            {
                form.GetField(ClaimFormFields.Race["A"])?.SetValue("On");
            }

            if(Model.Race.IsHispanic)
            {
                form.GetField(ClaimFormFields.Race["H"])?.SetValue("On");
            }

            if(Model.Race.IsWhite)
            {
                form.GetField(ClaimFormFields.Race["W"])?.SetValue("On");
            }

            if(Model.Race.IsOther)
            {
                form.GetField(ClaimFormFields.Race["O"])?.SetValue("On");
                form.GetField(ClaimFormFields.Race["S"])?.SetValue(Model.Race.OtherText ?? "");
            }

        }

        private void SetHouseholdIncome(PdfAcroForm form)
        {
            switch(Model.HouseholdIncome)
            {
                case HouseholdIncome.Under20K:
                    form.GetField(ClaimFormFields.HousholdIncome[0])?.SetValue("On");
                    break;
                case HouseholdIncome.From20KTo35K:
                    form.GetField(ClaimFormFields.HousholdIncome[1])?.SetValue("On");
                    break;
                case HouseholdIncome.From35KTo50K:
                    form.GetField(ClaimFormFields.HousholdIncome[2])?.SetValue("On");
                    break;
                case HouseholdIncome.From50KTo75K:
                    form.GetField(ClaimFormFields.HousholdIncome[3])?.SetValue("On");
                    break;
                case HouseholdIncome.Over75K:
                    form.GetField(ClaimFormFields.HousholdIncome[4])?.SetValue("On");
                    break;
            }
            form.GetField(ClaimFormFields.HousholdIncome[5])?.SetValue(Model.NoPeopleInHousehold?.ToString() ?? "");
        }

        private void SetEducation(PdfAcroForm form)
        {
            switch(Model.Education)
            {
                case Education.DidNotFinishHighSchool:
                    form.GetField(ClaimFormFields.Education[0])?.SetValue("On");
                    break;
                case Education.GraduatedHighSchoolOrGED:
                    form.GetField(ClaimFormFields.Education[1])?.SetValue("On");
                    break;
                case Education.SomeCollege:
                    form.GetField(ClaimFormFields.Education[2])?.SetValue("On");
                    break;
                case Education.GradutedCollege:

                    form.GetField(ClaimFormFields.Education[3])?.SetValue("On");
                    break;
            }
        }

        private void SetOccupation(PdfAcroForm form)
        {
            if (Model.Occupation.IsEmployed)
            {
                form.GetField(ClaimFormFields.Occupation["E"])?.SetValue("On");
            }
            if (Model.Occupation.IsRetired)
            {
                form.GetField(ClaimFormFields.Occupation["R"])?.SetValue("On");
            }
            if (Model.Occupation.IsStudent)
            {
                form.GetField(ClaimFormFields.Occupation["S"])?.SetValue("On");
            }
            if (Model.Occupation.IsUnemployed)
            {
                form.GetField(ClaimFormFields.Occupation["U"])?.SetValue("On");
            }
        }
    }

    #region Form Fields
    public static class ClaimFormFields
    {
        public static string[] PrintBtn { get; } = { "form1[0].Page1[0].PrintClear1[0]", "form1[0].Page1[0].PrintButton1[0]" };
        public static string FirstName { get; } = "form1[0].Page1[0].FirstNameIF[0]";
        public static string LastName { get; } = "form1[0].Page1[0].LastNameIF[0]";
        public static string Suffix { get; } = "form1[0].Page1[0].SuffixIF[0]";
        public static string Month { get; } = "form1[0].Page1[0].DOBIF1[0]";
        public static string Day { get; } = "form1[0].Page1[0].DOBIF2[0]";
        public static string Year { get; private set; } = "form1[0].Page1[0].DOBIF3[0]";
        public static string Address1 { get; } = "form1[0].Page1[0].AddreIF[0]";
        public static string Address2 { get; } = "form1[0].Page1[0].Address2IF[0]";
        public static string City { get; } = "form1[0].Page1[0].CityIF[0]";
        public static string Country { get; } = "form1[0].Page1[0].CountryIF[0]";
        public static string Email { get; } = "form1[0].Page1[0].EmailIF[0]";
        public static string State { get; } = "form1[0].Page1[0].StateIF[0]";
        public static string Zipcode1 { get; } = "form1[0].Page1[0].ZipIF1[0]";
        public static string Zipcode2 { get; } = "form1[0].Page1[0].ZipIF2[0]";
        public static string[] SSN = 
        {
            "form1[0].Page1[0].Pass1[0]",
            "form1[0].Page1[0].Pass2[0]",
            "form1[0].Page1[0].Pass3[0]"
        };
        public static string Female { get; } = "form1[0].Page1[0].CheckBox2[15]";
        public static string Male { get; } = "form1[0].Page1[0].CheckBox2[14]";
        public static string Phone1 { get; } = "form1[0].Page1[0].PhoneIF1[0]";
        public static string Phone2 { get; } = "form1[0].Page1[0].PhoneIF2[0]";
        public static string Phone3 { get; } = "form1[0].Page1[0].PhoneIF3[0]";
        public static string NoSSN { get; } = "form1[0].Page1[0].CBSSN[0]";
        public static string NonCitizen { get; } = "form1[0].Page1[0].CBSSN[1]";
        public static string CheckDigit { get; } = "form1[0].Page1[0].TicNumWrap1[0].TN12[0]";
        public static string[] IsLotteryRetailer =
        {
            "form1[0].Page1[0].CBYes1[0]",
            "form1[0].Page1[0].CBNo1[0]"
        };
        public static string[] IsLotteryRetailerEmployee =
        {
            "form1[0].Page1[0].CBYes2[0]",
            "form1[0].Page1[0].CBNo2[0]"
        };
        public static string[] IsLotteryRetailerRelated =
        {
            "form1[0].Page1[0].CBYes3[0]",
            "form1[0].Page1[0].CBNo3[0]"
        };
        public static Dictionary<string, string> Race = new Dictionary<string, string>
        {
            {"AA", "form1[0].Page1[0].CheckBox2[0]" },
            {"A", "form1[0].Page1[0].CheckBox2[1]" },
            {"H", "form1[0].Page1[0].CheckBox2[2]" },
            {"W", "form1[0].Page1[0].CheckBox2[3]" },
            {"O", "form1[0].Page1[0].CheckBox2[4]" },
            {"S", "form1[0].Page1[0].TextField2[0]" }
        };
        public static string[] HousholdIncome = 
        {
           "form1[0].Page1[0].CheckBox2[5]",
           "form1[0].Page1[0].CheckBox2[6]",
           "form1[0].Page1[0].CheckBox2[7]",
           "form1[0].Page1[0].CheckBox2[8]",
           "form1[0].Page1[0].CheckBox2[9]",
           "form1[0].Page1[0].TextField2[1]"
        };
        public static string[] Education =
        {
            "form1[0].Page1[0].CheckBox2[10]",
            "form1[0].Page1[0].CheckBox2[11]",
            "form1[0].Page1[0].CheckBox2[12]",
            "form1[0].Page1[0].CheckBox2[13]"
        };
        public static Dictionary<string, string> Occupation = new Dictionary<string, string>
        {
            {"S", "form1[0].Page1[0].CheckBox2[16]" },
            {"E", "form1[0].Page1[0].CheckBox2[17]" },
            {"U", "form1[0].Page1[0].CheckBox2[18]" },
            {"R", "form1[0].Page1[0].CheckBox2[19]" },

        };
        public static string[] ScratcherTicket { get; } =
        {
            "form1[0].Page1[0].TicNumWrap1[0].TN1[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN2[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN3[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN4[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN5[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN6[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN7[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN8[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN9[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN10[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN11[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN13[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN14[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN15[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN16[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN17[0]",
            "form1[0].Page1[0].TicNumWrap1[0].TN18[0]"
        };
        public static string[] GameTicket { get; } =
        {
            "form1[0].Page1[0].TicNumWrap1[1].TN1[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN2[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN3[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN4[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN5[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN6[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN7[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN8[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN9[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN10[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN11[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN12[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN13[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN14[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN15[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN16[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN17[0]",
            "form1[0].Page1[0].TicNumWrap1[1].TN18[0]"
        };
        public static string[] ScratcherPrizeClaimed =
        {
            "form1[0].Page1[0].TextField3[0]",
            "form1[0].Page1[0].TextField3[1]",
            "form1[0].Page1[0].TextField3[2]",
            "form1[0].Page1[0].TextField3[4]",
            "form1[0].Page1[0].TextField3[7]",
            "form1[0].Page1[0].TextField3[3]",
            "form1[0].Page1[0].TextField3[5]",
            "form1[0].Page1[0].TextField3[6]",
            "form1[0].Page1[0].TextField3[8]",
        };
        public static string[] GamePrizeClaimed =
        {
            "form1[0].Page1[0].TextField3[9]",
            "form1[0].Page1[0].TextField3[10]",
            "form1[0].Page1[0].TextField3[11]",
            "form1[0].Page1[0].TextField3[13]",
            "form1[0].Page1[0].TextField3[16]",
            "form1[0].Page1[0].TextField3[12]",
            "form1[0].Page1[0].TextField3[14]",
            "form1[0].Page1[0].TextField3[15]",
            "form1[0].Page1[0].TextField3[17]",
        };
        public static string[] Clear =
        {
            "form1[0].Page1[0].PrintButton1[0]",
            "form1[0].Page1[0].PrintClear1[0]"
        };
    }
    #endregion
}
