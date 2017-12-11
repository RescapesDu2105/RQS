var tr = document.getElementsByClassName("tr");
var td = document.getElementsByClassName("text-center isOk");
var i;

console.log(tr.length);
for(i = 0 ; i < tr.length ; i++)
{         
    if(td[i].innerHTML == "0") 
    {
        tr[i].style.backgroundColor = "rgba(255, 0, 0, 0.3)"; 
    }
    else 
    {
        tr[i].style.backgroundColor = "rgba(0, 255, 0, 0.3)"; 
    }   
};