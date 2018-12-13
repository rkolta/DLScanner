using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;
using ZXing;
using ZXing.Mobile;
using ZXing.Net.Mobile.Forms;

namespace PrizeClaimScanner.Service
{
    public class ScanService
    {

        public ZXingScannerPage GetTicketScanPage()
        {
            var options = new MobileBarcodeScanningOptions
            {
                TryHarder = true,
                CameraResolutionSelector = CameraResolutionSelector,
                PossibleFormats = new List<BarcodeFormat> { BarcodeFormat.ITF }
            };

            var scanPage = new ZXingScannerPage(options)
            {
                Title = "Scan Ticket"
            };

            return scanPage;
        }

        public ZXingScannerPage GetDriverLicenseScanPage()
        {
            var options = new MobileBarcodeScanningOptions
            {
                TryHarder = true,
                CameraResolutionSelector = CameraResolutionSelector,
                PossibleFormats = new List<BarcodeFormat> { BarcodeFormat.PDF_417 }
            };

            var scanPage = new ZXingScannerPage(options)
            {
                Title = "Scan Driver License"
            };

            return scanPage;

            //var scanner = new ZXing.Mobile.MobileBarcodeScanner();

            //var result = await scanner.Scan();

            //if (result != null)
            //    System.Diagnostics.Debug.Write("Scanned Barcode: " + result.Text);

        }

        public CameraResolution CameraResolutionSelector(List<CameraResolution> availableResolutions)
        {
            var max = 0;
            CameraResolution selectedResolution = null;
            foreach(var ar in availableResolutions)
            {
                var res = ar.Height * ar.Width;

                if(max < res)
                {
                    max = res;
                    selectedResolution = ar;
                }
            }
            return selectedResolution;
        }
    }
}
