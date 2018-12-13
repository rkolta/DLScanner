using iText.Forms;
using iText.Forms.Fields;
using iText.Kernel.Pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace PrizeClaimScanner.Service.PDF
{
    public abstract class PdfBaseService
    {
        public Stream OpenTemplatePdfStream(string filename)
        {
            var assembly = typeof(App).GetTypeInfo().Assembly;
            //"PrizeClaimScanner.Resources.claimform.pdf"
            return assembly.GetManifestResourceStream(filename);
        }

        public abstract void CreateAnnotatedPdf(string inputFilename, string outputFilename);
    }
}
