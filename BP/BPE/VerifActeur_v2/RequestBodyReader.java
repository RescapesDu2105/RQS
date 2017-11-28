package Classes;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

abstract public class RequestBodyReader
{
    public static String getBody(HttpServletRequest request, HttpServletResponse response) throws IOException 
    {
        InputStream is = request.getInputStream();
        String body = null;

        response.setContentType("text/html;charset=UTF-8");
        try 
        {
           if (is != null) 
           {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[32767];
                int read = 0;
                while ((read = is.read(buffer, 0, buffer.length)) != -1) {
                        baos.write(buffer, 0, read);
                }		
                baos.flush();		
                body = new String(baos.toByteArray());
           }
           else
           {
               System.err.println("Impossible de récupérer le flux de la requête");
               return null;
           }
       } 
       catch (IOException ex) 
       { 
           System.err.println("Erreur lors de la lecture : " + ex);
       } 
       finally 
       {
           if (is != null) 
           {
               try 
               {
                   is.close();
               } 
               catch (IOException ex)
               {
                    System.err.println("Erreur lors de la fermeture du flux : " + ex);
               }
           }
        }

        return body;
    }
}
