
//分销选择器
var SalesIds = ["1919","1932","1945","1958"];
//是否分销必填验证
var mandatoryIds = ["1920","1933","1946","1959"];



//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//辉瑞药店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	//跳题逻辑忽略验证
	var select_1997=$("[name=q_1997]:checked").attr("id");
	if(select_1997!='1997_0_1906') return; //忽略跳题
	$("[name$=_"+SalesIds[0]+"]").change(); //是否分销验证（只要触发任意一个即可）
	//$("[id$=_11350]").blur();//验证陈列面积
	vaildeSelect(mandatoryIds);
	vaildeSelect2();
	isNotEmpty("1930");
	isNotEmpty("1943");
	isNotEmpty("1956");
	isNotEmpty("1969");
}

$(function(){
	//分销初始化
	valideSales(SalesIds);
	//添加表格颜色背景色
	initaddClass();
	//是否有患教宣传
	$("[name$=_1971]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "是"){
			var result = $("[name=sq_a_"+arr[1]+"_1972]:checked").val();
			if(!result){
				Paper.setValidationResult($("#"+pref+"1972_4").parents("td").find("div:last"), "该题必选", true);
			}
			$("[name=sq_a_"+arr[1]+"_1972]").attr("disabled",false);
		}else if(this.checked && result == "否"){
			Paper.setValidationResult($("#"+pref+"1972_4").parents("td").find("div:last"), "", true);
			$("#"+pref+"1972_0,#"+pref+"1972_1,#"+pref+"1972_2,#"+pref+"1972_3,#"+pref+"1972_4").prop("checked",false);
			$("#"+pref+"1972_0,#"+pref+"1972_1,#"+pref+"1972_2,#"+pref+"1972_3,#"+pref+"1972_4").parent().removeClass("checked");
			$("#"+pref+"1973").attr("disabled",true);
			$("[name=sq_a_"+arr[1]+"_1972]").attr("disabled",true);
			Paper.setValidationResult($("#"+pref+"1973"), "", true);
			
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	//选择记录形式
	$("[name$=_1972]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "其他"){
			Paper.setValidationResult($("#"+pref+"1972_4").parents("td").find("div:last"), "", true);
			$("#"+pref+"1973").attr("disabled",false);
			Paper.setValidationResult($("#"+pref+"1973"), "该记录说明必填", true);
		}else if(this.checked && (result == "海报" || result == "展架" || result == "橱窗" || result == "宣传单页")) {
			Paper.setValidationResult($("#"+pref+"1972_4").parents("td").find("div:last"), "", true);
			$("#"+pref+"1973").attr("disabled",true).val("");
			Paper.setValidationResult($("#"+pref+"1973"), "", true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	
	for(var i = 0 ;i<mandatoryIds.length;i++){
		$("[id$=_"+mandatoryIds[i]+"]").change(function(e){
			var result = this.value;
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			if(result){
				Paper.setValidationResult($("#"+this.id+""),"",true);
			}else{
				Paper.setValidationResult($("#"+this.id+"请填写不可见说明"),"",true);
			}
			e.stopPropagation();
	        e.preventDefault();	
		});
	}
	
	//记录说明
	$("[id$=_1973]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(result){
			Paper.setValidationResult($("#"+this.id+""),"",true);
		}else{
			Paper.setValidationResult($("#"+this.id+"该记录说明必填"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	
	
});

//分销验证
function valideSales(SalesIds){
	
	for(var i = 0 ;i<SalesIds.length;i++){
		var result = $("[name$=_"+SalesIds[i]+"]:checked").val();
		$("[name$=_"+SalesIds[i]+"]").change(function(e){
			//alert(this.value);
			var result = this.value;
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			var parme = eval(arr[2]);
			if(this.checked && result == "有可见分销"){
				$("#"+pref+(parme+1)+"").attr("disabled",true).val("");
				$("#"+pref+(parme+2)+",#"+pref+(parme+3)+",#"+pref+(parme+4)+",#"+pref+(parme+5)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+8)+",#"+pref+(parme+9)+",#"+pref+(parme+10)+",#"+pref+(parme+11)+",#"+pref+(parme+12)+"").attr("disabled",false);
				//$("#"+pref+(parme+2)+"").val("");
				Paper.setValidationResult($("#"+pref+(parme+1)+""),"",true);
			}else if(this.checked && (result == "无售卖" || result == "有分销不可见")){
				$("#"+pref+(parme+2)+",#"+pref+(parme+3)+",#"+pref+(parme+4)+",#"+pref+(parme+5)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+8)+",#"+pref+(parme+9)+",#"+pref+(parme+10)+",#"+pref+(parme+11)+",#"+pref+(parme+12)+"").attr("disabled",true).val("");
				Paper.setValidationResult($("#"+pref+(parme+11)+""),"",true);
				if(result == "无售卖"){
					$("#"+pref+(parme+1)+"").attr("disabled",true).val("");
					Paper.setValidationResult($("#"+pref+(parme+1)+""),"",true);
				}else if (result == "有分销不可见"){
					$("#"+pref+(parme+1)+"").attr("disabled",false);
					var a  = $("#"+pref+(parme+1)+"").val();
					if(!a){
						Paper.setValidationResult($("#"+pref+(parme+1)+""),"请填写不可见说明",true);
					}
					
				}
				
				
			}
	        e.stopPropagation();
	        e.preventDefault();				
		});
	}
}



//验证选项是否必选
function vaildeSelect(mandatoryIds){
	for(var i = 0 ;i<mandatoryIds.length;i++){
		$("[id$=_"+mandatoryIds[i]+"]").each(function(e){
			var arr = this.id.split("_");
			var re = $("[name=sq_a_"+arr[1]+"_"+(eval(mandatoryIds[i])-1)+"]:checked").val();
			var ids = $("[name=sq_a_"+arr[1]+"_"+(eval(mandatoryIds[i])-1)+"]").attr("id");
			var arrIds = ids.split("_");
			if(!re){
				Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_1").parents("td").find("div:last"), "该题必选", true);
				return;
			}
			
		});
	}
	
}
//验证是否有患教宣传是否必选
function vaildeSelect2(){
	$("[id$=_1973]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_1971]:checked").val();
		var ids = $("[name=sq_a_"+arr[1]+"_1971]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_1").parents("td").find("div:last"), "该题必选", true);
			return;
		}
	});
}
//验证纵深是否必填
function isNotEmpty(endId){
	$("[id$=_"+endId+"]").each(function(e){
		var id = "";
		if(endId == "1930"){
			id = "1919";
		}else if(endId == "1943"){
			id = "1932";
		}else if(endId == "1956"){
			id = "1945";
		}else if(endId == "1969"){
			id = "1958";
		}
		var result = this.value;
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_"+id+"]:checked").val();
		//alert(re);
		if(re != "无售卖" && re != "有分销不可见"){
			if(!result){
				//alert(result);
				Paper.setValidationResult($("#"+this.id), "该题必选", true);
				return;
			}
		}
		
	});
	
}

function initaddClass(){
	addClass("2001","7","#3299CC");
		addClass("2001","8","#3299CC");
		addClass("2001","9","#3299CC");
		addClass("2001","10","#8FBC8F");
		addClass("2001","11","#8FBC8F");
		addClass("2001","12","#8FBC8F"); 
		addClass("2001","13","#C0D9D9");
		addClass("2001","14","#C0D9D9");
		addClass("2001","15","#C0D9D9");
		
		addClass("2002","7","#3299CC");
		addClass("2002","8","#3299CC");
		addClass("2002","9","#3299CC");
		addClass("2002","10","#8FBC8F");
		addClass("2002","11","#8FBC8F");
		addClass("2002","12","#8FBC8F"); 
		addClass("2002","13","#C0D9D9");
		addClass("2002","14","#C0D9D9");
		addClass("2002","15","#C0D9D9");
		
		addClass("2003","7","#3299CC");
		addClass("2003","8","#3299CC");
		addClass("2003","9","#3299CC");
		addClass("2003","10","#8FBC8F");
		addClass("2003","11","#8FBC8F");
		addClass("2003","12","#8FBC8F"); 
		addClass("2003","13","#C0D9D9");
		addClass("2003","14","#C0D9D9");
		addClass("2003","15","#C0D9D9");
		
		addClass("2004","7","#3299CC");
		addClass("2004","8","#3299CC");
		addClass("2004","9","#3299CC");
		addClass("2004","10","#8FBC8F");
		addClass("2004","11","#8FBC8F");
		addClass("2004","12","#8FBC8F"); 
		addClass("2004","13","#C0D9D9");
		addClass("2004","14","#C0D9D9");
		addClass("2004","15","#C0D9D9");
}
function addClass(tableId,tdNum,color){
   	$("#"+tableId).find(" table tr").each(function(index){
	    $(this).find(" td").each(function(index){
	    	//alert(index);
	        if(index == (eval(tdNum)-1)){
	        	//alert(index);
	            $(this).css("background-color",color);
	        }
	    });
	});
   
}

