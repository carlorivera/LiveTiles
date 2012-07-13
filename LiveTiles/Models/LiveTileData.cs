using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.ServiceModel.Syndication;

namespace WickedWolfApps.Web.LiveTiles.Models
{
	public class LiveTileData
	{
		/// <summary>
		/// A link to an Image
		/// </summary>
		public string ImageUrl { get; set; }

		/// <summary>
		/// The Title of the feed item
		/// </summary>
		public string Title { get; set; }

		/// <summary>
		/// Gets the Live Tile Data
		/// </summary>
		/// <returns></returns>
		public static LiveTileData GetLiveTileData(string rssURL)
		{
			// Download Feed
			XmlReader reader = XmlReader.Create(rssURL);
			SyndicationFeed feed = SyndicationFeed.Load(reader);

			return GetFirstItemWithImage(feed);
		}

		/// <summary>
		/// Returns a LiveTileData Object for the first item that has an image
		/// </summary>
		/// <param name="feed"></param>
		/// <returns></returns>
		private static LiveTileData GetFirstItemWithImage(SyndicationFeed feed)
		{
			string imageUrl = string.Empty;
			LiveTileData data = new LiveTileData();
			foreach (var feeditem in feed.Items)
			{
				imageUrl = GetImageUrl(feeditem.Summary.Text);

				if (!string.IsNullOrEmpty(imageUrl))
				{
					data.ImageUrl = imageUrl;
					data.Title = feeditem.Title.Text;
					break;
				}
			}
			return data;
		}

		/// <summary>
		/// Get ImageUrlFromContent
		/// </summary>
		/// <param name="description"></param>
		/// <returns></returns>
		private static string GetImageUrl(string description)
		{
			string imageURL = string.Empty;
			try
			{
				imageURL = System.Text.RegularExpressions.Regex.Match(description, "<img.*src=\"([^\"]*)").Groups[1].Captures[0].Value.ToString();

				// TODO: You might want to add extra checks here :)
				if (imageURL.Contains("doubleclick"))
				{
					imageURL = string.Empty;
				}
			}
			catch
			{
				// Eat the error
			}
			return imageURL;
		}
	}
}