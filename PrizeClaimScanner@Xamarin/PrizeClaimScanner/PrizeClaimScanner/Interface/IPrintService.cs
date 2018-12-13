using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace PrizeClaimScanner
{
    public interface IPrintService
    {
        void RegisterForPrinting();
        void UnregisterForPrinting();
        Task PrintAsync();
        Task PreparePrintContentAsync(string filename);
    }
}
