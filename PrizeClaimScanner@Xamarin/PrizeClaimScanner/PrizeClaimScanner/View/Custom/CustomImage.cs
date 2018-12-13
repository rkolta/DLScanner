using Xamarin.Forms;

namespace PrizeClaimScanner
{
    public class CustomImage : Image
    {
        public static readonly BindableProperty SourceFileNameProperty = BindableProperty.Create("SourceFileName", typeof(string), typeof(CustomImage), default(string));

        public string SourceFileName
        {
            get { return (string)GetValue(SourceFileNameProperty); }
            set { SetValue(SourceFileNameProperty, value); }
        }
    }
}
