package Bean;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.mongodb.BasicDBObject;
import java.io.Serializable;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.bson.Document;
import static com.mongodb.client.model.Filters.*;
import com.mongodb.client.model.Projections;
import static com.mongodb.client.model.Projections.*;
import com.mongodb.util.JSON;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

/**
 *
 * @author Philippe
 */
public class Bean_DB_MongoDB implements Serializable 
{    
    private static final String LOCALHOST = "localhost";
    private static final String MOVIES = "movies";
    //private static final String DATABASE_ACTORS = "actors";    
    private final MongoClient mongoClient;
    private final MongoDatabase mongoDatabase;

    public Bean_DB_MongoDB()
    {
        this.mongoClient = new MongoClient(LOCALHOST);
        this.mongoDatabase = this.mongoClient.getDatabase(MOVIES);        
    }      
    
    public void VerifierActeur(String json)
    {        
        MongoCollection <Document> collection = getMongoDatabase().getCollection(MOVIES);
        FindIterable<Document> Iterator;
        Iterator = collection.find(eq(json));
        Document doc = Iterator.first();
        
        if (doc == null)
        {
<<<<<<< HEAD
            doc = Document.parse(json);
            
            try
            {                 
                doc = Document.parse(json);    
=======
            try
            {                 
                doc = Document.parse(json);  
>>>>>>> 5c8d724dca222c71df63878aebd79936dd95581e
                collection.insertOne(doc);
            }
            catch(Exception ex)
            {
                Logger.getLogger(Bean_DB_MongoDB.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
    
    public boolean ChercherActeur(int IdActeur)
    {        
        MongoCollection <Document> collection = getMongoDatabase().getCollection(MOVIES);
        System.out.println("ChercherActeur Req recu : "+IdActeur);
        System.out.println("Res ChercheAct : "+collection.find(eq("_idAct", IdActeur)).first());
        
        return collection.find(eq("_idAct", IdActeur)).first() != null;        
    }
        
    public Document getActeur(int IdActeur)
    {        
        MongoCollection <Document> collection = getMongoDatabase().getCollection(MOVIES);        
        return collection.find(eq("_idAct", IdActeur)).first();
    }
    
    
    public FindIterable<Document> FilmographieActeur(int IdActeur)
    {
        MongoCollection <Document> collection = getMongoDatabase().getCollection(MOVIES);
        FindIterable<Document> docs = collection
                .find(eq("actors.id", IdActeur))
                .projection(fields(include("title"), include("release_date"), include("actors.$"), include("original_title"), include("poster_path"), excludeId()));
       // System.out.println("docs = " + docs.first());
        //System.out.println("doc = " + doc);
        
        /*String character = collection
                .find(eq("actors.id", IdActeur))
                .projection(fields(include("title"), include("release_date"), include("actors.$"), excludeId()))
                .first()
                .get("actors", ArrayList.class).get(0).toString().split("character=")[1].split(",", 0)[0];
        System.out.println(character);*/
        
        return docs;
    }
    
    public static void main(String[] args) 
    {        
        Logger mongoLogger = Logger.getLogger("org.mongodb.driver");
        mongoLogger.setLevel(Level.SEVERE);
        MongoClient mongoClient = new MongoClient("localhost");
        MongoDatabase db = mongoClient.getDatabase("movies");
        MongoCollection <Document> collection = db.getCollection("movies");
        System.out.printf("Size of movies collection is %d\n", collection.count());
        
        FindIterable<Document> test;
        test = collection.find(eq("actors.id", 5999));
        System.out.println("test = " + test.first());
        Document doc;
        doc = test.first();
        displayDocument(doc);
    }
    
    public static void displayDocument(Document doc) 
    {
        doc.keySet().stream().forEach(key -> {
            Object value = doc.get(key);
            System.out.printf("KEY: %s, TYPE: %s, VALUE: %s\n",
            key,
            value != null ? value.getClass().getName() : "N/A",
            value != null ? value.toString() : "null");
        });
    } 

    public MongoClient getMongoClient() {
        return mongoClient;
    }

    public MongoDatabase getMongoDatabase() {
        return mongoDatabase;
    }
}
