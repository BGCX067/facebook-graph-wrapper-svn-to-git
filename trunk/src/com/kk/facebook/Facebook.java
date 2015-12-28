package com.kk.facebook;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import org.antlr.runtime.ANTLRInputStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.RecognitionException;

import com.kk.facebook.webClient.FacebookGraphLexer;
import com.kk.facebook.webClient.FacebookGraphParser;

/**
 * Provides Facebook interface to fetch data from the server.
 * 
 */
public class Facebook
{
    private FacebookObject fetchData(URL url)
    {
        FacebookObject pVal = null;

        try
        {
            ANTLRInputStream in = new ANTLRInputStream(url.openStream());
            FacebookGraphLexer lexer = new FacebookGraphLexer(in);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            FacebookGraphParser parser = new FacebookGraphParser(tokens);

            pVal = parser.start();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        catch (RecognitionException e)
        {
            e.printStackTrace();
        }

        return pVal;
    }

    public void checkIns(String accessToken)
    {
        FacebookObject val = null;
        try
        {
            URL u = new URL("https://graph.facebook.com/koushikghosh");
            val = fetchData(u);

            System.out.println(val);
        }
        catch (MalformedURLException e)
        {
            e.printStackTrace();
        }
    }

    public static void main(String[] args)
    {
        String accessToken = "";
        new Facebook().checkIns(accessToken);
    }
}
