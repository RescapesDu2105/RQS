/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Classes;

import Beans.Film;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Philippe
 */
public class FilmTest {
    
    public FilmTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of setTaillePoster method, of class Film.
     */
    @Test
    public void testSetTaillePoster() {
        System.out.println("setTaillePoster");
        String Taille = Tailles_Posters.POSTER_SIZE_W154;
        Film instance = new Film();
        instance.setPosterPath("http://image.tmdb.org/t/p/w185/dflkgdjsfkg");
        instance.setTaillePoster(Taille);
        System.out.println("Path = " + instance.getPosterPath());
    }
}
