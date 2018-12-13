using PrizeClaimScanner.Service.PDF;
using PrizeClaimScanner.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace PrizeClaimScanner.View
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class PdfPage : ContentPage
    {
        public PdfPage(PrizeClaimFormViewModel Model)
        {
            InitializeComponent();
            ClaimFormPdf ps = new ClaimFormPdf(Model);
            DependencyService.Get<IPrintService>().RegisterForPrinting();

            Task.Run(async () => { await DependencyService.Get<IFolderService>().DeleteLocalFileAsync(PrizeClaimFormViewModel.DestinationFileName); }).Wait();
            ps.CreateAnnotatedPdf(PrizeClaimFormViewModel.SourceFileName, PrizeClaimFormViewModel.DestinationFileName);
            PdfImage.SourceFileName = PrizeClaimFormViewModel.DestinationFileName;
        }

        protected override void OnDisappearing()
        {
            base.OnDisappearing();
            DependencyService.Get<IPrintService>().UnregisterForPrinting();
        }


        private void PrintBtn_Clicked(object sender, EventArgs e)
        {
            Device.BeginInvokeOnMainThread(async () =>
           {
               await DependencyService.Get<IPrintService>().PreparePrintContentAsync(PrizeClaimFormViewModel.DestinationFileName);
               await DependencyService.Get<IPrintService>().PrintAsync();
           });
        }

        private void MainMenuBtn_Clicked(object sender, EventArgs e)
        {
            Navigation.PopToRootAsync();
        }
    }
}