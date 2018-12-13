using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text;

namespace PrizeClaimScanner.Model
{
    public class Ticket : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged([CallerMemberName] string propName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propName));
        }

        private bool _isScratcher;

        public string TicketNumber { get; set; }
        public decimal PrizeClaimed { get; set; }
        public string CheckDigit { get; set; }
        public bool IsScratcher
        {
            get
            {
                return _isScratcher;
            }
            set
            {
                _isScratcher = value;
                OnPropertyChanged();
            }
        }
    }
}

