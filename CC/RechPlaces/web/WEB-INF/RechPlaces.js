window.addEventListener('load', Init, false);

function Init()
{
    document.getElementById('populariteSelect').addEventListener("selectionchange", function(event) { FctPopularite(event) }, false);
    document.getElementById('perenniteSelect').addEventListener("selectionchange", function(event) { FctPerennite(event) }, false);
}

function FctPopularite(event)
{
    console.log(event);
    switch(event)
    {
        case "Par défaut" :
            /*<div class="col">   
                <label for="PopInput">Valeur</label>
                <input type="text" name="PopInput" id="PopInput" class="form-control" style="width: 75px;" hidden>
            </div>*/
            var col = document.createElement("div");
            col.setAttribute("class", "col");
            col.setAttribute("id", "divPopularite");

            var label = document.createElement("label");
            label.setAttribute("for", "PopInput");

            var input = document.createElement("input");
            input.setAttribute("type", "text");
            input.setAttribute("name", "PopInput");
            input.setAttribute("id", "PopInput");
            input.setAttribute("class", "form-control");
            input.style.width = "75px";
            
            col.appendChild(label);
            col.appendChild(input);
            break;
        default:
            var divPopularite = document.getElementById("divPopularite");
            divPopularite.parentElement.removeChild(divPopularite);
            break;
    }
}

function FctPerennite(event)
{
    switch(event)
    {
        case "Par défaut" :
            /*<div class="col">   
                <label for="PopInput">Valeur</label>
                <input type="text" name="PopInput" id="PopInput" class="form-control" style="width: 75px;" hidden>
            </div>*/
            var col = document.createElement("div");
            col.setAttribute("class", "col");
            col.setAttribute("id", "divPerennite");

            var label = document.createElement("label");
            label.setAttribute("for", "PerInput");

            var input = document.createElement("input");
            input.setAttribute("type", "text");
            input.setAttribute("name", "PerInput");
            input.setAttribute("id", "PerInput");
            input.setAttribute("class", "form-control");
            input.style.width = "75px";
            
            col.appendChild(label);
            col.appendChild(input);
            break;
        default:
            var divPerennite = document.getElementById("divPerennite");
            divPerennite.parentElement.removeChild(divPerennite);
            break;
    }
}