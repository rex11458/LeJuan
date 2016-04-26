
//验证选择器
var vSelector = {
		//本品生产日期
		productDate: {
			start: "9137",
			end: "9138"
		},
		//最低价格
		price: "9140",
		//本品是否有售卖（需要考虑跳题）
		sales: { 
			vcol: "9134", 	//验证列的id
			qid:  "2891"	//对应的问题id
		},
		//竞品是否有售卖
		cpSales: {
			FTP: "9153",
			IQF: "9150",
			FP:  "9147",
			"9153": "FTP",
			"9150": "IQF",
			"9147": "FP",
			standard: "9156" //竞品规格及价格对，共15对
		},
		//促销活动（勾选任意一种促销活动都要验证本品或二级必须有一个售卖）
		promotion: {
			FTP:  "[id^=2892_3297_]",
			IQF:  "[id^=2892_3298_]",
			FP:   "[id^=2892_3299_]",
			DELI: "[id^=2892_3300_]"
		},
		//二级产品编号
		productCode: {
			vcol: "[id$=_9192],[id$=_9194],[id$=_9196],[id$=_9198]",	//验证列id
			qid: "2896"													//对应的问题id
		}
};

//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//泰森鸡肉店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	
	$("[id$=_"+vSelector.productDate.end+"]").change(); //日期验证
	$("[id$=_"+vSelector.sales.vcol+"]").change(); 		//本品是否有分销
	$("[id$=_"+vSelector.cpSales.FP+"]").change();		//竞品FP是否有分销
	$("[id$=_"+vSelector.cpSales.IQF+"]").change();		//竞品IQF是否有分销
	$("[id$=_"+vSelector.cpSales.FTP+"]").change();		//竞品FTP是否有分销
	valideProductCategory();		
	
	//竞品规格及价格验证
	var standardCol = +vSelector.cpSales.standard;
	for(var i=0; i<30; i+=2){
		$("[id$=_"+standardCol+i+"]").change();		//验证产品大类是否有售卖
	}
	
	$(vSelector.productCode.vcol).change();			//验证本品竞品编号是否存在
}

//自定义验证初始化
$(function(){	

	categorySwitch();

	valideProductDate();	

	validePrice();
	
	valideSales();
	
	valideCpSales();

	valideCpPrice();
	
	valideSecondProduct();
	
	//触发大类绑定事件，隐藏未选类别的本品与二级
	$("#2908_0_9240,#2909_0_9243").change()
		
});

//验证生产日期
function valideProductDate(){
		
	//最早生产日期验证
	$("[id$=_"+vSelector.productDate.start+"]").change(function(e){
		var $e = $(this), val = $e.val();
		if(val){
			var cd = Paper.getOption("cd");
			var arr = this.id.split("_");
			var valEnd = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[vSelector.productDate.end]).val();
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
	$("[id$=_"+vSelector.productDate.end+"]").change(function(e){
		var $e = $(this), val = $e.val();
		if(val){
			var cd = Paper.getOption("cd");
			var arr = this.id.split("_");
			var valStart = $("#"+arr[0]+"_"+arr[1]+"_"+vSelector[vSelector.productDate.start]).val();
			if(valStart && val < valStart){
				Paper.setValidationResult($e, "不能小于最早生产日期");
			} else if(val > cd){
				Paper.setValidationResult($e, "不能大于当前日期");
			}
		} 
		
        e.stopPropagation();
        e.preventDefault();		
	});	
}

//最低价格不能原价
function validePrice(){

	$("[id$=_"+vSelector.price+"]").change(function(e){
		var $e = $(this), val = $e.val();
		if(val){
			var arr = this.id.split("_");
			var org = +$("#"+arr[0]+"_"+arr[1]+"_"+(+arr[2]-1)).val();
			if(org && +val > +org){
				Paper.setValidationResult($e, "不能大于原价");
			} 
		}

        e.stopPropagation();
        e.preventDefault();		
	});

}

//验证本品是否有售卖
function valideSales(){
	
	$("[id$=_"+vSelector.sales.vcol+"]").change(function(e){
		
		if($("#"+vSelector.sales.qid).hasClass("skip")) return; //忽略跳题
		
		var $e = $(this), val = $e.val();
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1]+"_";
		
		var $ms = $(beforeId+"9135"), //面数
			$mj = $(beforeId+"9136"), //面积
			$sd = $(beforeId+"9137"), //最早生产日期
			$ed = $(beforeId+"9138"), //最后生产日期
			$op = $(beforeId+"9139"), //原价
			$lp = $(beforeId+"9140"); //最低价
		
		if(val && val != "0"){
			$ms.removeAttr("readonly");
			$mj.removeAttr("disabled");
			$sd.removeAttr("disabled");
			$ed.removeAttr("disabled");
			$op.removeAttr("disabled");
			$lp.removeAttr("disabled");
		}
		
		if(val == "0"){
			$ms.attr("readonly",true).val("0");
			$mj.attr("disabled",true).val("0");
			$sd.attr("disabled",true).val('1900-01-01');
			$ed.attr("disabled",true).val('1900-01-01');
			$op.attr("disabled",true).val("0");
			$lp.attr("disabled",true).val("0");
			Paper.setValidationResult($ms, "");
			Paper.setValidationResult($mj, "");
			Paper.setValidationResult($op, "");
			Paper.setValidationResult($lp, "");
			
			//价签是否有黄牌
			$(beforeId+"11772_0").prop("checked",false);
			$(beforeId+"11772_1").prop("checked",false);
			$(beforeId+"11772_0").parent().removeClass("checked");
			$(beforeId+"11772_1").parent().removeClass("checked");
			$(beforeId+"11772_0").attr("disabled",true);
			$(beforeId+"11772_1").attr("disabled",true);
			Paper.setValidationResult($(beforeId+"11772_0").parents("td").find("div:last"), "", true);
		} else if(val == "1"){
			$(beforeId+"11772_0").attr("disabled",false);
			$(beforeId+"11772_1").attr("disabled",false);
			var re = $("[name=sq_a_"+arr[1]+"_11772]:checked").val();
			if(!re){
				Paper.setValidationResult($(beforeId+"11772_0").parents("td").find("div:last"), "该题必选", true);
			}
			
			Paper.setValidationResult($ms, +$ms.val() <= 0 ? "必须大于0" : "");
			Paper.setValidationResult($mj, +$mj.val() <= 0 ? "必须大于0" : "");
			Paper.setValidationResult($op, +$op.val() <= 0 ? "必须大于0" : "");
			Paper.setValidationResult($lp, +$lp.val() <= 0 ? "必须大于0" : "");
		} else if(val == "2"){
			
			$(beforeId+"11772_0").attr("disabled",false);
			$(beforeId+"11772_1").attr("disabled",false);
			var re = $("[name=sq_a_"+arr[1]+"_11772]:checked").val();
			if(!re){
				Paper.setValidationResult($(beforeId+"11772_0").parents("td").find("div:last"), "该题必选", true);
			}
			
			$ms.attr("readonly",true).val("0");
			$mj.attr("disabled",true).val("0");
			$sd.attr("disabled",true).val('1900-01-01');
			$ed.attr("disabled",true).val('1900-01-01');
			Paper.setValidationResult($ms, "");
			Paper.setValidationResult($mj, "");
			Paper.setValidationResult($op, +$op.val() <= 0 ? "必须大于0" : "");
			Paper.setValidationResult($lp, +$lp.val() <= 0 ? "必须大于0" : "");
		}

		if(+$lp.val() > +$op.val()){
			Paper.setValidationResult($lp, "不能大于原价");
		}
		
	});
}

//验证竞品是否有售卖
//当有售卖时需要验证对应竞品SKU的价格及规格必须大于0
function valideCpSales(){
	
	$("[id$=_"+vSelector.cpSales.FP+"],[id$=_"+vSelector.cpSales.IQF+"],[id$=_"+vSelector.cpSales.FTP+"]").change(function(e){
		var $e = $(this), val = $e.val();
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1]+"_";
		
		var $ms = $(beforeId+(+arr[2]+1)), //面数 
			$mj = $(beforeId+(+arr[2]+2)); //面积
		
		if(val && val != "0"){
			$ms.removeAttr("readonly");
			$mj.removeAttr("readonly");
		}
		
		if(val == "0"){
			$ms.attr("readonly",true).val("0");
			$mj.attr("readonly",true).val("0");
			Paper.setValidationResult($ms, "");
			Paper.setValidationResult($mj, "");
		} else if(val == "1"){
			Paper.setValidationResult($ms, +$ms.val() <= 0 ? "必须大于0" : "");
			Paper.setValidationResult($mj, +$mj.val() <= 0 ? "必须大于0" : "");
		} else if(val == "2"){
			Paper.setValidationResult($ms, $ms.val() != "0" ? "必须等于0" : "");
			Paper.setValidationResult($mj, $mj.val() != "0" ? "必须等于0" : "");
		}		
		
		//有对应的竞品品牌，则需要双向验证
		var brandCode = $e.parents("tr").find("td:first").text().replace(/\n|\*/gi,'').trim();
		if(JPBrand[brandCode]){
			
			var category = vSelector.cpSales[arr[2]];
			var hasSales = (val == "1" || val == "2");
			var hasPrice = hasCpSKUPrice(category, brandCode);
			
			if(hasSales ^ hasPrice){
				Paper.setValidationResult($e, category+"竞品必须有售卖或价格");
			}
			
		}
		
	});
	
}

//验证竞品规格及价格，必须同时有或没有
function valideCpPrice(){

	var standardCol = +vSelector.cpSales.standard;
	for(var i=0; i<30; i+=2){
		$("[id$=_"+(standardCol+i)+"]").change(function(e){
				var $e = $(this), val = $e.val();
				var arr = this.id.split("_");
				var nextId = "#"+arr[0]+"_"+arr[1]+"_"+(+arr[2]+1);
				Paper.setValidationResult($(nextId), (!!val ^ !!$(nextId).val()) ? "规格及价格必须同时填写" : "");
		});
	}

}


//验证产品大类是否有售卖（双向验证，即选了大类，则对应的大类要有售卖，如果本品有售卖，则必须要选大类，所以这里采用了异或运算符）
//如果“店内有分销的产品大类”有选中则，需要验证本品或二级对应大类必须有一个售卖
//如果“店内有主货架的产品大类”有选中则，需要验证本品对应大类必须有一个售卖
//如果“店内有二级的产品大类”有选中则，需要验证二级对应的大类必须有一个售卖
function valideProductCategory(){
	
	var $mainCategory = $("#2908").find(".question"),
		$secondCategory = $("#2909").find(".question"),
		$promotion = $("#2892").find(".question");
	
	//主货架大类是否选中
	var mainFTP = $("#2908_0_9240").prop("checked"),
		mainIQF = $("#2908_0_9241").prop("checked"),
		mainFP  = $("#2908_0_9242").prop("checked");
	
	//二级大类是否选中
	var secondFTP = $("#2909_0_9243").prop("checked"),
		secondIQF = $("#2909_0_9244").prop("checked"),
		secondFP  = $("#2909_0_9245").prop("checked");	
	
	//本品各大类是否有售卖
	var mainSales = {
			FTP:  hasMainSales("FTP"),
			IQF:  hasMainSales("IQF"),
			FP:   hasMainSales("FP"),
			DELI: hasMainSales("DELI")
	};
	
	//二级各大类是否有售卖
	var secondSales = {
			FTP:  hasSecondSales("FTP"),
			IQF:  hasSecondSales("IQF"),
			FP:   hasSecondSales("FP"),
			DELI: hasSecondSales("DELI")
	};	

	var errMsg = "";	
	if(mainFTP ^ mainSales.FTP){
		errMsg += "FTP本品必须有售卖</br>";
	}
	
	if(mainIQF ^ mainSales.IQF){
		errMsg += "IQF本品必须有售卖</br>";
	}
	
	if(mainFP ^ mainSales.FP){
		errMsg += "FP本品必须有售卖";
	}
	
	Paper.setValidationResult($mainCategory, errMsg);
	
	errMsg = "";	
	
	if(secondFTP ^ secondSales.FTP){
		errMsg += "FTP二级必须有售卖</br>";
	}	
	
	if(secondIQF ^ secondSales.IQF){
		errMsg += "IQF二级必须有售卖</br>";
	}	
	
	if(secondFP ^ secondSales.FP){
		errMsg += "FP二级必须有售卖";
	}	
	
	Paper.setValidationResult($secondCategory, errMsg);
	
	//二级大类有选中，则二级编号至少要填写一个编号
	if((secondFTP || secondIQF || secondFP) && !(secondSales.FTP || secondSales.IQF || secondSales.FP || secondSales.DELI)){
		Paper.setValidationResult($("#2896").find(".question"), "至少要填写一个编号");
	}	
	
	//有促销则本品或二级必须要有售卖
	errMsg = "";
	for(var key in vSelector.promotion){
		var isChecked = false;	
		$(vSelector.promotion[key]).each(function(){
			if(this.checked){
				isChecked = true;
				return false;
			}
		});	
		if(isChecked && !(mainSales[key] || secondSales[key])){
			errMsg += key+"本品或二级必须有售卖<br/>";
		}		
	}
	
	Paper.setValidationResult($promotion, errMsg);	
}

//大类选中切换显示隐藏
function categorySwitch(){

	//本品
	$("[name=q_2908]").change(function(){
	
		var category = {
			FTP: false,
			IQF: false,
			FP:  false,
			DELI: true
		};
		
		if(this.id != '2908_0_9272'){ //全无
			//获取每个类的选中情况
			$("[name=q_2908]").each(function(){
				category[$(this).parent().text().replace(/\n|\*/gi,'').trim()] = this.checked;			
			});
		}

		$("#2891").find("table>tbody>tr").each(function(){
			var key = $(this).find("td:eq(2)").text().replace(/\n|\*/gi,'').trim();
			if(category[key]){
				$(this).find(":text").attr("isrequired","Y");
				$(this).show();
			} else {
				$(this).find(":text").removeAttr("isrequired").val("");
				$(this).hide();
			}
		});

	});

	//二级本品
	$("[name=q_2909]").change(function(){
	
		var category = {
			FTP: false,
			IQF: false,
			FP:  false
		};
		
		if(this.id != '2909_0_9273'){ //全无
			//获取每个类的选中情况
			$("[name=q_2909]").each(function(){
				category[$(this).parent().text().replace(/\n|\*/gi,'').trim()] = this.checked;			
			});
		}

		var isShow = category.FTP || category.IQF || category.FP;

		$("#2896").find("table>tbody>tr").slice(0,10).each(function(){
			if(isShow){
				$(this).show();
			} else {
				$(this).find(":text").val("");
				$(this).hide();
			}
		});

	});

}

//获取主货架大类是否有分销
function hasMainSales(category){

	if($("#"+vSelector.sales.qid).hasClass("skip")) return false; //忽略跳题
	
	var sales = 0;
	$("[id$=_"+vSelector.sales.vcol+"]").each(function(){
		var $e = $(this), val = $e.val();
		
		if($e.parent().prev().text().replace(/\n|\*/gi,'').trim() == category){
			sales += +val;
		}
	});
	
	return sales > 0;
}

//获取本品大类二级是否有填写编号
//<=3480的为本品数据行
function hasSecondSales(category){

	if($("#"+vSelector.productCode.qid).hasClass("skip")) return false; //忽略跳题
	
	var hasValue = false;
	$(vSelector.productCode.vcol).each(function(){
		var $e = $(this), val = $e.val();
		var arr = this.id.split("_");
		
		if(+arr[1] <= 3480 && val && sp[val] == category){
			hasValue = true;
			return false;
		}
	});
	
	return hasValue;
}

//获取竞品大类是否有价格及规格
function hasCpSKUPrice(category, brandCode){
	
	var brandStandard = JPBrand[brandCode];
	
	var hasValue = false;
	$("[id$=_"+brandStandard+"]").each(function(){
		var $e = $(this), val = $e.val();
		var arr = this.id.split("_");
		var beforeId = "#"+arr[0]+"_"+arr[1]+"_";
		
		if(+val > 0 && +$(beforeId+(+brandStandard+1)).val() > 0 && $e.parents("tr").find("td:eq(2)").text().replace(/\n|\*/gi,'').trim() == category){
			hasValue = true;
			return false;
		}
	});
	
	return hasValue;
}

//验证二级产品编号
function valideSecondProduct(){

	$(vSelector.productCode.vcol).change(function(e){
		
		if($("#"+vSelector.productCode.qid).hasClass("skip")) return; //忽略跳题
		
		var $e = $(this), val = $e.val();
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
					Paper.setValidationResult($(beforeId+"_"+after), "必须大于0");
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
	
};


//本品二级基准编号
var sp = {
		"TSFTP001": "FTP",
		"TSFTP002": "FTP",
		"TSFTP024": "FTP",
		"TSFTP003": "FTP",
		"TSFTP025": "FTP",
		"TSFTP019": "FTP",
		"TSFTP020": "FTP",
		"TSFTP017": "FTP",
		"TSFTP010": "FTP",
		"TSFTP005": "FTP",
		"TSFTP023": "FTP",
		"TSFTP014": "FTP",
		"TSFTP011": "FTP",
		"TSFTP013": "FTP",
		"TSFTP004": "FTP",
		"TSFTP026": "FTP",
		"TSFTP006": "FTP",
		"TSFTP007": "FTP",
		"TSFTP016": "FTP",
		"TSFTP015": "FTP",
		"TSFTP008": "FTP",
		"TSFTP021": "FTP",
		"TSFTP022": "FTP",
		"TSFTP009": "FTP",
		"TSFTP018": "FTP",
		"TSFTP012": "FTP",
		"TSIQF011": "IQF",
		"TSIQF005": "IQF",
		"TSIQF008": "IQF",
		"TSIQF012": "IQF",
		"TSIQF001": "IQF",
		"TSIQF010": "IQF",
		"TSIQF009": "IQF",
		"TSIQF002": "IQF",
		"TSIQF003": "IQF",
		"TSIQF004": "IQF",
		"TSIQF007": "IQF",
		"TSIQF006": "IQF",
		"TSFP004": "FP",
		"TSFP005": "FP",
		"TSFP006": "FP",
		"TSFP008": "FP",
		"TSFP001": "FP",
		"TSFP002": "FP",
		"TSFP007": "FP",
		"TSFP003": "FP",
		"TSFP009": "FP",
		"TSFP010": "FP",
		"TSFP011": "FP",
		"TSFP012": "FP",
		"TSFP013": "FP",
		"TSFP014": "FP",
		"TSFP015": "FP",
		"TSFP016": "FP",
		"TSFP017": "FP",
		"TSFP018": "FP",
		"TSFP019": "FP",
		"TSFP020": "FP",
		"TSFP021": "FP",
		"TSFP022": "FP",	
		"TSSS001": "DELI",
		"TSSS002": "DELI",
		"TSSS003": "DELI"		
};

//竞品二级基准编号
var cp = {
		"TSJP001": true,
		"TSJP002": true,
		"TSJP003": true,
		"TSJP004": true,
		"TSJP005": true,
		"TSJP006": true,
		"TSJP007": true,
		"TSJP008": true,
		"TSJP009": true,
		"TSJP010": true,
		"TSJP011": true,
		"TSJP012": true,
		"TSJP013": true,
		"TSJP014": true,
		"TSJP015": true,
		"TSJP016": true,
		"TSJP017": true,
		"TSJP018": true,
		"TSJP019": true,
		"TSJP020": true,
		"TSJP021": true,
		"TSJP022": true,
		"TSJP023": true,
		"TSJP024": true,
		"TSJP025": true,
		"TSJP026": true,
		"TSJP027": true,
		"TSJP028": true,
		"TSJP029": true,
		"TSJP030": true,
		"TSJP031": true,
		"TSJP032": true,
		"TSJP033": true,
		"TSJP034": true,
		"TSJP035": true,
		"TSJP036": true,
		"TSJP037": true	
};

//竞品品牌，检查价格
var JPBrand = {
	"TSJP034": "9156",
	"TSJP009": "9158",
	"TSJP036": "9160",
	"TSJP004": "9162",
	"TSJP003": "9170",
	"TSJP007": "9172",
	"TSJP016": "9174",
	"TSJP024": "9176",
	"TSJP023": "9178",
	"TSJP022": "9180"	
};


