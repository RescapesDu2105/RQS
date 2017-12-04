document.addEventListener("DOMContentLoaded", function() {
    document.querySelector('select[name="populariteSelect"]').onchange=FctPopularite; }, false);

document.addEventListener("DOMContentLoaded", function() { 
    document.querySelector('select[name="perenniteSelect"]').onchange=FctPerennite; }, false);

function FctPopularite(event)
{
    console.log(event.target.value);
    switch(event.target.value)
    {
        case "Default" :                        
            var divPopularite = document.getElementById("divPopularite");
            divPopularite.parentElement.removeChild(divPopularite);

            break;
        default:
            if(!document.getElementById("divPopularite"))
            {
                var col = document.createElement("div");
                col.setAttribute("class", "col");
                col.setAttribute("id", "divPopularite");

                var label = document.createElement("label");
                label.setAttribute("for", "PopInput");
                label.innerText = "Valeur";

                var input = document.createElement("input");
                input.setAttribute("type", "text");
                input.setAttribute("name", "PopInput");
                input.setAttribute("id", "PopInput");
                input.setAttribute("class", "form-control");
                input.style.width = "75px";
                
                col.appendChild(label);
                col.appendChild(input);
                var divPopSel = document.getElementById('divPopSel');
                divPopSel.parentElement.insertBefore(col, document.getElementById('divPerSel'));
            }                        
            break;
    }
}

function FctPerennite(event)
{
    switch(event.target.value)
    {
        case "Default" :
            var divPerennite = document.getElementById("divPerennite");
            divPerennite.parentElement.removeChild(divPerennite);

            break;
        default:
            if(!document.getElementById("divPerennite"))
            {
                var col = document.createElement("div");
                col.setAttribute("class", "col");
                col.setAttribute("id", "divPerennite");

                var label = document.createElement("label");
                label.setAttribute("for", "PerInput");
                label.innerText = "Valeur";

                var input = document.createElement("input");
                input.setAttribute("type", "text");
                input.setAttribute("name", "PerInput");
                input.setAttribute("id", "PerInput");
                input.setAttribute("class", "form-control");
                input.style.width = "75px";
                
                col.appendChild(label);
                col.appendChild(input);

                var divPopSel = document.getElementById('divPopSel');
                divPopSel.parentElement.appendChild(col);
            }
            break;
    }
}

function InscriptionAddInfos(CheckBox)
{
    if(CheckBox.checked)
    {                                        
        var inputNom = document.createElement("input");                   
        inputNom.type = "text";
        inputNom.id = "inputNom";
        inputNom.name = "inputNom";
        inputNom.setAttribute('class', "form-control");
        inputNom.placeholder = "Entrer le nom de famille";

        var inputPrenom = document.createElement("input");                   
        inputPrenom.type = "text";
        inputPrenom.id = "inputPrenom";
        inputPrenom.name = "inputPrenom";
        inputPrenom.setAttribute('class', "form-control");
        inputPrenom.placeholder = "Entrer le prénom";


        var div1 = document.createElement("div");
        div1.setAttribute('class', "form-group");
        div1.id = "div_inputNom";

        var div2 = document.createElement("div");
        div2.setAttribute('class', "form-group");
        div2.id = "div_inputPrenom";

        var labelNom = document.createElement("label");
        labelNom.for = "name";
        labelNom.innerHTML = "Nom de famille";

        var labelPrenom = document.createElement("label");
        labelPrenom.for = "surname";
        labelPrenom.innerHTML = "Prénom";

        div1.appendChild(labelNom);
        div1.appendChild(inputNom);

        div2.appendChild(labelPrenom);
        div2.appendChild(inputPrenom);

        document.getElementById("loginform").append(div1);
        document.getElementById("loginform").append(div2);
    }
    else
    {
        document.getElementById("loginform").removeChild(document.getElementById("div_inputNom"));
        document.getElementById("loginform").removeChild(document.getElementById("div_inputPrenom"));
    }
}