using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PrizeClaimScanner.ViewModel;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace PrizeClaimScanner.View
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class ClaimFormPage : ContentPage
	{
		public ClaimFormPage ()
		{
			InitializeComponent ();
		}

        #region Button Events
        private void PdfPage_Clicked(object sender, EventArgs e)
        {
            if (BindingContext is PrizeClaimFormViewModel)
            {
                    Navigation.PushAsync(new PdfPage(BindingContext as PrizeClaimFormViewModel)); 
            }
        }
        #endregion
    }
}