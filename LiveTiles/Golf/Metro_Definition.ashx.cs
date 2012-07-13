using System;
using System.Web;
using WickedWolfApps.Web.LiveTiles.Models;

namespace WickedWolfApps.Web.LiveTiles
{
	/// <summary>
	/// Summary description for Metro_Definition
	/// </summary>
	public class Metro_Definition : IHttpHandler
	{
		public void ProcessRequest(HttpContext context)
		{
			context.Response.ContentType = "text/xml";
			context.Response.Write(BuildXml(context));
		}

		public bool IsReusable
		{
			get
			{
				return false;
			}
		}

		/// <summary>
		/// Builds XML that will be returned by this handler
		/// </summary>
		/// <returns></returns>
		private string BuildXml(HttpContext context)
		{
			// The XML that we will return.
			// Note: The image URL is passing a time. Otherwise, WinRT thinks the image is the same and doesn't try to fetch a new one.
			string xml = @"<?xml version='1.0' encoding='utf-8' ?>
<tile>
	<visual version='1' branding='name'>
		<binding template='TileWidePeekImage04'>
			<image id='1' src='http://{0}/Golf/Metro_Wide_Front.ashx?Time={1}' alt='Wide Live Tile Image'/>
			<text id='1'>{2}</text>
		</binding>
		<binding template='TileSquarePeekImageAndText04'>
			<image id='1' src='http://{0}/Golf/Metro_Square_Front.ashx?Time={1}' alt='Square Live Tile Image'/>
			<text id='1'>{2}</text>
		</binding>
	</visual>
</tile>
";
			LiveTileData data = LiveTileData.GetLiveTileData("http://www.golf.com/rss.xml");
			return string.Format(xml, context.Request.Url.Authority, DateTime.Now,  data.Title);
		}
	}
}