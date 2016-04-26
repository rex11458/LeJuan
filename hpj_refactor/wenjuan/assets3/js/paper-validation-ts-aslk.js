
//分销选择器
var SalesIds = ["1985"];



//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//辉瑞药店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	//跳题逻辑忽略验证
	var select_2008=$("[name=q_2008]:checked").attr("id");
	if(select_2008!='2008_0_1977') return; //忽略跳题
	$("[name$=_"+SalesIds[0]+"]").change(); //是否分销验证（只要触发任意一个即可）
	vaildeIsChecked();
	$("[name$=_1988]").change();//货架类型验证触发
	$("[name$=_1989]").change();//前柜位置验证触发
	$("[name$=_1990]").change();//背柜,开架,端架验证触发
	vaildeIsCheckedNew();
}

$(function(){
	//分销初始化
	valideSales(SalesIds);
	
	//货架类型验证
	$("[name$=_1988]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "卧柜（前柜）"){
			var re = $("[name=sq_a_"+arr[1]+"_1989]:checked").val();
			if(!re){
				Paper.setValidationResult($("#"+pref+"1989_2").parents("td").find("div:last"), "该题必选", true);
			}
			Paper.setValidationResult($("#"+pref+"1990_2").parents("td").find("div:last"), "", true);
			Paper.setValidationResult($("#"+pref+"1991"), "", true);
			Paper.setValidationResult($("#"+pref+"1992"), "", true);
			
			$("#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2").prop("checked",false);
			$("#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2").parent().removeClass("checked");
			$("[name=sq_a_"+arr[1]+"_1990]").attr("disabled",true);
			$("#"+pref+"1991,#"+pref+"1992").attr("disabled",true).val("");
			$("[name=sq_a_"+arr[1]+"_1989]").attr("disabled",false);
		}else if(this.checked && (result == "背柜" || result == "开式货架" || result == "端架" || result == "其他")){
			Paper.setValidationResult($("#"+pref+"1989_2").parents("td").find("div:last"), "", true);
			var re = $("[name=sq_a_"+arr[1]+"_1990]:checked").val();
			if(!re){
				Paper.setValidationResult($("#"+pref+"1990_2").parents("td").find("div:last"), "该题必选", true);
			}
			if(!$("#"+pref+"1991").val()){
				Paper.setValidationResult($("#"+pref+"1991"), "该题必填", true);
			}
			if(!$("#"+pref+"1992").val()){
				Paper.setValidationResult($("#"+pref+"1992"), "该题必填", true);
			}
		
			
			$("#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2").prop("checked",false);
			$("#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2").parent().removeClass("checked");
			$("[name=sq_a_"+arr[1]+"_1989]").attr("disabled",true);
			
			$("[name=sq_a_"+arr[1]+"_1990]").attr("disabled",false);
			$("#"+pref+"1991,#"+pref+"1992").attr("disabled",false);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	
	
	
	//前柜位置验证
	$("[name$=_1989]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "其他"){
			Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			var a  = $("#"+pref+"1994").val();
			if(!a){
				Paper.setValidationResult($("#"+pref+"1994"), "该题必填", true);
			}
		}else if(this.checked && (result == "第一层" || result == "第二层")){
			Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			Paper.setValidationResult($("#"+pref+"1994"), "", true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	//背柜,开架,端架验证
	$("[name$=_1990]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "其他"){
			Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			var a  = $("#"+pref+"1994").val();
			if(!a){
				Paper.setValidationResult($("#"+pref+"1994"), "该题必填", true);
			}
			
		}else if(this.checked && (result == "1.35m-1.7m之间" || result == "1.00m-1.35m之间")){
			Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			Paper.setValidationResult($("#"+pref+"1994"), "", true);
			
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	//验证产品摆放第几层验证
	$("[id$=_1992]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		var reSum = $("#"+pref+"1991").val();
		if(eval(result)>eval(reSum)){
			Paper.setValidationResult($("#"+this.id+""), "该值不能大于货架总层数", true);
		}else{
			Paper.setValidationResult($("#"+this.id+""), "", true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	//货架总层数验证
	$("[id$=_1991]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		var reSum = $("#"+pref+"1992").val();
		if(eval(result)<=0){
			Paper.setValidationResult($("#"+this.id+""), "该值必须大于0", true);
		}else if(eval(result)<eval(reSum)){
			Paper.setValidationResult($("#"+this.id+""), "该值必须大于等于产品摆放第几次", true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	//最低零售价验证
	$("[id$=_1986]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_1985]:checked").val();
		if(re=="有分销" || re == "隐藏分销" || re == "空盒"){
			if(eval(result)>0){
				Paper.setValidationResult($("#"+this.id+""),"",true);
				if(result.indexOf(".")==-1){
					this.value = result+".00";
				}
			}else{
				Paper.setValidationResult($("#"+this.id+""),"最低零售价必填且不能等于0",true);
			}
		}
		e.stopPropagation();
        e.preventDefault();	
	});
});

//分销验证
function valideSales(SalesIds){
	for(var i = 0 ;i<SalesIds.length;i++){
		$("[name$=_"+SalesIds[i]+"]").change(function(e){
			//alert(this.value);
			var result = this.value;
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			var parme = eval(arr[2]);
			if(this.checked && result == "有分销"){
				var price =  $("#"+pref+"1986").val();
				var clms = $("#"+pref+"1987").val();
				var hjlx = $("[name=sq_a_"+arr[1]+"_1988]:checked").val();
				if(!hjlx){
					Paper.setValidationResult($("[name=sq_a_"+arr[1]+"_1988]").parents("td").find("div:last"), "该题必选", true);
				}
				if(!price){
					Paper.setValidationResult($("#"+pref+(parme+1)+""),"最低零售价必填且不能等于0");
				}
				if(!clms){
					Paper.setValidationResult($("#"+pref+(parme+2)+""),"该题必填");
				}
				$("#"+pref+(parme+1)+",#"+pref+(parme+2)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+9)+"").attr("disabled",false);
				$("[name=sq_a_"+arr[1]+"_1988],[name=sq_a_"+arr[1]+"_1989],[name=sq_a_"+arr[1]+"_1990],[name=sq_a_"+arr[1]+"_1993]").attr("disabled",false);
				Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			}else if(this.checked && result == "无分销"){
				Paper.setValidationResult($("[name=sq_a_"+arr[1]+"_1988]").parents("td").find("div:last"), "", true);
				
				Paper.setValidationResult($("#"+pref+(parme+1)+""),"",true);
				Paper.setValidationResult($("#"+pref+(parme+2)+""),"",true);
				$("#"+pref+(parme+1)+",#"+pref+(parme+2)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+9)+"").attr("disabled",true).val("");
				$("#"+pref+"1988_0,#"+pref+"1988_1,#"+pref+"1988_2,#"+pref+"1988_3,#"+pref+"1988_4,#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2,#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2,#"+pref+"1993_0,#"+pref+"1993_1").prop("checked",false);
				$("#"+pref+"1988_0,#"+pref+"1988_1,#"+pref+"1988_2,#"+pref+"1988_3,#"+pref+"1988_4,#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2,#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2,#"+pref+"1993_0,#"+pref+"1993_1").parent().removeClass("checked");
				$("[name=sq_a_"+arr[1]+"_1988],[name=sq_a_"+arr[1]+"_1989],[name=sq_a_"+arr[1]+"_1990],[name=sq_a_"+arr[1]+"_1993]").attr("disabled",true);
				Paper.setValidationResult($("#"+pref+"1994"),"",true);
				Paper.setValidationResult($("#"+pref+"1991"),"",true);
				Paper.setValidationResult($("#"+pref+"1992"),"",true);
				Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			}else if(this.checked && (result == "隐藏分销" || result == "空盒")){
				Paper.setValidationResult($("[name=sq_a_"+arr[1]+"_1988]").parents("td").find("div:last"), "", true);
				var price =  $("#"+pref+(parme+1)+"").val();
				//alert(price);
				if(!price){
					Paper.setValidationResult($("#"+pref+(parme+1)+""),"最低零售价必填且不能等于0");
				}
				//Paper.setValidationResult($("#"+pref+(parme+1)+""),"",true);
				Paper.setValidationResult($("#"+pref+(parme+2)+""),"",true);
				$("#"+pref+(parme+2)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+9)+"").attr("disabled",true).val("");
				$("#"+pref+"1988_0,#"+pref+"1988_1,#"+pref+"1988_2,#"+pref+"1988_3,#"+pref+"1988_4,#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2,#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2,#"+pref+"1993_0,#"+pref+"1993_1").prop("checked",false);
				$("#"+pref+"1988_0,#"+pref+"1988_1,#"+pref+"1988_2,#"+pref+"1988_3,#"+pref+"1988_4,#"+pref+"1989_0,#"+pref+"1989_1,#"+pref+"1989_2,#"+pref+"1990_0,#"+pref+"1990_1,#"+pref+"1990_2,#"+pref+"1993_0,#"+pref+"1993_1").parent().removeClass("checked");
				//Paper.setValidationResult($("#"+pref+(parme+1)+""),"最低零售价必填");
				$("[name=sq_a_"+arr[1]+"_1988],[name=sq_a_"+arr[1]+"_1989],[name=sq_a_"+arr[1]+"_1990],[name=sq_a_"+arr[1]+"_1993]").attr("disabled",true);
				Paper.setValidationResult($("#"+pref+"1994"),"",true);
				Paper.setValidationResult($("#"+pref+"1991"),"",true);
				Paper.setValidationResult($("#"+pref+"1992"),"",true);
				//$("#"+pref+(parme+1)+"").attr("disabled",false).val("");
				Paper.setValidationResult($("#"+this.id+"").parents("td").find("div:last"), "", true);
			}
	        e.stopPropagation();
	        e.preventDefault();				
		});
	}
}
function vaildeIsChecked(){
	$("[id$=_1986]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_1985]:checked").val();
		var ids = $("[name=sq_a_"+arr[1]+"_1985]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_3").parents("td").find("div:last"), "该题必选", true);
//			e.stopPropagation();
//		    e.preventDefault();	
			return;
		}
	});
}

function vaildeIsCheckedNew(){
	$("[id$=_1994]").each(function(e){
		var arr = this.id.split("_");
		var rea = $("[name=sq_a_"+arr[1]+"_1985]:checked").val();
		if(rea !="无分销" && rea !="隐藏分销" && rea !="空盒"){
			var re = $("[name=sq_a_"+arr[1]+"_1993]:checked").val();
			var ids = $("[name=sq_a_"+arr[1]+"_1993]").attr("id");
			var arrIds = ids.split("_");
			if(!re){
				Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_1").parents("td").find("div:last"), "该题必选", true);
//				e.stopPropagation();
//			    e.preventDefault();	
				return;
			}
		}
		
	});
}
