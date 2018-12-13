using PrizeClaimScanner.UWP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Storage;
using Windows.UI.Popups;
using Xamarin.Forms;

[assembly: Dependency(typeof(FolderServices_UWP))]
namespace PrizeClaimScanner.UWP
{
    class FolderServices_UWP : IFolderService
    {
        protected string AssetsContentFolderLocation()
        {
            string root = Windows.ApplicationModel.Package.Current.InstalledLocation.Path;
            string path = root + @"\Assets\Content";
            return path;
        }

        public async Task CopyPDFToAssetsAsync(string filename)
        {
            StorageFolder assetsFolder = await StorageFolder.GetFolderFromPathAsync(AssetsContentFolderLocation());
            StorageFolder localFolder = ApplicationData.Current.LocalFolder;
            StorageFile pdfFile = await localFolder.GetFileAsync(filename);
            await pdfFile.MoveAsync(assetsFolder, filename, NameCollisionOption.ReplaceExisting);
            //await pdfFile.CopyAsync(assetsFolder, filename, NameCollisionOption.ReplaceExisting);
           
        }

        public async Task DeleteLocalFileAsync(string filename)
        {
            StorageFile pdfFile = await LoadFileFromLocalFolderAsync(filename, true);
            if (pdfFile != null)
            {
                await pdfFile.DeleteAsync();
            }
        }

        public async Task DeleteAssetsFileAsync(string filename)
        {
            StorageFile pdfFile = await LoadFileFromAssetsFolderAsync(filename);
            if (pdfFile != null)
            {
                await pdfFile.DeleteAsync();
            }
        }

        public async Task LaunchLocalFileAsync(string filename)
        {
            StorageFile pdfFile = await LoadFileFromAssetsFolderAsync(filename);
            if (pdfFile != null)
            {
                await Windows.System.Launcher.LaunchFileAsync(pdfFile);
            }
        }

        public async Task<StorageFile> LoadFileFromAssetsFolderAsync(string filename)
        {
            StorageFile pdfFile = null;
            StorageFolder assetsFolder = await StorageFolder.GetFolderFromPathAsync(AssetsContentFolderLocation());
            try
            {
                pdfFile = await assetsFolder.GetFileAsync(filename);
            }
            catch (Exception e)
            {
                var messageDialog = new MessageDialog(e.Message);
                await messageDialog.ShowAsync();
            }
            return pdfFile;
        }

        public async Task<StorageFile> LoadFileFromLocalFolderAsync(string filename, bool suppressErrorMsg = false)
        {
            StorageFile pdfFile = null;
            StorageFolder localFolder = ApplicationData.Current.LocalFolder;
            try
            {
                pdfFile = await localFolder.GetFileAsync(filename);
            }
            catch (Exception e)
            {
                if (!suppressErrorMsg)
                {
                    var messageDialog = new MessageDialog(e.Message);
                    await messageDialog.ShowAsync();
                }
            }
            return pdfFile;
        }

    }
}
