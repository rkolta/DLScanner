using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.Graphics.Printing;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Printing;
using PrizeClaimScanner.UWP;
using Xamarin.Forms;


[assembly: Dependency(typeof(PrintingService_UWP))]
namespace PrizeClaimScanner.UWP
{
    class PrintingService_UWP : IPrintService
    {
        protected PrintDocument printDocument;
        protected IPrintDocumentSource printDocumentSource;
        protected PdfService_UWP ps;
        protected List<Windows.UI.Xaml.Controls.Image> previewPages;
        protected PrintTask printTask;


        public void RegisterForPrinting()
        {
            ps = new PdfService_UWP();

            PrintManager PrintManager = PrintManager.GetForCurrentView();
            PrintManager.PrintTaskRequested += PrintTaskRequested;

            printDocument = new PrintDocument();
            printDocumentSource = printDocument.DocumentSource;
            printDocument.Paginate += Paginate;
            printDocument.GetPreviewPage += GetPreviewPage;
            printDocument.AddPages += AddPages;

        }

        public async Task PreparePrintContentAsync(string filename)
        {
            var document = await ps.LoadDocumentAsync(filename);
            previewPages = await ps.GetPdfAsImagesAsync(document);
        }

        public void UnregisterForPrinting()
        {
            if(previewPages != null)
            {
                previewPages.ForEach(image => image.Source = null);
            }
            
            if (printDocument == null)
            {
                return;
            }

            if (printTask != null)
            {
                printTask.Completed -= PrintTaskCompletedAsync;
            }

            printDocument.Paginate -= Paginate;
            printDocument.GetPreviewPage -= GetPreviewPage;
            printDocument.AddPages -= AddPages;

            // Remove the handler for printing initialization.
            PrintManager printMan = PrintManager.GetForCurrentView();
            printMan.PrintTaskRequested -= PrintTaskRequested;
        }

        public async Task PrintAsync()
        {
            if (PrintManager.IsSupported())
            {
                try
                {
                    // Show print UI
                    await PrintManager.ShowPrintUIAsync();

                }
                catch
                {
                    // Printing cannot proceed at this time
                    ContentDialog noPrintingDialog = new ContentDialog()
                    {
                        Title = "Printing error",
                        Content = "\nSorry, printing can't proceed at this time.",
                        PrimaryButtonText = "OK"
                    };
                    await noPrintingDialog.ShowAsync();
                }
            }
            else
            {
                // Printing is not supported on this device
                ContentDialog noPrintingDialog = new ContentDialog()
                {
                    Title = "Printing not supported",
                    Content = "\nSorry, printing is not supported on this device.",
                    PrimaryButtonText = "OK"
                };
                await noPrintingDialog.ShowAsync();
            }
        }

        protected virtual void PrintTaskRequested(PrintManager sender, PrintTaskRequestedEventArgs e)
        {
            if(printTask != null)
            {
                printTask.Completed -= PrintTaskCompletedAsync;
            }
            printTask = e.Request.CreatePrintTask("CSL Claim Form", sourceRequestedArgs =>
            {
                IList<string> displayedOptions = printTask.Options.DisplayedOptions;

                // Choose the printer options to be shown.
                // The order in which the options are appended determines the order in which they appear in the UI
                displayedOptions.Clear();
                displayedOptions.Add(StandardPrintTaskOptions.Copies);
                displayedOptions.Add(StandardPrintTaskOptions.CustomPageRanges);
                displayedOptions.Add(StandardPrintTaskOptions.Orientation);
                displayedOptions.Add(StandardPrintTaskOptions.MediaSize);
                displayedOptions.Add(StandardPrintTaskOptions.Duplex);
                displayedOptions.Add(StandardPrintTaskOptions.PrintQuality);
                

                // Preset the default value of the printer option
                printTask.Options.MediaSize = PrintMediaSize.NorthAmericaLetter;
                printTask.Options.PrintQuality = PrintQuality.High;
                printTask.Options.PageRangeOptions.AllowCurrentPage = true;
                printTask.Options.PageRangeOptions.AllowAllPages = true;
                
                sourceRequestedArgs.SetSource(printDocumentSource);
            });

            printTask.Completed += PrintTaskCompletedAsync;

        }

        protected void Paginate(object sender, PaginateEventArgs e)
        {
            printDocument.SetPreviewPageCount(previewPages.Count, PreviewPageCountType.Final);
        }

        protected void GetPreviewPage(object sender, GetPreviewPageEventArgs e)
        {
            printDocument.SetPreviewPage(e.PageNumber, previewPages[(e.PageNumber - 1)]);
        }

        protected void AddPages(object sender, AddPagesEventArgs e)
        {
            IList<PrintPageRange> customPageRanges = e.PrintTaskOptions.CustomPageRanges;

            if (customPageRanges.Count == 0)
            {
                for (int i = 0; i < previewPages.Count; i++)
                {
                    printDocument.AddPage(previewPages[i]);
                }
            } else
            {
                foreach (PrintPageRange pageRange in customPageRanges)
                {
                    // The user may type in a page number that is not present in the document.
                    // In this case, we just ignore those pages, hence the checks
                    // (pageRange.FirstPageNumber <= printPreviewPages.Count) and (i <= printPreviewPages.Count).
                    //
                    // If the user types the same page multiple times, it will be printed multiple times
                    // (e.g 3-4;1;1 will print pages 3 and 4 followed by two copies of page 1)
                    if (pageRange.FirstPageNumber <= previewPages.Count)
                    {
                        for (int i = pageRange.FirstPageNumber; (i <= pageRange.LastPageNumber) && (i <= previewPages.Count); i++)
                        {
                            // Subtract 1 because page numbers are 1-based, but our list is 0-based.
                            printDocument.AddPage(previewPages[i - 1]);
                        }
                    }
                }
            }

            PrintDocument printDoc = (PrintDocument)sender;
            printDoc.AddPagesComplete();

        }

        protected async void PrintTaskCompletedAsync(PrintTask sender, PrintTaskCompletedEventArgs args)
        {
            if (args.Completion == PrintTaskCompletion.Failed)
            {
                Windows.UI.Popups.MessageDialog md = new Windows.UI.Popups.MessageDialog("Printing Failed");
                await md.ShowAsync();
            }
        }

    }
}
