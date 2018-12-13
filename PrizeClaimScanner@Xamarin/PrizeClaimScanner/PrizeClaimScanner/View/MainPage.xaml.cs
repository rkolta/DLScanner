using PrizeClaimScanner.Service;
using PrizeClaimScanner.View;
using PrizeClaimScanner.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using ZXing;
using ZXing.Mobile;
using ZXing.Net.Mobile.Forms;

namespace PrizeClaimScanner
{
    public partial class MainPage : ContentPage
    {
        public PrizeClaimFormViewModel FormModel { get; set; }
        public ParserService  ParserService { get; set; }
        public MainPage()
        {
            InitializeComponent();
            FormModel = new PrizeClaimFormViewModel();
            ParserService = new ParserService();
        }

        #region Button Events

        private async void ScanDL_Clicked(object sender, EventArgs e)
        {
            var scanPage = new ScanService().GetDriverLicenseScanPage();

            await Navigation.PushAsync(scanPage);

            scanPage.OnScanResult += (result) =>
            {
                // Stop scanning
                scanPage.IsScanning = false;

                // Pop the page and show the result
                Device.BeginInvokeOnMainThread(async () =>
                {
                    await Navigation.PopAsync();
                    await DisplayAlert("Success","Driver License Scan Complete", "OK");
                    
                    if (!ParserService.ParseDL(result.Text, FormModel))
                    {
                        await DisplayAlert("Error!", ParserService.LastErrorMessage, "OK");
                    }
                });
            };
        }

        private async void ScanTicket_Clicked(object sender, EventArgs e)
        {
            var scanPage = new ScanService().GetTicketScanPage();

            await Navigation.PushAsync(scanPage);

            scanPage.OnScanResult += (result) =>
            {
                // Stop scanning
                scanPage.IsScanning = false;

                // Pop the page and show the result
                Device.BeginInvokeOnMainThread(async () =>
                {
                    await Navigation.PopAsync();
                    await DisplayAlert("Success", "Ticket Scan Complete", "OK");

                    if (!ParserService.ParseTicket(result.Text, FormModel))
                    {
                        await DisplayAlert("Error!", ParserService.LastErrorMessage, "OK");
                        ParserService.ClearErrors();
                    }
                });
            };
        }

        private void ClaimForm_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new ClaimFormPage() { BindingContext = FormModel});
        }

        private void PdfPage_Clicked(object sender, EventArgs e)
        {
            Navigation.PushAsync(new PdfPage(FormModel));
        }

        private void Clear_Clicked(object sender, EventArgs e)
        {
            Device.BeginInvokeOnMainThread(async () =>
            {
                var answer = await DisplayAlert("Clear", "Are you sure you want to clear claimant information?", "Yes", "No");
                if(answer)
                {
                    FormModel = new PrizeClaimFormViewModel();
                    await DependencyService.Get<IFolderService>().DeleteLocalFileAsync(PrizeClaimFormViewModel.DestinationFileName);
                }
            });
           
        }

        #endregion
    }
}
