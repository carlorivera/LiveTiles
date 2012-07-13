<%@ WebHandler Language="C#" Class="WickedWolfApps.Web.LiveTiles.MetroWideLiveTileImageHandler" %>

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
	public class MetroWideLiveTileImageHandler : ImageHandler
{
	private static string _rssURL = "http://www.drudgereportfeed.com/rss.xml";

	/// <summary>
	/// ctor
	/// </summary>
	public MetroWideLiveTileImageHandler()
	{
		// Set caching settings and add image transformations here
		// EnableServerCache = true; // This breaks on GoDaddy
		//		HttpContext.Current.Response.Cache.SetExpires(DateTime.Now.AddSeconds(30));
		//base.ClientCacheExpiration = TimeSpan.FromSeconds(30);
	}

	/// <summary>
	/// 
	/// </summary>
	/// <param name="parameters"></param>
	/// <returns></returns>
	public override ImageInfo GenerateImage(NameValueCollection parameters)
	{
		Bitmap bit = new Bitmap(620, 300);
		Graphics gra = Graphics.FromImage(bit);
		
		try
		{
			// Get the LiveTile Data
			LiveTileData data = LiveTileData.GetLiveTileData("http://www.golf.com/rss.xml");

			// Make the background NavyBlue
			gra.Clear(Color.FromArgb(16, 37, 63));

			// Download the Background Image
			WebClient webClient = new WebClient();
			byte[] imageData = webClient.DownloadData(data.ImageUrl);

			// Draw the background Image
			gra.DrawImage(Image.FromStream(new MemoryStream(imageData)), 0, 0, 620, 300);

			if (!string.IsNullOrEmpty(parameters["debug"]))
			{
				// Draw time for debug
				gra.DrawString(DateTime.Now.ToString(), new Font(FontFamily.GenericSansSerif, 8), Brushes.White, new Rectangle(40, 40, 130, 47));
			}
			return new ImageInfo(bit);
		}
		catch
		{
			string logoPath = System.IO.Path.Combine(MappedApplicationPath, @"images\portfolio\Icon.png");
			gra.DrawImage(Image.FromFile(logoPath, false), 3, 3, 40, 40);
			return new ImageInfo(bit);
		}
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