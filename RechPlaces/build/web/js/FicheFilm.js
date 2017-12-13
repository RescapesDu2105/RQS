/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
window.addEventListener('load', Init, false);

function Init()
{
    document.getElementById("button").addEventListener('click', function() {
        location.href = "RechPlaces.jsp";
    }, false);
}

/*
                    <table class="table table-hover table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th scope="col" class="text-center">Jour</th>
                                <th scope="col" class="text-center">Salle</th>
                                <th scope="col" class="text-center">Heure</th>
                                <th scope="col" class="text-center">Places restantes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center">Lundi</td>
                                <td class="text-center">Salle 2</td>
                                <td class="text-center">16:30</td>
                                <td class="text-center">54</td>
                            </tr>
                            <tr>
                                <td class="text-center"></td>
                                <td class="text-center">Salle 2</td>
                                <td class="text-center">19:30</td>
                                <td class="text-center">54</td>
                            </tr>
                            <tr>
                                <td class="text-center">Mardi</td>
                                <td class="text-center">Salle 2</td>
                                <td class="text-center">16:30</td>
                                <td class="text-center">54</td>
                            </tr>
                            <tr>
                                <td class="text-center">Mercredi</td>
                                <td class="text-center">Salle 2</td>
                                <td class="text-center">16:30</td>
                                <td class="text-center">54</td>
                            </tr>
                            <tr>
                                <td class="text-center">Vendredi</td>
                                <td class="text-center">Salle 2</td>
                                <td class="text-center">16:30</td>
                                <td class="text-center">54</td>
                          </tr>
                        </tbody>
                    </table>
 */

