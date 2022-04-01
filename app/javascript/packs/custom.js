import $ from 'jquery'
import {} from 'jquery-ujs'

$(document).ready(function(){
  window.mychange = function mychange(a,b){
    document.getElementById("price").innerHTML = a + " vnd";
    if(b>0)
      document.getElementById("status").innerHTML =
      document.getElementById("div_stock").innerHTML;
    else
      document.getElementById("status").innerHTML =
      document.getElementById("div_outstock").innerHTML;
    return false;
  }
});
