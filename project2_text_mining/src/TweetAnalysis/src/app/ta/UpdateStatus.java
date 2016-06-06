package app.ta;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import twitter4j.MediaEntity;
import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.RateLimitStatus;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;

public class UpdateStatus {

	public static void getLimit(Twitter twitter) throws TwitterException{
		Map<String ,RateLimitStatus> rateLimitStatus = twitter.getRateLimitStatus();
        for (String endpoint : rateLimitStatus.keySet()) {
            RateLimitStatus status = rateLimitStatus.get(endpoint);
            System.out.println("Endpoint: " + endpoint);
            System.out.println(" Limit: " + status.getLimit());
            System.out.println(" Remaining: " + status.getRemaining());
            System.out.println(" ResetTimeInSeconds: " + status.getResetTimeInSeconds());
            System.out.println(" SecondsUntilReset: " + status.getSecondsUntilReset());
        }
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Twitter twitter = new TwitterFactory().getInstance();
		int count = 0;
		int queryTimes = 0;
		try {
            Query query = new Query("#apple -filter:retweets");
            query.setLang("en");
            query.setCount(100);
            query.setSince("2014-11-5");
            query.setUntil("2014-11-6");
           
            //query.setResultType(Query.POPULAR);
            
            QueryResult result;
            List<Status> tweets = new Vector<Status>();
            do {
                result = twitter.search(query);
                List<Status> resTweets = result.getTweets();
                tweets.addAll(resTweets);               
                ++queryTimes;
                if(queryTimes>=10)
                	break;
            } while ((query = result.nextQuery()) != null);
            
            for (Status tweet : tweets) {
            	++count;
            	Date date = tweet.getCreatedAt();
                System.out.println("["+ count +"]"+date.toString()+":"+ Long.toString(tweet.getId()) +"@" + tweet.getUser().getScreenName() + " - " + tweet.getText());   
                
                for (MediaEntity mediaEntity : tweet.getMediaEntities()) {
                    System.out.println("\t"+mediaEntity.getType() + ": " + mediaEntity.getMediaURL());
                }
                
            }
            
            //getLimit(twitter);
            
            Map<String, RateLimitStatus> statusList = twitter.getRateLimitStatus();
            RateLimitStatus status = statusList.get("/application/rate_limit_status");
            System.out.println(" Limit: " + status.getLimit());
            System.out.println(" Remaining: " + status.getRemaining());
            System.out.println(" ResetTimeInSeconds: " + status.getResetTimeInSeconds());
            System.out.println(" SecondsUntilReset: " + status.getSecondsUntilReset());
            status = statusList.get("/search/tweets");
            System.out.println(" Limit: " + status.getLimit());
            System.out.println(" Remaining: " + status.getRemaining());
            System.out.println(" ResetTimeInSeconds: " + status.getResetTimeInSeconds());
            System.out.println(" SecondsUntilReset: " + status.getSecondsUntilReset());            
            System.exit(0);
        } catch (TwitterException te) {
            te.printStackTrace();
            System.out.println("Failed to search tweets: " + te.getMessage());
            System.exit(-1);
        }
	}

}
