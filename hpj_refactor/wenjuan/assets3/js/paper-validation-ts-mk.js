
//分销选择器
var SalesIds = ["11349"];
//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//泰森鸡肉店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	var select_3455=$("[name=q_3455]:checked").attr("id");
	if(select_3455!='3455_0_11331') return; //忽略跳题
	$("[name$=_"+SalesIds[0]+"]").change(); //是否分销验证（只要触发任意一个即可）
	valideclms("11350");
	validehjzc("11351");
	validecpbf("11352");
	vaildeSelect("11350");
	$("[id$=_11351]").change();
	$("[id$=_11352]").change();
	vaildeisNo();
}
   
$(function(){
	//分销初始化
	valideSales(SalesIds);
	valideclms("11350");
	validehjzc("11351");
	validecpbf("11352");
	vaildeisNo();  
	
	
});

//分销验证
function valideSales(SalesIds){
	for(var i = 0 ;i<SalesIds.length;i++){
		$("[name$=_"+SalesIds[i]+"]").change(function(e){
			//alert(this.value);
			var result = this.value;
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			if(this.checked && result == "有分销"){
				var clms = $("#"+pref+"11350").val();
				var isNo = $("[name=sq_a_"+arr[1]+"_11353]:checked").val();
				if(isNo == "否"){
					$("#"+pref+"11350,#"+pref+"11351,#"+pref+"11352,#"+pref+"11353_0,#"+pref+"11353_1").attr("disabled",false);
				}
				
				Paper.setValidationResult($("#"+pref+"11350"),"");
				Paper.setValidationResult($("#"+pref+"11349_4").parents("td").find("div:last"), "", true);
				//alert($("[name$=_"+arr[1]+"_11353]").checked);
				if(!$("[name$=_"+arr[1]+"_11353]:checked").val()){
					
					Paper.setValidationResult($("#"+pref+"11353_1").parents("td").find("div:last"), "必须选择产品是否在专柜陈列", true);
				}
				
				$("[name=sq_a_"+arr[1]+"_11353]").change(function(e){
					var  isNo = this.value;
					Paper.setValidationResult($("#"+pref+"11353_1").parents("td").find("div:last"), "", true);
					//Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"11349_4").parents("td").find("div:last"), "", true);
					if(this.checked && isNo == "是"){
						Paper.setValidationResult($("#"+pref+"11351"),"");
						Paper.setValidationResult($("#"+pref+"11352"),"");
						$("#"+pref+"11351,#"+pref+"11352").attr("disabled",true);
						$("#"+pref+"11351,#"+pref+"11352").val("");
					}else if(this.checked && isNo == "否"){
						var hjzc = $("#"+pref+"11351").val();
						var cpbf = $("#"+pref+"11352").val();
						$("#"+pref+"11351,#"+pref+"11352").attr("disabled",false);
						if(!hjzc || eval(hjzc)==0){
							Paper.setValidationResult($("#"+pref+"11351"),"货架总层数必须大于0");
						}
						if(!cpbf || eval(cpbf)==0){
							Paper.setValidationResult($("#"+pref+"11352"),"产品摆放在第几层必须大于0");
						}
						
					}
				});
				if(!clms || eval(clms) == 0){
					
					Paper.setValidationResult($("#"+pref+"11350"),"陈列面数必须大于0");
					
				}
			}else if(this.checked && (result == "无分销" || result == "缺货" || result == "空盒" || result == "药盒背面暴露")){
				$("#"+pref+"11353_0").prop("checked",false);
				$("#"+pref+"11353_1").prop("checked",false);
				$("#"+pref+"11353_0").parent().removeClass("checked");
				$("#"+pref+"11353_1").parent().removeClass("checked");
				Paper.setValidationResult($("#"+pref+"11350"),"",true);
				Paper.setValidationResult($("#"+pref+"11351"),"",true);
				Paper.setValidationResult($("#"+pref+"11352"),"",true);
				Paper.setValidationResult($("#"+pref+"11349_4").parents("td").find("div:last"), "", true);
				Paper.setValidationResult($("#"+pref+"11353_1").parents("td").find("div:last"), "", true);
				$("#"+pref+"11350,#"+pref+"11351,#"+pref+"11352").val("");
				$("#"+pref+"11353_1").prop("checked",true);
				$("#"+pref+"11353_1").parent().addClass("checked");
				$("#"+pref+"11350,#"+pref+"11351,#"+pref+"11352,#"+pref+"11353_0,#"+pref+"11353_1").attr("disabled",true);
			}
	        e.stopPropagation();
	        e.preventDefault();				
		});
	}
}
//验证陈列面数
function valideclms(clms){
	$("[id$=_"+clms+"]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var val = $("[name$=_"+arr[1]+"_11349]:checked").val();
		if(!result || eval(result) == 0){
			if(val == "有分销"){
				Paper.setValidationResult($("#3457_"+arr[1]+"_11350"),"陈列面数必须大于0");
			}
		}else{
			if(!val){
				Paper.setValidationResult($("#3457_"+arr[1]+"_11350"),"请选择是否有分销");
			}
		}
		 e.stopPropagation();
	     e.preventDefault();		
	});
}
//验证货架总层数
function validehjzc(hjzc){
	$("[id$=_"+hjzc+"]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		if(eval(result)>12){
			Paper.setValidationResult($("#3457_"+arr[1]+"_11351"),"货架总层数最大值为12");
		}else if(eval(result)<=0){
			Paper.setValidationResult($("#3457_"+arr[1]+"_11351"),"货架总层数必须大于0");
		}else{
			Paper.setValidationResult($("#3457_"+arr[1]+"_11351"),"");
		}
		var cpbf =$("#3457_"+arr[1]+"_11352").val();
		if(cpbf){
			var arrList = cpbf.split(",");
			for(var i = 0;i<arrList.len;i++){
				Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"产品摆放第几层数值不能大于货架总层数");
			}
		}
		 e.stopPropagation();
	     e.preventDefault();		
	});
	
}
//验证产品摆放第几层
function validecpbf(cpbf){
	$("[id$=_"+cpbf+"]").change(function(e){
		
		var result = this.value;
		var arr = this.id.split("_");
		if(eval(result)<=0){
			Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"产品摆放在第几层必须大于0");
		}else{
			Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"");
		}
		
		var hjzc=$("#3457_"+arr[1]+"_11351").val();
		if(hjzc){
			var arrList = result.split(",");
			var bool = true;
			for(var j = 0;j<arrList.length;j++){
				for(var k = j+1;k<arrList.length;k++){
					if(arrList[j] == arrList[k]){
						Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"产品摆放第几层数值不能重复");
						bool = false;
						break;
					}
				}
				if(!bool) break;
			}
			if(bool){
				for(var i = 0;i<arrList.length;i++){
					if(!/^-?\d+$/.test(arrList[i])){ 
						Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"产品摆放第几层一定要为数值");
					}else if(eval(hjzc)<eval(arrList[i])){
						
						Paper.setValidationResult($("#3457_"+arr[1]+"_11352"),"产品摆放第几层数值不能大于货架总层数");
					}
				}
			}
			
			
		}else{
			if($("[name=sq_a_"+arr[1]+"_11349]:checked").val()=="有分销"){
				if($("[name=sq_a_"+arr[1]+"_11353]:checked").val()=="否"){
					Paper.setValidationResult($("#3457_"+arr[1]+"_11351"),"货架总层数必须大于0");
				}
				
			}
			
		}
		 e.stopPropagation();
	     e.preventDefault();		
	});
	
}
function vaildeSelect(SalesId){
	$("[id$=_"+SalesId+"]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_11349]:checked").val();
		var ids = $("[name=sq_a_"+arr[1]+"_11349]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_4").parents("td").find("div:last"), "必须选择是否有分销", true);
			return;
		}
		
	});
	
}
//产品是否在专柜陈列
function vaildeisNo(){
	$("[name$=_11353]").change(function(e){
		var  isNo = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		Paper.setValidationResult($("#"+pref+"11353_1").parents("td").find("div:last"), "", true);
		if(this.checked && isNo == "是"){
			Paper.setValidationResult($("#"+pref+"11351"),"");
			Paper.setValidationResult($("#"+pref+"11352"),"");
			$("#"+pref+"11351,#"+pref+"11352").attr("disabled",true);
			$("#"+pref+"11351,#"+pref+"11352").val("");
		}else if(this.checked && isNo == "否"){
			var hjzc = $("#"+pref+"11351").val();
			var cpbf = $("#"+pref+"11352").val();
			$("#"+pref+"11351,#"+pref+"11352").attr("disabled",false);
			if(!hjzc || eval(hjzc)==0){
				Paper.setValidationResult($("#"+pref+"11351"),"货架总层数必须大于0111");
			}
			if(!cpbf || eval(cpbf)==0){
				Paper.setValidationResult($("#"+pref+"11352"),"产品摆放在第几层必须大于0");
			}
			
		}
		 e.stopPropagation();
	     e.preventDefault();
	});
}

