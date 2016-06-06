package app.ta;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import twitter4j.HashtagEntity;
import twitter4j.MediaEntity;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.RateLimitStatus;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.URLEntity;

public class TwitterGrab {

	// Some predefined parameters
	static private String[] m_dateInterval = { "2014-11-7", "2014-11-8",
			"2014-11-9", "2014-11-10", "2014-11-11", "2014-11-12",
			"2014-11-13", "2014-11-14" };
	static private String[] m_keyword = { "#microsoft", "#google",
			"#apple", "#cometlanding", "#michigan" };

	public static WordFilter m_filter;

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		//System.out.println("Add search constraints as: 2014-11-7|2014-11-8 #apple|#google");
		m_filter = new WordFilter("filter.txt");
	
		if(args.length == 2)
		{
			m_dateInterval=args[0].split("\\|");
			m_keyword = args[1].split("\\|");
		}
		
		Twitter twitter = new TwitterFactory().getInstance();
		//Vector<SearchResult> resList = new Vector<SearchResult>();
		int size = m_dateInterval.length;
		for (String keyword : m_keyword) {
			for (int i = 0; i < size - 1; ++i) {
				SearchResult res = new SearchResult(m_dateInterval[i],
						m_dateInterval[i + 1], keyword, twitter);
				//resList.add(res);
				boolean searchRes = res.RunSearch(0);
				if (searchRes == true) {
					System.out.println("The search Finished");
				} else
					System.out.println("The search Failed");
			}
		}

	}

}

class SearchResult {
	private String m_dateBegin;
	private String m_dateEnd;
	private String m_keyword;
	private Twitter m_twitter;

	private List<Status> m_tweets = new Vector<Status>();

	public SearchResult(String dateBegin, String dateEnd, String keyword,
			Twitter twitter) {
		m_dateBegin = dateBegin.trim();
		m_dateEnd = dateEnd.trim();
		m_keyword = keyword.trim();
		m_twitter = twitter;
		
	}

	public boolean RunSearch(int maxRecords) { // if maxRecords is 0, then we
												// save all search results
		try {

			System.out.println("Run search for: " + Summary());

			QueryResult result;
			Query query = GetQuery();
			int remain = 0;
			int resetSeconds = 0;
			int waitSec = 0;
			RateLimitStatus limit = null;
			int searchCounts = 0;
			do {
				if (remain == 0) {
					// Wait until recovered
					limit = GetRemainSearchCounts();
					remain = limit.getRemaining();
					resetSeconds = limit.getSecondsUntilReset();
					while (remain == 0) {
						System.out.println("Wait recovery");
						WaitSeconds(resetSeconds + 5); // Sleep a little bit
														// longer 5 seconds than
														// required
						limit = GetRemainSearchCounts();
						remain = limit.getRemaining();
						resetSeconds = limit.getSecondsUntilReset();
					}
					waitSec = GetAverageWait(limit);
				}
				result = Search(query); // Here we search
				++searchCounts;
				--remain;
				List<Status> resTweets = result.getTweets();
				m_tweets.addAll(resTweets);
				System.out.println("Finished " + searchCounts + " searches."
						+ " remain search " + remain + " Gotten records:"
						+ resTweets.size() + " Total records:"
						+ m_tweets.size());

				if (maxRecords > 0 && m_tweets.size() >= maxRecords) {
					if (maxRecords < m_tweets.size()) {
						List<Status> subTweets = new Vector<Status>(
								m_tweets.subList(0, maxRecords));
						m_tweets = subTweets;
					}
					break;
				}

				// adjust waiting times after a few query, to speed up query
				if (searchCounts > 0 && searchCounts % 7 == 0 && remain > 0) {
					limit = GetRemainSearchCounts();
					remain = limit.getRemaining();
					waitSec = GetAverageWait(limit);
				}

				WaitSeconds(waitSec);
			} while ((query = result.nextQuery()) != null);

			SaveToCSVFile();

		} catch (TwitterException te) {
			te.printStackTrace();
			System.out.println("Failed to search tweets: " + te.getMessage());
			System.out.println("Summary:");
			System.out.println("\t" + Summary());
			return false;
		}
		return true;
	}

	private void SaveToCSVFile() {
		String filename = generateFileName();
		try {
			System.out.println("Begin to save file:" + filename);
			PrintWriter out = new PrintWriter(new BufferedWriter(
					new FileWriter(filename, true)));
			out.println(TweetRecord.GetTitle());
			int filter = 0;
			for (Status st : m_tweets) {
				TweetRecord r = new TweetRecord();
				if (r.ParseTweet(st, TwitterGrab.m_filter))
					out.println(r.toString());
				else
					++filter;
			}
			out.flush();
			out.close();
			System.out.println("Finish to save file:" + filename
					+ ";  removed records:" + filter);
		} catch (IOException e) {
			// exception handling left as an exercise for the reader
		}
	}

	private String generateFileName() {
		String filename = m_keyword + "@" + m_dateBegin + "@" + m_tweets.size()
				+ ".csv";
		return filename;
	}

	private QueryResult Search(Query query) throws TwitterException {
		System.out.println("Begin search from Server");
		QueryResult result = m_twitter.search(query);
		System.out.println("Finish search from Server");
		return result;
	}

	private int GetAverageWait(RateLimitStatus limit) {
		double avgWait = (double) limit.getSecondsUntilReset()
				/ (double) limit.getRemaining();
		int waitSeconds = (int) avgWait + 1;
		return waitSeconds;
	}

	private void WaitSeconds(int seconds) {
		try {
			System.out.println("Wait " + seconds + " seconds");
			for (int i = 1; i <= seconds; ++i) {
				TimeUnit.SECONDS.sleep(1);
				if (i % 5 == 0) {
					System.out.print("=");
				}
				if (i % 60 == 0) {
					System.out.println(i + "/" + seconds);
				}
			}
			System.out.println("Finished waiting :)");
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Failed to sleep");
		}
	}

	private RateLimitStatus GetRemainSearchCounts() throws TwitterException {
		System.out.println("Begin to get rate limit status from server");
		Map<String, RateLimitStatus> statusList = m_twitter
				.getRateLimitStatus("search");
		System.out.println("Finish to get rate limit status from server");
		RateLimitStatus status = statusList.get("/search/tweets");
		System.out.println(" Limit: " + status.getLimit());
		System.out.println(" Remaining: " + status.getRemaining());
		System.out.println(" ResetTimeInSeconds: "
				+ status.getResetTimeInSeconds());
		System.out.println(" SecondsUntilReset: "
				+ status.getSecondsUntilReset());
		return status;
	}

	private Query GetQuery() {
		Query query;
		query = new Query(m_keyword + " -filter:retweets");
		query.setLang("en");
		query.setCount(100);
		query.setSince(this.m_dateBegin);
		query.setUntil(this.m_dateEnd);
		return query;
	}

	private String Summary() {
		String str = "Keyword:" + m_keyword + ";Date begin:" + m_dateBegin
				+ ";Date end:" + m_dateEnd + ";Tweets size:" + m_tweets.size();
		return str;
	}

}

class WordFilter {
	public String m_reg = "";

	public WordFilter(String filepath) {
		ReadFile(filepath);
	}

	private void ReadFile(String filepath) {
		try {
			Path path = Paths.get(filepath);
			List<String> strArray = Files.readAllLines(path);
			StringBuffer buf = new StringBuffer();
			for (String s : strArray) {
				s = s.replaceAll("\\s+", "\\\\s*");
				if (buf.length() == 0)
					buf.append("(.*)\\b(" + s);
				else
					buf.append("|" + s);
			}
			buf.append(")\\b(.*)");
			m_reg = buf.toString();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Can not load filter file "+filepath);
		}
	}
}

class TweetRecord {
	public String m_id;
	public String m_date;
	public String m_idate;
	public String m_user;
	public String m_text;
	public String m_hashTag;
	public String m_photo;
	public String m_url;

	public static String GetTitle() {
		return "id,date,idate,user,text,hashtag,photo,url";
	}

	public TweetRecord() {

	}

	public boolean ParseTweet(Status rec, WordFilter filter) {
		m_id = Long.toString(rec.getId());
		Date date = rec.getCreatedAt();
		m_date = date.toString();
		m_idate = Long.toString(date.getTime());
		m_user = rec.getUser().getScreenName();
		m_text = rec.getText();
		String lowText = m_text.toLowerCase();
		lowText = FilterSpecialCharacter(lowText);
		if (lowText.matches(filter.m_reg)) {
			System.out.println("filter: " + m_text);
			return false;
		}

		m_hashTag = "";
		for (HashtagEntity t : rec.getHashtagEntities()) {
			String str = t.getText().replace('|', ' ');
			if (m_hashTag.length() == 0)
				m_hashTag += str;
			else
				m_hashTag += "|" + str;
		}

		m_photo = "";
		for (MediaEntity mediaEntity : rec.getMediaEntities()) {
			String mtype = mediaEntity.getType();
			if (mtype.compareToIgnoreCase("photo") == 0) {
				if (m_photo.length() == 0)
					m_photo += mediaEntity.getMediaURL();
				else
					m_photo += "|" + mediaEntity.getMediaURL();
			}
		}

		m_url = "";
		for (URLEntity ue : rec.getURLEntities()) {
			if (m_url.length() == 0)
				m_url += ue.getURL();
			else
				m_url += "|" + ue.getURL();
		}
		return true;
	}

	public List<String> getCollectionElement() {
		Vector<String> v = new Vector<String>();
		v.add(m_id);
		v.add(m_date);
		v.add(m_idate);
		v.add(m_user);
		v.add(m_text);
		v.add(m_hashTag);
		v.add(m_photo);
		v.add(m_url);
		return v;
	}

	public String toString() {
		return m_id + "," + m_date + "," + m_idate + ","
				+ FilterSpecialCharacter(m_user) + ","
				+ FilterSpecialCharacter(m_text) + ","
				+ FilterSpecialCharacter(m_hashTag) + "," + m_photo + ","
				+ m_url;
	}

	public static String FilterSpecialCharacter(String str) {
		str = str.replaceAll("(,|\"|'|\\r\\n|\\n|\\r)+", " ");
		str = removeUrl(str);
		return str;
	}

	private static String removeUrl(String commentstr) {
		return commentstr.replaceAll("https?://\\S+\\s?", "");
	}

}
