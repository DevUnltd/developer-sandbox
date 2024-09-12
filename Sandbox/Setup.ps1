function Send-Notification {
   $ErrorActionPreference = "Stop"
   $notificationTitle = $args[0]
   [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
   $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)
   $toastXml = [xml] $template.GetXml()
   $toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null
   $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
   $xml.LoadXml($toastXml.OuterXml)
   $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
   $toast.ExpirationTime = [DateTimeOffset]::Now.AddSeconds(5)
   $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Build Manager")
   $notifier.Show($toast);
}

$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

Set-ExecutionPolicy unrestricted -Force

Send-Notification "Install Chocolatey"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Send-Notification "Install Powershell"
choco install pwsh -y

Send-Notification "Install VSCode"
Start-Process cmd "/c choco install vscode -y"

Send-Notification "Install Chome"
Start-Process cmd "/c choco install googlechrome -y"

Send-Notification "Install NodeJS"
choco install nodejs -y

Send-Notification "Install Git"
choco install git -y

[Wallpaper]::SetWallpaper("C:\Users\WDAGUtilityAccount\Desktop\Sandbox\wallpaper.jpg")
set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value "C:\Users\WDAGUtilityAccount\Desktop\Sandbox\wallpaper.jpg"