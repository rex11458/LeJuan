
//促销活动选择器
var SalesIds = ["5085","5086","5087","5088","5089"];
//编号选择器
var productCodeSelector = "[id$=_5106],[id$=_5108],[id$=_5110],[id$=_5112],[id$=_5114]";

//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//泰森鸡肉店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	
	$("[id$=_5090],[id$=_5091]").change(); //日期验证
	$("[id$=_5082]").change();//本品是否分销
	$("[id$=_5085]").change();//折价
	$("[id$=_5094]").change();//竞品是否售卖
	$("[id$=_"+SalesIds[0]+"]").change(); //促销活动验证（只要触发任意一个即可）

	//验证本品竞品编号是否存在
	$(productCodeSelector).change();
}

$(function(){

	
	//日期开始结束匹对
	var vSelector = {
		5090: "5091",
		5091: "5090"
	};
	
	//最早生产日期验证
	$("[id$=_5090]").change(function(e){
		//if(this.id == "1638_2973_5090")
		//	alert("custome");
		var $e = $(this), val = $e.val();
		if(val){
			var cd = Paper.getOption("cd");
			var arr = this.id.split("_");
			var valEnd = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[arr[2]]).val();
			if(valEnd && val > valEnd){
				Paper.setValidationResult($e, "不能大于最晚生产日期");
			} else if(val > cd){
				Paper.setValidationResult($e, "不能大于当前日期");
			}
		}

        e.stopPropagation();
        e.preventDefault();		
	});
	
	//最晚生产日期验证
	$("[id$=_5091]").change(function(e){
		var $e = $(this), val = $e.val();
		if(val){
			var cd = Paper.getOption("cd");
			var arr = this.id.split("_");
			var valStart = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[arr[2]]).val();
			if(valStart && val < valStart){
				Paper.setValidationResult($e, "不能小于最早生产日期");
			} else if(val > cd){
				Paper.setValidationResult($e, "不能大于当前日期");
			}
		} 
		
        e.stopPropagation();
        e.preventDefault();		
	});
	
	//促销活动验证初始化
	valideSales(SalesIds);
	
	//是否分销验证
	$("[id$=_5082]").change(function(e){
		var $e = $(this), val = $e.val(), errorMsg = "";
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1];
		$(beforeId+"_5083").removeAttr("readonly");
		$(beforeId+"_5084").removeAttr("readonly");
		$(beforeId+"_5085").removeAttr("readonly");
		$(beforeId+"_5086").removeAttr("readonly");
		$(beforeId+"_5087").removeAttr("readonly");
		$(beforeId+"_5088").removeAttr("readonly");
		$(beforeId+"_5089").removeAttr("readonly");
		$(beforeId+"_5090").removeAttr("readonly");
		$(beforeId+"_5091").removeAttr("readonly");
		$(beforeId+"_5092").removeAttr("readonly");
		$(beforeId+"_5093").removeAttr("readonly");
		if(val == "") {
			Paper.setValidationResult($(beforeId+"_5083"), "");
			$(beforeId+"_5084").length == 1 && Paper.setValidationResult($(beforeId+"_5084"), "");
			Paper.setValidationResult($(beforeId+"_5085"), "");
			Paper.setValidationResult($(beforeId+"_5086"), "");
			Paper.setValidationResult($(beforeId+"_5087"), "");
			Paper.setValidationResult($(beforeId+"_5088"), "");
			Paper.setValidationResult($(beforeId+"_5089"), "");
			Paper.setValidationResult($(beforeId+"_5090"), "");
			Paper.setValidationResult($(beforeId+"_5091"), "");
			Paper.setValidationResult($(beforeId+"_5092"), "");
			Paper.setValidationResult($(beforeId+"_5093"), "");
		}
		else if(val == "0"){
			/**
			if($(beforeId+"_5083").val() =="" || $(beforeId+"_5083").val()==0){//陈列面数
				errorMsg="陈列面数必须等于0";
				Paper.setValidationResult($(beforeId+"_5083"), errorMsg);
			}
			if($(beforeId+"_5092").val() =="" || $(beforeId+"_5092").val()==0){//原价
				errorMsg="原价必须等于0";
				Paper.setValidationResult($(beforeId+"_5092"), errorMsg);
			}
			if($(beforeId+"_5093").val() =="" || $(beforeId+"_5093").val()==0){//最低价
				errorMsg="最低价必须等于0";
				Paper.setValidationResult($(beforeId+"_5093"), errorMsg);
			}*/
			//陈列面数
			$(beforeId+"_5083").attr("readonly","readonly").val(0);
			//面积
			$(beforeId+"_5084").attr("readonly","readonly").val(0);
			//折价
			$(beforeId+"_5085").attr("readonly","readonly").val(0);
			//加量
			$(beforeId+"_5086").attr("readonly","readonly").val(0);
			//买赠
			$(beforeId+"_5087").attr("readonly","readonly").val(0);
			//捆绑
			$(beforeId+"_5088").attr("readonly","readonly").val(0);
			//其他
			$(beforeId+"_5089").attr("readonly","readonly").val(0);
			//最早生产日期
			$(beforeId+"_5090").attr("readonly","readonly").val('1900-01-01');
			//最晚生产日期
			$(beforeId+"_5091").attr("readonly","readonly").val('1900-01-01');
			//原价
			$(beforeId+"_5092").attr("readonly","readonly").val(0);
			//最低价
			$(beforeId+"_5093").attr("readonly","readonly").val(0);
			
			//价签是否有黄牌
			$(beforeId+"_11771_0").prop("checked",false);
			$(beforeId+"_11771_1").prop("checked",false);
			$(beforeId+"_11771_0").parent().removeClass("checked");
			$(beforeId+"_11771_1").parent().removeClass("checked");
			$(beforeId+"_11771_0").attr("disabled",true);
			$(beforeId+"_11771_1").attr("disabled",true);
		}else if(val == "1"){
			$(beforeId+"_11771_0").prop("checked",true);
			$(beforeId+"_11771_1").prop("checked",true);
			$(beforeId+"_11771_0").attr("disabled",false);
			$(beforeId+"_11771_1").attr("disabled",false);
			if($(beforeId+"_5083").val()<=0){//陈列面数
				errorMsg="陈列面数必须大于0";
				Paper.setValidationResult($(beforeId+"_5083"), errorMsg);
			}  
			if($(beforeId+"_5084").length == 1 && $(beforeId+"_5084").val()<=0){//面积
				errorMsg="面积必须大于0";
				Paper.setValidationResult($(beforeId+"_5084"), errorMsg);
			}  
			if($(beforeId+"_5092").val()<=0){//原价
				errorMsg="原价必须大于0";
				Paper.setValidationResult($(beforeId+"_5092"), errorMsg);
			}
			if($(beforeId+"_5093").val()<=0){//最低价
				errorMsg="最低价必须大于0";
				Paper.setValidationResult($(beforeId+"_5093"), errorMsg);
			}
		}else if(val == "2"){
			$(beforeId+"_11771_0").prop("checked",true);
			$(beforeId+"_11771_1").prop("checked",true);
			$(beforeId+"_11771_0").attr("disabled",false);
			$(beforeId+"_11771_1").attr("disabled",false);
			if($(beforeId+"_5083").val() !="" && $(beforeId+"_5083").val() != 0){//陈列面数
				errorMsg="陈列面数必须等于0";
				Paper.setValidationResult($(beforeId+"_5083"), errorMsg);
			}
			if($(beforeId+"_5084").length == 1 && $(beforeId+"_5084").val() !="" && $(beforeId+"_5084").val() != 0){//面积
				errorMsg="面积必须等于0";
				Paper.setValidationResult($(beforeId+"_5084"), errorMsg);
			} 			
			if($(beforeId+"_5092").val()<=0){//原价
				errorMsg="原价必须大于0";
				Paper.setValidationResult($(beforeId+"_5092"), errorMsg);
			}
			if($(beforeId+"_5093").val()<=0){//最低价
				errorMsg="最低价必须大于0";
				Paper.setValidationResult($(beforeId+"_5093"), errorMsg);
			}
		}
		
        e.stopPropagation();
        e.preventDefault();		
	});
	
	//折价验证
	$("[id$=_5085]").change(function(e){
		var $e = $(this), val = $e.val();
		
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1];
		
		var price =  $(beforeId+"_5092").val();//原价
		var lowestPrice = $(beforeId+"_5093").val();//最低价格
		
		if(val != "" && val != "0"){
			if(!price){
				Paper.setValidationResult($(beforeId+"_5092"), "原价不能为空");
			}
			if(!lowestPrice){
				Paper.setValidationResult($(beforeId+"_5093"), "最低价不能为空");
			}
		} else if(lowestPrice && price && +lowestPrice > +price){
			Paper.setValidationResult($(beforeId+"_5092"), "");
			Paper.setValidationResult($(beforeId+"_5093"), "不能大于原价");
		} else {
			Paper.setValidationResult($(beforeId+"_5092"), "");
			Paper.setValidationResult($(beforeId+"_5093"), "");
		}
		
        e.stopPropagation();
        e.preventDefault();		
	});
	
	//验证本品竞品编号是否存在
	$(productCodeSelector).change(function(e){
		
		var $e = $(this), val = $e.val(), errorMsg = "";
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1];
		var after =parseInt(arr[2])+1;
		if(val) {
			var codeType = $e.parents("tr").find("td:first").text();
			var product = codeType.indexOf("本品") != -1 ? sp : cp;
			Paper.setValidationResult($e, !product[val] ? "编号不存在" : "");
			
			//面积为空的不要验证，不然提交不了
			if($(beforeId+"_"+after).length == 1){ 
				var mjValue = $(beforeId+"_"+after).val();
				if(mjValue == "" || mjValue =="0"){
					Paper.setValidationResult($(beforeId+"_"+after), "面积必须填写,且大于0");
				} else {
					Paper.setValidationResult($(beforeId+"_"+after), "");
				}
			}
		} else {
			Paper.setValidationResult($e, "");
			$(beforeId+"_"+after).length == 1 && Paper.setValidationResult($(beforeId+"_"+after), "");
		}
		
        e.stopPropagation();
        e.preventDefault();			
		
	});

	//竞品是否售卖验证
	$("[id$=_5094]").change(function(e){
		var $e = $(this), val = $e.val(), errorMsg = "";
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1];
		if(val){
			if(val == "0"){
				//陈列面数
				$(beforeId+"_5095").attr("readonly","readonly").val(0);
				//半成品面积
				$(beforeId+"_5096").attr("readonly","readonly").val(0);
				//急冻产品面积
				$(beforeId+"_5097").attr("readonly","readonly").val(0);
				//生鲜产品面积
				$(beforeId+"_5098").attr("readonly","readonly").val(0);
				//散装冻品面积
				$(beforeId+"_5099").attr("readonly","readonly").val(0);

				Paper.setValidationResult($(beforeId+"_5095"), "");
				Paper.setValidationResult($(beforeId+"_5096"), "");
				Paper.setValidationResult($(beforeId+"_5097"), "");
				Paper.setValidationResult($(beforeId+"_5098"), "");
				Paper.setValidationResult($(beforeId+"_5099"), "");
				
			}else if(val == "1"){
				$(beforeId+"_5095").removeAttr("readonly");
				$(beforeId+"_5096").removeAttr("readonly");
				$(beforeId+"_5097").removeAttr("readonly");
				$(beforeId+"_5098").removeAttr("readonly");
				$(beforeId+"_5099").removeAttr("readonly");
				//陈列面数
				var clms = $(beforeId+"_5095").val();
				if(clms =="" || clms <=0 ){
					errorMsg="陈列面数必须大于0";
					Paper.setValidationResult($(beforeId+"_5095"), errorMsg);
				}
				//半成品面积
				var bcp = +$(beforeId+"_5096").val();
				//急冻产品面积
				var jdcp = +$(beforeId+"_5097").val();
				//生鲜产品面积
				var sxcp = +$(beforeId+"_5098").val();
				//散装冻品面积
				var szdp = +$(beforeId+"_5099").val();
				var sumMj = bcp+jdcp+sxcp+szdp;
				//alert(sumMj);
				if(!sumMj || sumMj == "" || sumMj<=0){
					errorMsg="面积总和必须大于0";
					Paper.setValidationResult($(beforeId+"_5096"), errorMsg);
					Paper.setValidationResult($(beforeId+"_5097"), errorMsg);
					Paper.setValidationResult($(beforeId+"_5098"), errorMsg);
					Paper.setValidationResult($(beforeId+"_5099"), errorMsg);
				}else{
					Paper.setValidationResult($(beforeId+"_5096"), "");
					Paper.setValidationResult($(beforeId+"_5097"), "");
					Paper.setValidationResult($(beforeId+"_5098"), "");
					Paper.setValidationResult($(beforeId+"_5099"), "");
				}
			}else if(val == "2"){
				$(beforeId+"_5095").removeAttr("readonly");
				$(beforeId+"_5096").removeAttr("readonly");
				$(beforeId+"_5097").removeAttr("readonly");
				$(beforeId+"_5098").removeAttr("readonly");
				$(beforeId+"_5099").removeAttr("readonly");
				var clms = $(beforeId+"_5095").val();
				if(clms!="0"){
					errorMsg="陈列面数必须为0";
					Paper.setValidationResult($(beforeId+"_5095"), errorMsg);
				}
			}
		}
		
        e.stopPropagation();
        e.preventDefault();		
	});
	
});

//促销活动验证
function valideSales(SalesIds){
	for(var i = 0 ;i<SalesIds.length;i++){
		$("[id$=_"+SalesIds[i]+"]").change(function(e){
			var errorMsg = "";
			var arr = this.id.split("_");
			var beforeId = "#"+arr[0]+"_"+arr[1];
			var values="";
			for(var j=0; j<SalesIds.length; j++){
				values += $(beforeId+"_"+SalesIds[j]).val();
			}

			var id_5084 = $(beforeId+"_5084");
			
			//清空错误提示
			Paper.setValidationResult($(beforeId+"_5083"), "");
			id_5084.length == 1 && Paper.setValidationResult($(beforeId+"_5084"), "");	
			
			
			//陈列面数
			var result1 = values.indexOf("1");
			if(result1>=0){
				var clms =  $(beforeId+"_5083").val();
				if(clms == null || clms==0){
					errorMsg = "陈列面数不能为0";
					Paper.setValidationResult($(beforeId+"_5083"), errorMsg);
				}
			}
			
			//二级陈列面积
			var result2 = values.indexOf("2");
			if(result2>=0 && id_5084.length == 1){
				var ejclmj =  $(beforeId+"_5084").val();
				if(!ejclmj){
					errorMsg = "二级陈列面积不能为空";
					Paper.setValidationResult($(beforeId+"_5084"), errorMsg);
				}
			}
			
			//二级陈列面积和陈列面数
			var result3 = values.indexOf("3");
			if(result3>=0){
				var clms =  $(beforeId+"_5083").val();
				var ejclmj =  $(beforeId+"_5084").val();
				if(id_5084.length == 1 && !ejclmj){
					errorMsg = "二级陈列面积不能为空";
					Paper.setValidationResult($(beforeId+"_5084"), errorMsg);
				}
				if(!clms){
					errorMsg = "陈列面数不能为空";
					Paper.setValidationResult($(beforeId+"_5083"), errorMsg);
	
				}
			}
			
	        e.stopPropagation();
	        e.preventDefault();				
		});
	}
}


//本品二级基准编号
var sp = {
	"TSFTPEJ001": true,
	"TSFTPEJ002": true,
	"TSFTPEJ003": true,
	"TSFTPEJ004": true,
	"TSFTPEJ005": true,
	"TSFTPEJ006": true,
	"TSFTPEJ007": true,
	"TSFTPEJ008": true,
	"TSFTPEJ009": true,
	"TSFTPEJ010": true,
	"TSFTPEJ011": true,
	"TSFTPEJ012": true,
	"TSFTPEJ013": true,
	"TSFTPEJ014": true,
	"TSFTPEJ015": true,
	"TSFTPEJ016": true,
	"TSFTPEJ017": true,
	"TSFTPEJ018": true,
	"TSFTPEJ019": true,
	"TSFTPEJ020": true,
	"TSFTPEJ021": true,
	"TSFTPEJ022": true,
	"TSFTPEJ023": true,
	"TSFTPEJ024": true,
	"TSFTPEJ025": true,
	"TSFTPEJ026": true,
	"TSIQFEJ001": true,
	"TSIQFEJ002": true,
	"TSIQFEJ003": true,
	"TSIQFEJ004": true,
	"TSIQFEJ005": true,
	"TSIQFEJ006": true,
	"TSIQFEJ007": true,
	"TSIQFEJ008": true,
	"TSIQFEJ009": true,
	"TSIQFEJ010": true,
	"TSIQFEJ011": true,
	"TSIQFEJ012": true,
	"TSFPEJ001": true,
	"TSFPEJ002": true,
	"TSFPEJ003": true,
	"TSFPEJ004": true,
	"TSFPEJ005": true,
	"TSFPEJ006": true,
	"TSFPEJ007": true,
	"TSFPEJ008": true,
	"TSFPEJ009": true,
	"TSFPEJ010": true,
	"TSFPEJ011": true,
	"TSFPEJ012": true,
	"TSFPEJ013": true,
	"TSFPEJ014": true,
	"TSFPEJ015": true,
	"TSFPEJ016": true,
	"TSFPEJ017": true,
	"TSFPEJ018": true,
	"TSFPEJ019": true,
	"TSFPEJ020": true,
	"TSFPEJ021": true,
	"TSFPEJ022": true
};

//竞品二级基准编号
var cp = {
	"TSJPEJ001": true,
	"TSJPEJ002": true,
	"TSJPEJ003": true,
	"TSJPEJ004": true,
	"TSJPEJ005": true,
	"TSJPEJ006": true,
	"TSJPEJ007": true,
	"TSJPEJ008": true,
	"TSJPEJ009": true,
	"TSJPEJ010": true,
	"TSJPEJ011": true,
	"TSJPEJ012": true,
	"TSJPEJ013": true,
	"TSJPEJ014": true,
	"TSJPEJ015": true,
	"TSJPEJ016": true,
	"TSJPEJ017": true,
	"TSJPEJ018": true,
	"TSJPEJ019": true,
	"TSJPEJ020": true,
	"TSJPEJ021": true,
	"TSJPEJ022": true,
	"TSJPEJ023": true,
	"TSJPEJ024": true,
	"TSJPEJ025": true,
	"TSJPEJ026": true,
	"TSJPEJ027": true,
	"TSJPEJ028": true,
	"TSJPEJ029": true,
	"TSJPEJ030": true,
	"TSJPEJ031": true,
	"TSJPEJ032": true,
	"TSJPEJ033": true,
	"TSJPEJ034": true,
	"TSJPEJ035": true,
	"TSJPEJ036": true,
	"TSJPEJ037": true		
};


