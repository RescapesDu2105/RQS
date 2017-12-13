/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Classes.Commande;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author Philippe
 */
public class Panier implements Serializable
{    
    private final ArrayList<Commande> Panier;

    public Panier()
    {
        this.Panier = new ArrayList<>();
    }
    

    public int getNumberOfArticles()
    {
        return Panier.size();
    }
    
    public ArrayList<Commande> getPanier()
    {
        return Panier;
    }
}
