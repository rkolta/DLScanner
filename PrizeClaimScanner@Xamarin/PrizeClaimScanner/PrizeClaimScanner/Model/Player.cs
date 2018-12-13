using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;

namespace PrizeClaimScanner.Model
{
    public class Player : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged([CallerMemberName] string propName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propName));
        }

        private int? _month;
        private int? _day;
        private int? _year;
        private string _ssn;

        public string FirstName { set; get; }
        public string LastName { set; get; }
        public string Suffix { set; get; }

        public Gender Gender { set; get; }

        public int? Month {
            set
            {
                _month = value;
                OnPropertyChanged();
            }
            get
            {
                return _month;
            }
        }
        public int? Day {
            set
            {
                _day = value;
                OnPropertyChanged();
            }
            get
            {
                return _day;
            }
        }
        public int? Year {
            set
            {
                _year = value;
                OnPropertyChanged();
            }
            get
            {
                return _year;
            }
        }

        public string SSN {
            set
            {
                _ssn = value;
                OnPropertyChanged();
            }
            get
            {
                return _ssn;
            }
        }

        public string Address1 { set; get; }
        public string Address2 { set; get; }
        public string City { set; get; }
        public string State { set; get; }
        public string Zipcode1 { set; get; }
        public string Zipcode2 { set; get; }
        public string Country { set; get; }

        public string Email { set; get; }
        public string Phone { set; get; }

        public bool NoSSN { set; get; }
        public bool NonCitizen { set; get; }
    }
}
