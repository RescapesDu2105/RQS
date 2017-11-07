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
import static com.mongodb.client.model.Projections.*;

/**
 *
 * @author Philippe
 */
public class Bean_DB_MongoDB implements Serializable 
{    
    private static final String LOCALHOST = "localhost";
    private static final String DATABASE_MOVIES = "movies";
    private static final String DATABASE_ACTORS = "actors";    
    private final MongoClient mongoClient;
    private final MongoDatabase mongoDatabase;

    public Bean_DB_MongoDB()
    {
        this.mongoClient = new MongoClient(LOCALHOST);
        this.mongoDatabase = this.mongoClient.getDatabase(DATABASE_ACTORS);        
    }      
    
    public void VerifierActeur(String json)
    {
        System.out.println("J'affiche quelque chose = " + json);
        
        MongoCollection <Document> collection = getMongoDatabase().getCollection(DATABASE_ACTORS);
        FindIterable<Document> Iterator;
        Iterator = collection.find(eq(json));
        System.out.println("Test 1 = " + Iterator.first());
        Document doc = Iterator.first();
        if (doc == null)
        {
            doc = Document.parse(json);
            System.out.println("Test 2");     
            collection.insertOne(doc);
            System.out.println("Test 3");
        }
        
        Iterator = collection.find(eq(json));
        System.out.println("Test 4 = " + Iterator.first());
    }
    
    public Document ChercherActeur(int IdActeur)
    {        
        MongoCollection <Document> collection = getMongoDatabase().getCollection(DATABASE_ACTORS);
        FindIterable<Document> Iterator;
        Iterator = collection.find(eq("_idAct", IdActeur));
        System.out.println("ChercherActeur = " + Iterator.first());
        Document doc = Iterator.first();
        
        return doc;
    }
    
    public void FilmographieActeur(int IdActeur)
    {
        
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
        test = collection.find(eq("_id", 100));
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
