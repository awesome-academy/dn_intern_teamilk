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
  $(document).on("click", ".update-quantity .plus", function(e) {
    let parent_obj = $(this).parents(".update-quantity");
    let input = parent_obj.find("input.quantity");
    let current_quantity = input.val();
    let product_quantity = input.data("quantity");

    if (product_quantity > current_quantity) {
      current_quantity ++;
      input.val(current_quantity);
      input.change();
    }
  });

  $(document).on("click", ".update-quantity .minus", function(e) {
    let parent_obj = $(this).parents(".update-quantity");
    let input = parent_obj.find("input.quantity");
    let current_quantity = input.val();

    if (current_quantity > 1) {
      current_quantity--;
      input.val(current_quantity);
      input.change();
    }
  });

  $(document).on("change", ".update-quantity input.quantity", function(e) {
    let product_detail_id = $(this).data("id");
    let quantity = $(this).val();
    let product_quantity = $(this).data("quantity");
    if (product_quantity < quantity) {
      alert("exceed the amount");
      $(this).val(1)
      quantity = 1
    }
    $.ajax({
      method: "PUT",
      url: "/cart",
      data: {product_detail_id: product_detail_id, quantity: quantity},
      dataType: 'script'
    });

  });
});
