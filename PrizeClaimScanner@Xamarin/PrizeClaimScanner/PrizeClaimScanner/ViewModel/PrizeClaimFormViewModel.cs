using PrizeClaimScanner.Model;
using PrizeClaimScanner.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PrizeClaimScanner.ViewModel
{
    public class PrizeClaimFormViewModel : ViewModelBase
    {
        private Player _player;
        private Ticket _ticket;
        private Occupation _occupation;
        private Education _education;
        private Race _race;
        private HouseholdIncome _householdIncome;
        private bool _isLotteryRetailer;
        private bool _isLotteryEmployee;
        private bool _isLotteryRetailerRelated;
        private int? _noPeopleInHousehold;

        //Embedded Resource
        public static readonly string SourceFileName = "PrizeClaimScanner.Assets.claimform.pdf";
        //Content File
        public static readonly string DestinationFileName = "FinalClaimForm.pdf";

        public PrizeClaimFormViewModel()
        {
            Player = new Player();
            Race = new Race();
            Occupation = new Occupation();
            Ticket = new Ticket();
        }

        public bool IsLotteryRetailer { get => _isLotteryRetailer; set => _isLotteryRetailer = value; }
        public bool IsLotteryRetailerEmployee { get => _isLotteryEmployee; set => _isLotteryEmployee = value; }
        public bool IsLotteryRetailerRelated { get => _isLotteryRetailerRelated; set => _isLotteryRetailerRelated = value; }
        public int? NoPeopleInHousehold {
            set
            {
                _noPeopleInHousehold = value;
                OnPropertyChanged();
            }
            get
            {
                return _noPeopleInHousehold;
            }
        }

        public Player Player { get => _player; set => _player = value; }
        public Ticket Ticket { get => _ticket; set => _ticket = value; }
        public Occupation Occupation { get => _occupation; set => _occupation = value; }
        public Education Education { get => _education; set => _education = value; }
        public HouseholdIncome HouseholdIncome { get => _householdIncome; set => _householdIncome = value; }
        public Race Race
        {
            get
            {
                return _race;
            }
            set
            {
                _race = value;
            }
        }

        public List<string> HouseholdOptions
        {
            get
            {
                return Enum.GetNames(typeof(HouseholdIncome)).Select(e => e.SplitCamelCase()).ToList();
            }
        }

        public List<string> EducationOptions
        {
            get
            {
                return Enum.GetNames(typeof(Education)).Select(e => e.SplitCamelCase()).ToList();
            }
        }


        public List<string> GenderOptions
        {
            get
            {
                return Enum.GetNames(typeof(Gender)).Select(e => e.SplitCamelCase()).ToList();
            }
        }


    }
}
