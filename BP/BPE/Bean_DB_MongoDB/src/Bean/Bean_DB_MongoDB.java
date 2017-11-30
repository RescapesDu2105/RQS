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
import com.mongodb.client.model.PushOptions;
import com.mongodb.client.model.Updates;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 *
 * @author Philippe
 */
public class Bean_DB_MongoDB implements Serializable
{
    private static final String LOCALHOST = "localhost";
    private static final String MOVIES = "movies";
    private static final String ACTORS = "actors";
    private final MongoClient mongoClient;
    private final MongoDatabase mongoDatabase;
    private final MongoCollection <Document> collection;

    public Bean_DB_MongoDB()
    {
        this.mongoClient = new MongoClient(LOCALHOST);
        this.mongoDatabase = this.mongoClient.getDatabase(ACTORS);
        this.collection = this.mongoDatabase.getCollection(ACTORS);
    }

    public void VerifierActeur(String json)
    {
        FindIterable<Document> Iterator;
        Iterator = collection.find(eq(json));
        Document doc = Iterator.first();

        if (doc == null)
        {
            try
            {
                doc = Document.parse(json);
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
        System.out.println("ChercherActeur Req recu : "+IdActeur);
        System.out.println("Res ChercheAct : "+collection.find(eq("_idAct", IdActeur)).first());

        return collection.find(eq("_id", IdActeur)).first() != null;
    }

    public Document getActeur(int IdActeur)
    {
        return collection.find(eq("_id", IdActeur)).first();
    }

    public void InsererActeur(Document DocActeur)
    {        
        collection.insertOne(DocActeur);
    }
    
    public Document ChercherFilmDansFilmographieActeur(int IdActeur, int IdFilm)
    {               
        return collection.find(and(eq("_id", IdActeur), eq("films._id", IdFilm))).first();
    }
    
    public void InsererFilmDansFilmographie(int IdActeur, Document DocFilm)
    {        
        ArrayList<Document> Documents = new ArrayList<>();
        Documents.add(DocFilm);
        PushOptions Sort = new PushOptions();
        collection.updateOne(eq("_id", IdActeur), Updates.pushEach("films", Documents, Sort.sort(1)));
    }  

    public void RemoveFilm(int IdActeur, int IdFilm) 
    {
        Document DocCount = collection.aggregate(Arrays.asList(
                new Document("$match", new Document("_id", IdActeur)),
                new Document("$project", new Document(new Document("_id", 0).append("count", new Document("$size", "$films"))))
        )).first();
        
        int count = DocCount.getInteger("count");
        System.out.println("count = " + count);
        
        if(count > 1)
        {
            collection.updateOne(eq("_id", IdActeur), Updates.pullByFilter(eq("films._id", IdFilm)));
        }
        else
        {
            collection.deleteOne(eq("_id", IdActeur));
        }
    }
    
    public FindIterable<Document> FilmographieActeur(int IdActeur)
    {
        FindIterable<Document> docs = collection
                .find(eq("actors._id", IdActeur))
                .projection(fields(include("title"), include("release_date"), include("actors.$"), include("original_title"), include("poster_path"), excludeId()));

        return docs;
    }

    public static void main(String[] args)
    {
        Logger mongoLogger = Logger.getLogger("org.mongodb.driver");
        mongoLogger.setLevel(Level.SEVERE);
        MongoClient mongoClient = new MongoClient("localhost");
        MongoDatabase db = mongoClient.getDatabase("actors");
        MongoCollection <Document> collection = db.getCollection("actors");
        System.out.printf("Size of movies collection is %d\n", collection.count());

        FindIterable<Document> test;
        test = collection.find(eq("_id", 4));
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

    public MongoCollection<Document> getCollection() {
        return collection;
    }  
}
