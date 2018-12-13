using PrizeClaimScanner;
using PrizeClaimScanner.UWP;
using Xamarin.Forms;
using Xamarin.Forms.Platform.UWP;
using System;
using Windows.Data.Pdf;
using Windows.Storage.Streams;
using Windows.UI.Xaml.Media.Imaging;

[assembly: ExportRenderer(typeof(CustomImage), typeof(CustomImageRenderer))]
namespace PrizeClaimScanner.UWP
{
    class CustomImageRenderer : ImageRenderer
    {
        protected override void OnElementChanged(ElementChangedEventArgs<Image> e)
        {
            base.OnElementChanged(e);
            if (e.NewElement != null)
            {
                var customImage = Element as CustomImage;
                var fileName = customImage.SourceFileName;
                BitmapImage src = new BitmapImage();
                Control.Source = src;

                Device.BeginInvokeOnMainThread( async() =>
               {
                   var fs = new FolderServices_UWP();
                   var storagefile = await fs.LoadFileFromLocalFolderAsync(fileName, true);
                   if (storagefile != null)
                   {
                       var pdfdocument = await PdfDocument.LoadFromFileAsync(storagefile);
                       if (pdfdocument != null)
                       {
                           using (PdfPage page = pdfdocument.GetPage(0))
                           {
                               using (InMemoryRandomAccessStream stream = new InMemoryRandomAccessStream())
                               {
                                   await page.RenderToStreamAsync(stream);
                                   await src.SetSourceAsync(stream);
                               }
                           }
                       }
                   }
               });
            }
        }
        
    }
}
