using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;

namespace PrizeClaimScanner.Model
{
    public class Race : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged([CallerMemberName] string propName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propName));
        }

        private bool _isOther;
        private string _otherText;

        public bool IsAfricanAmerican { get; set; }
        public bool IsAsian { get; set; }
        public bool IsHispanic { get; set; }
        public bool IsWhite { get; set; }
        public bool IsOther
        {
            get
            {
                return _isOther;
            }
            set
            {
                _isOther = value;
                OnPropertyChanged();
                OnPropertyChanged("OtherText");
            }
        }
        public string OtherText {
            get
            {
                if(!IsOther)
                {
                    _otherText = "";
                }
                return _otherText;

            } set
            {
                _otherText = value;
            }
        }
    }
}
