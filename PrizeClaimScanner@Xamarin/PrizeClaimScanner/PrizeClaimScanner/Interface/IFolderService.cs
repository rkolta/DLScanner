using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace PrizeClaimScanner
{
    public interface IFolderService
    {
        Task CopyPDFToAssetsAsync(string filename);
        Task DeleteLocalFileAsync(string filename);
        Task DeleteAssetsFileAsync(string filename);
        Task LaunchLocalFileAsync(string filename);
    }
}
