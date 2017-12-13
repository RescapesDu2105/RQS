/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Classes;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.URL;

/**
 *
 * @author Philippe
 */
public class DBAccess
{
    //private URL url;
    private static final String USER_AGENT = "Mozilla/5.0";
    private HttpURLConnection connection;
    
    public DBAccess()
    {
        this.connection = null;        
    }
    
    
    private void SendRequest (String urlParameters) throws IOException
    {        
        connection.setRequestProperty("User-Agent", USER_AGENT);
        connection.setRequestProperty("Accept-Language", "en-US,en;q=0.5");
        
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        connection.setRequestProperty("Content-Length", Integer.toString(urlParameters.getBytes().length));
        connection.setRequestProperty("Content-Language", "en-US");  

        connection.setUseCaches(false);
        connection.setDoOutput(true);

        try (DataOutputStream wr = new DataOutputStream (connection.getOutputStream()))
        {
            wr.writeBytes(urlParameters);            
            wr.flush();
            wr.close();
        }
    }
    
    public void SendGETRequest()
    {
        
    }
    
    public void SendPOSTRequest(String url, String urlParameters) throws ProtocolException, IOException
    {        
        URL obj = new URL(url);        
        OpenConnection(obj);
        connection.setRequestMethod("POST");
        
        SendRequest(urlParameters);
    } 
    
    public String ReceiveResponse() throws IOException
    {
        int responseCode = connection.getResponseCode();
        
        StringBuilder response = null;
        
        if (responseCode == HttpURLConnection.HTTP_OK)
        {
            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) 
            {
                String inputLine;
                response = new StringBuilder();
                while ((inputLine = in.readLine()) != null)
                {
                    response.append(inputLine);
                }
            }
        }
        
        CloseConnection();

        return response != null ? response.toString() : null;
    }
    
    public void OpenConnection(URL obj) throws IOException
    {
        connection = (HttpURLConnection) obj.openConnection();
    }
    
    public void CloseConnection()
    {
        connection.disconnect();
    }
}
