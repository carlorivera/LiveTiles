<%@ WebHandler Language="C#" Class="WickedWolfApps.Web.LiveTiles.MetroSquareLiveTileImageHandler" %>

using System;
using System.Collections.Specialized;
using System.Drawing;
using System.Web;
using Microsoft.Web;
using System.Net;
using System.Xml;
using System.IO;
using WickedWolfApps.Web.LiveTiles.Models;

namespace WickedWolfApps.Web.LiveTiles
{
	public class MetroSquareLiveTileImageHandler : ImageHandler
	{
		/// <summary>
		/// ctor
		/// </summary>
		public MetroSquareLiveTileImageHandler()
		{
			// Set caching settings and add image transformations here
			// EnableServerCache = true; // This breaks on GoDaddy
			// HttpContext.Current.Response.Cache.SetExpires(DateTime.Now.AddSeconds(30));
			// base.ClientCacheExpiration = TimeSpan.FromSeconds(30);
		}

		/// <summary>
		/// Generates the Image
		/// </summary>
		/// <param name="parameters"></param>
		/// <returns></returns>
		public override ImageInfo GenerateImage(NameValueCollection parameters)
		{
			Bitmap bit = new Bitmap(300, 300);
			Graphics gra = Graphics.FromImage(bit);

			try
			{
				// Get the LiveTile Data
				LiveTileData data = LiveTileData.GetLiveTileData("http://www.golf.com/rss.xml");

				// Download the Background Image
				WebClient webClient = new WebClient();
				byte[] imageData = webClient.DownloadData(data.ImageUrl);

				// Draw the background Image
				gra.DrawImage(Image.FromStream(new MemoryStream(imageData)), 0, 0, 300, 300);

				// Is Debug Mode?
				if (!string.IsNullOrEmpty(parameters["debug"]))
				{
					// Draw time for debug
					gra.DrawString(DateTime.Now.ToString(), new Font(FontFamily.GenericSansSerif, 8), Brushes.White, new Rectangle(40, 40, 130, 47));
				}

				// DrawOptionalStuff(gra);
				return new ImageInfo(bit);
			}
			catch
			{
				string logoPath = System.IO.Path.Combine(MetroSquareLiveTileImageHandler.MappedApplicationPath, @"images\portfolio\Icon.png");
				gra.DrawImage(Image.FromFile(logoPath, false), 3, 3, 40, 40);
				return new ImageInfo(bit);
			}
		}
		
		/// <summary>
		/// Optional Stuff - Just some examples of stuff i've played with
		/// </summary>
		/// <param name="gra"></param>
		private void DrawOptionalStuff(Graphics gra)
		{
			
			// Make the background NavyBlue
			gra.Clear(Color.FromArgb(16, 37, 63));

			// Draw the App Logo
			string logoPath = System.IO.Path.Combine(MetroSquareLiveTileImageHandler.MappedApplicationPath, @"images\portfolio\Icon100.png");
			gra.DrawImage(Image.FromFile(logoPath, false), 3, 3, 65, 65);

			// Draw the headline text
			gra.DrawString("GOLF.COM", new Font(FontFamily.GenericSansSerif, 28), Brushes.White, new Rectangle(80, 5, 220, 87));
		}

		public static string MappedApplicationPath
		{
			get
			{
				string APP_PATH = System.Web.HttpContext.Current.Request.ApplicationPath.ToLower();
				if (APP_PATH == "/")      //a site 
					APP_PATH = "/";
				else if (!APP_PATH.EndsWith(@"/")) //a virtual 
					APP_PATH += @"/";

				string it = System.Web.HttpContext.Current.Server.MapPath(APP_PATH);
				if (!it.EndsWith(@"\"))
					it += @"\";
				return it;
			}
		}
	}
}