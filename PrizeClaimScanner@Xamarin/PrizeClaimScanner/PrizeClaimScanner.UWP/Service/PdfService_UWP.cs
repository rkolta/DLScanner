using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Data.Pdf;
using Windows.Storage.Streams;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media.Imaging;

namespace PrizeClaimScanner.UWP
{
    class PdfService_UWP
    {
        protected FolderServices_UWP fs = new FolderServices_UWP();
        protected uint Dpi { get; set; } = 200;

        public async Task<PdfDocument> LoadDocumentAsync(string filename)
        {
            PdfDocument document;
            var file = await fs.LoadFileFromLocalFolderAsync(filename);
            //using (IRandomAccessStream stream = await file.OpenReadAsync())
            //{
            // document = await PdfDocument.LoadFromStreamAsync(stream);
            //}
            document = await PdfDocument.LoadFromFileAsync(file);
            return document;
        }

        public async Task<List<Image>> GetPdfAsImagesAsync(PdfDocument document)
        {
            List<Image> images = new List<Image>() { };

            for (int i = 0; i < document.PageCount - 1; i++)
            {
                using (var page = document.GetPage((uint)i))
                {
                    using (var stream = new InMemoryRandomAccessStream())
                    {
                        var options = new PdfPageRenderOptions
                        {
                            // Render to Image in target resolution; DIP = 1/96 (Device-Independent Pixels)
                            DestinationWidth = (uint)((page.Size.Width * Dpi) / 96),
                            DestinationHeight = (uint)((page.Size.Height * Dpi) / 96)
                        };
                        await page.RenderToStreamAsync(stream, options);
                        BitmapImage src = new BitmapImage();
                        Image img = new Image
                        {
                            Source = src
                        };
                        await src.SetSourceAsync(stream);
                        images.Add(img);
                    }
                }
            }
            return images;
        }

    }
}
