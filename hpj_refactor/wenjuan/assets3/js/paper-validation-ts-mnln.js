




//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//辉瑞药店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	//验证是否有分销必填
	vaildeIsChecked();
	$("[name=q_3493]").change();
	$("[name=q_3494]").change();
	$("[name=q_3496]").change();
}

$(function(){
	
	//Q1验证
	$("[name=q_3493]").change(function(e){
		var result = $("input[name=q_3493]").parent("[class=checked]").html();
		//alert(result.indexOf("法斯通"));
		if(this.checked && result.indexOf("法斯通")>-1 ){
			//$("[name=q_3494]").attr("disabled",true);
			$("[name=q_3494]").parent("span").attr("readonly",true);
			$("[name=q_3494]").parent("span").removeClass();
			$("#3494_0_11675").parent("span").attr("class","checked");
			$("#3494_0_11675").prop("checked", true);
			
			$("#3495_0_11680").parent("span").attr("readonly",true);
			$("#3495_0_11680").attr("disabled",true);
		}else if(this.checked && result.indexOf("法斯通") == -1){
			//$("[name=q_3494]").attr("disabled",false);
			$("[name=q_3494]").parent("span").attr("readonly",false);
			$("#3494_0_11675").parent("span").removeClass();
			$("#3494_0_11675").prop("checked", false);
			
			$("#3495_0_11680").parent("span").attr("readonly",false);
			$("#3495_0_11680").attr("disabled",false);
		}
	});
	
	//Q2验证
	$("[name=q_3494]").change(function(e){
		
		var result = $("input[name=q_3494]").parent("[class=checked]").html();
		//alert(result);
		//alert(result.indexOf("法斯通"));
		if(this.checked && result.indexOf("法斯通")>-1 ){
			
			$("#3495_0_11680").parent("span").attr("readonly",true);
			$("#3495_0_11680").attr("disabled",true);
		}else if(this.checked && result.indexOf("法斯通") == -1){

			
			$("#3495_0_11680").parent("span").attr("readonly",false);
			$("#3495_0_11680").attr("disabled",false);
		}
	});
	
	//Q4验证
	$("[name=q_3496]").change(function(e){
		var result = $("input[name=q_3496]").parent("[class=checked]").html();
		if(this.checked && result.indexOf("科蕊")>-1 ){
			$("#3497_0_11685").parent("span").attr("class","checked");
			$("#3497_0_11685").prop("checked", true);
			
			$("#3497_0_11689").parent("span").removeClass();
			$("#3497_0_11689").parent("span").attr("readonly",true);
			$("#3497_0_11689").attr("disabled",true);
		}else if(this.checked && result.indexOf("科蕊") == -1){
			$("#3497_0_11685").parent("span").removeClass();
			$("#3497_0_11685").prop("checked", false);
			
			$("#3497_0_11689").parent("span").attr("readonly",false);
			$("#3497_0_11689").attr("disabled",false);
		}

	});
	
	
});

//验证是否有分销必选
function vaildeIsChecked(){
	$("[name=sq_a_4007_11746]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_4007_11746]:checked").val();
		var ids = $("[name=sq_a_4007_11746]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_3").parents("td").find("div:last"), "该题必选", true);
//			e.stopPropagation();
//		    e.preventDefault();	
			return;
		}
	});
}
