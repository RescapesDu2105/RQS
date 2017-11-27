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