$(function(){

  	$("div.radio").on("click",function(){
  		var $e = $(this), 
  			$r = $e.find(":radio");
  		
		if($r.attr("disabled")) return;
		
		if($r.is(":checked")){

			$r.prop("checked", false);
			$r.parent().removeClass("checked");
			$r.change();
			
		} else {
		
			$e.parents(".list-group,table").find("input:radio[name='"+$r.attr("name")+"']:checked").each(function(){
				$(this).prop("checked", false);
				$(this).parent().removeClass("checked");
			});
			
			$r.prop("checked", true);
			$r.parent().addClass("checked");
			$r.change();
		}
	});
  	
  	$("div.checkbox").on("click",function(){
  		var $e = $(this), 
  			$s = $e.find("span"),
  			$c = $e.find(":checkbox"), 
  			isChecked = $c.is(":checked");

  		if($c.attr("disabled")) return;  
  		
  		$c.prop("checked", !isChecked);
  		isChecked ? $s.removeClass("checked") : $s.addClass("checked");
  		$c.change();
	});  	
  	
});