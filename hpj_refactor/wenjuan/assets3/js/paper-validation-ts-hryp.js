
//分销选择器
var SalesIds = ["1434","1448","1462","1476"];
//总数量选择器 
var totalIds = ["1436","1450","1464","1478"];
//数量选择器
var numberIds = ["1437","1451","1465","1479"]; 


//注意：如果矩阵里有跳过的answid在验证时要加是否存在判断，不然会提交不了
//辉瑞药店内审计问卷验证
//自定义验证方法，提交时会调用
function customValidation() {
	//跳题逻辑忽略验证
	var select_1902=$("[name=q_1902]:checked").attr("id");
	if(select_1902!='1902_0_1420') return; //忽略跳题
	$("[name$=_"+SalesIds[0]+"]").change(); //是否分销验证（只要触发任意一个即可）
	//$("[id$=_11350]").blur();//验证陈列面积
	vaildeSelect("1435");//是否有分销1
	vaildeSelect("1449");//是否有分销2
	vaildeSelect("1463");//是否有分销3
	vaildeSelect("1477");//是否有分销4
	vaildeSelect("1491");//是否有二级陈列
	vaildeSelect("1495");//是否有其他陈列
	vaildeSelect("1510");//是否有促销活动
	vaildeSelect2();//验证POSM选项是否必选
	vaildeSelect3("4059");//验证是否口头推荐
	vaildeSelect3("4060");//验证是否口头推荐
	vaildeSelect3("4061");//验证是否口头推荐
}

$(function(){
	//分销初始化
	valideSales(SalesIds);
	//总数量初始化
	initializeTotals(totalIds);
	//添加列样式，便于区分
	initaddClass();
	for(var i = 0 ;i<numberIds.length;i++){
		onblur(eval(numberIds[i]));
		onblur(eval(numberIds[i])+1);
		onblur(eval(numberIds[i])+3);
		onblur(eval(numberIds[i])+4);
		onblur(eval(numberIds[i])+6);
		onblur(eval(numberIds[i])+7);
		onblur(eval(numberIds[i])+8);
		onblur(eval(numberIds[i])+10);
	}
	
	onblurCost("1435");
	onblurCost("1449");
	onblurCost("1463");
	onblurCost("1477");
	
	//初始化促销员促销活动中不可填的项
	$("#1912_4053_1512,#1912_4055_1512,#1912_4056_1512,#1912_4057_1512,#1912_4058_1512").attr("disabled",true);
	$("[name=sq_a_4053_1511],[name=sq_a_4055_1511],[name=sq_a_4056_1511],[name=sq_a_4057_1511],[name=sq_a_4058_1511]").attr("disabled",true);
	
	//验证是否有二级陈列
	$("[name$=_1490").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "是"){
			$("#"+pref+"1491,#"+pref+"1492,#"+pref+"1493").attr("disabled",false).val("");
			Paper.setValidationResult($("#"+pref+"1491"),"必须填写任意一个二级陈列数量",true);
		}else if(this.checked && result == "否"){
			$("#"+pref+"1491,#"+pref+"1492,#"+pref+"1493").attr("disabled",true).val("");
			Paper.setValidationResult($("#"+pref+"1491"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	//验证任意一个二级陈列数量
	$("[id$=_1491],[id$=_1492],[id$=_1493]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(result){
			Paper.setValidationResult($("#"+pref+"1491"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	
	//验证是否有其他陈列
	$("[name$=_1494").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "是"){
			$("#"+pref+"1495,#"+pref+"1496").attr("disabled",false).val("");
			Paper.setValidationResult($("#"+pref+"1495"),"必须填写其他陈列名称",true);
			Paper.setValidationResult($("#"+pref+"1496"),"必须填写其他陈列数量",true);
		}else if(this.checked && result == "否"){
			$("#"+pref+"1495,#"+pref+"1496").attr("disabled",true).val("");
			Paper.setValidationResult($("#"+pref+"1495"),"",true);
			Paper.setValidationResult($("#"+pref+"1496"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	//验证陈列名称和陈列数量
	$("[id$=_1495]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(result){
			Paper.setValidationResult($("#"+pref+"1495"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();
	});
	$("[id$=1496]").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(result){
			Paper.setValidationResult($("#"+pref+"1496"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();
	});
	//验证是否有POSM
	$("[name$=_1497").change(function(e){
		var result = this.value;
		//alert(result);
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "是"){
			$("[name$=_"+arr[1]+"_1498],[name$=_"+arr[1]+"_1499],[name$=_"+arr[1]+"_1500],[name$=_"+arr[1]+"_1501],[name$=_"+arr[1]+"_1502],[name$=_"+arr[1]+"_1503],[name$=_"+arr[1]+"_1504],[name$=_"+arr[1]+"_1505],[name$=_"+arr[1]+"_1506],[name$=_"+arr[1]+"_1507]").attr("disabled",false);
			$("#"+pref+"1508").attr("disabled",false);
		}else if(this.checked && result == "否"){
			$("[name$=_"+arr[1]+"_1498],[name$=_"+arr[1]+"_1499],[name$=_"+arr[1]+"_1500],[name$=_"+arr[1]+"_1501],[name$=_"+arr[1]+"_1502],[name$=_"+arr[1]+"_1503],[name$=_"+arr[1]+"_1504],[name$=_"+arr[1]+"_1505],[name$=_"+arr[1]+"_1506],[name$=_"+arr[1]+"_1507]").attr("disabled",true);
			$("#"+pref+"1508").attr("disabled",true);
			$("#"+pref+"1498_0,#"+pref+"1498_1,#"+pref+"1499_0,#"+pref+"1499_1,#"+pref+"14500_0,#"+pref+"1500_1,#"+pref+"1501_0,#"+pref+"1501_1,#"+pref+"1502_0,#"+pref+"1502_1,#"+pref+"1503_0,#"+pref+"1503_1,#"+pref+"1504_0,#"+pref+"1504_1,#"+pref+"1505_0,#"+pref+"1505_1,#"+pref+"1506_0,#"+pref+"1506_1,#"+pref+"1507_0,#"+pref+"1507_1").prop("checked",false);
			//$("#"+pref+"1498_1").prop("checked",false);
			$("#"+pref+"1498_0,#"+pref+"1498_1,#"+pref+"1499_0,#"+pref+"1499_1,#"+pref+"14500_0,#"+pref+"1500_1,#"+pref+"1501_0,#"+pref+"1501_1,#"+pref+"1502_0,#"+pref+"1502_1,#"+pref+"1503_0,#"+pref+"1503_1,#"+pref+"1504_0,#"+pref+"1504_1,#"+pref+"1505_0,#"+pref+"1505_1,#"+pref+"1506_0,#"+pref+"1506_1,#"+pref+"1507_0,#"+pref+"1507_1").parent().removeClass("checked");
			//$("#"+pref+"1498_1").parent().removeClass("checked");
			$("#"+pref+"1508").val("");
		}
	});
	//验证是否有促销活动
	$("[name$=_1509").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && result == "是"){
			$("#"+pref+"1510,#"+pref+"1512").attr("disabled",false).val("");
			$("[name$=_"+arr[1]+"_1511]").attr("disabled",false);
		}else if(this.checked && result == "否"){
			$("#"+pref+"1510").attr("disabled",true).val("");
			//$("[name$=_"+arr[1]+"_1511]").attr("disabled",true);
			//$("#"+pref+"1511_0,#"+pref+"1511_1,#"+pref+"1511_2").prop("checked",false);
			//$("#"+pref+"1511_0,#"+pref+"1511_1,#"+pref+"1511_2").parent().removeClass("checked");
		}
	});
	//验证促销员是否在店内
	$("[name$=_1511").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && (result == "否" || result == "不知道")){
			var reson =  $("#"+pref+"1512").val();
			$("#"+pref+"1512").attr("disabled",false).val("");
			if(!reson){
				
				Paper.setValidationResult($("#"+pref+"1512"),"必须填写原因",true);
			}
		}else{
			$("#"+pref+"1512").attr("disabled",true).val("");
			Paper.setValidationResult($("#"+pref+"1512"),"",true);
		}
		e.stopPropagation();
        e.preventDefault();	
	});
	//验证是否有口头推荐
	$("[name$=_1513").change(function(e){
		var result = this.value;
		var arr = this.id.split("_");
		var pref = arr[0]+"_"+arr[1]+"_";
		if(this.checked && (result == "否" || result == "不回答")){
			$("[name$=_"+arr[1]+"_1514]").attr("disabled",true);
			$("#"+pref+"1514_0,#"+pref+"1514_1,#"+pref+"1514_2,#"+pref+"1514_3").prop("checked",false);
			$("#"+pref+"1514_0,#"+pref+"1514_1,#"+pref+"1514_2,#"+pref+"1514_3").parent().removeClass("checked");
		}else if(this.checked && result == "是" ){
			$("[name$=_"+arr[1]+"_1514]").attr("disabled",false);
		}
		
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
			if(this.checked && result == "有分销"){
				
				$("#"+pref+(parme+1)+",#"+pref+(parme+3)+",#"+pref+(parme+4)+",#"+pref+(parme+5)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+8)+",#"+pref+(parme+9)+",#"+pref+(parme+10)+",#"+pref+(parme+11)+",#"+pref+(parme+12)+",#"+pref+(parme+13)+"").attr("disabled",false);
				//$("#"+pref+(parme+2)+"").val("");
			}else if(this.checked && result == "无售卖"){
				$("#"+pref+(parme+1)+",#"+pref+(parme+3)+",#"+pref+(parme+4)+",#"+pref+(parme+5)+",#"+pref+(parme+6)+",#"+pref+(parme+7)+",#"+pref+(parme+8)+",#"+pref+(parme+9)+",#"+pref+(parme+10)+",#"+pref+(parme+11)+",#"+pref+(parme+12)+",#"+pref+(parme+13)+"").attr("disabled",true).val("");
				$("#"+pref+(parme+2)+"").val("0");
			}
	        e.stopPropagation();
	        e.preventDefault();				
		});
	}
}
//总数量初始化
function initializeTotals(totalIds){
	for(var i = 0 ;i<totalIds.length;i++){
		$("[id$=_"+totalIds[i]+"]").attr("disabled",true);
	}
}

//数量失去焦点公共方法
function onblur(numberId){
		$("[id$=_"+numberId+"]").change(function(e){
			//var result = this.value;
			//alert(numberId);
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			if(eval(numberId)>=1437 && eval(numberId)<=1447){
				//alert($("#"+pref+"1437").val());
				//alert('1');
				var sum = eval((eval($("#"+pref+"1437").val())>0)?$("#"+pref+"1437").val():"0")+eval((eval($("#"+pref+"1438").val())>0)?$("#"+pref+"1438").val():"0")+eval((eval($("#"+pref+"1440").val())>0)?$("#"+pref+"1440").val():"0")+eval((eval($("#"+pref+"1441").val())>0)?$("#"+pref+"1441").val():"0")+eval((eval($("#"+pref+"1443").val())>0)?$("#"+pref+"1443").val():"0")+eval((eval($("#"+pref+"1444").val())>0)?$("#"+pref+"1444").val():"0")+eval((eval($("#"+pref+"1445").val())>0)?$("#"+pref+"1445").val():"0")+eval((eval($("#"+pref+"1447").val())>0)?$("#"+pref+"1447").val():"0");
				$("#"+pref+"1436").val(sum);
			}else if( eval(numberId)>=1451 && eval(numberId)<=1461){
				//alert('2');
				//var sum = eval($("#"+pref+"1451").val())+eval($("#"+pref+"1452").val())+eval($("#"+pref+"1454").val())+eval($("#"+pref+"1455").val())+eval($("#"+pref+"1457").val())+eval($("#"+pref+"1458").val())+eval($("#"+pref+"1459").val())+eval($("#"+pref+"1461").val());
				var sum = eval((eval($("#"+pref+"1451").val())>0)?$("#"+pref+"1451").val():"0")+eval((eval($("#"+pref+"1452").val())>0)?$("#"+pref+"1452").val():"0")+eval((eval($("#"+pref+"1454").val())>0)?$("#"+pref+"1454").val():"0")+eval((eval($("#"+pref+"1455").val())>0)?$("#"+pref+"1455").val():"0")+eval((eval($("#"+pref+"1457").val())>0)?$("#"+pref+"1457").val():"0")+eval((eval($("#"+pref+"1458").val())>0)?$("#"+pref+"1458").val():"0")+eval((eval($("#"+pref+"1459").val())>0)?$("#"+pref+"1459").val():"0")+eval((eval($("#"+pref+"1461").val())>0)?$("#"+pref+"1461").val():"0");
				$("#"+pref+"1450").val(sum);
			}else if(eval(numberId)>=1465 && eval(numberId)<=1475 ){
				//alert('3');
				//var sum = eval($("#"+pref+"1465").val())+eval($("#"+pref+"1466").val())+eval($("#"+pref+"1468").val())+eval($("#"+pref+"1469").val())+eval($("#"+pref+"1471").val())+eval($("#"+pref+"1472").val())+eval($("#"+pref+"1473").val())+eval($("#"+pref+"1475").val());
				var sum = eval((eval($("#"+pref+"1465").val())>0)?$("#"+pref+"1465").val():"0")+eval((eval($("#"+pref+"1466").val())>0)?$("#"+pref+"1466").val():"0")+eval((eval($("#"+pref+"1468").val())>0)?$("#"+pref+"1468").val():"0")+eval((eval($("#"+pref+"1469").val())>0)?$("#"+pref+"1469").val():"0")+eval((eval($("#"+pref+"1471").val())>0)?$("#"+pref+"1471").val():"0")+eval((eval($("#"+pref+"1472").val())>0)?$("#"+pref+"1472").val():"0")+eval((eval($("#"+pref+"1473").val())>0)?$("#"+pref+"1473").val():"0")+eval((eval($("#"+pref+"1475").val())>0)?$("#"+pref+"1475").val():"0");
				$("#"+pref+"1464").val(sum);
			}else if(eval(numberId)>=1479 && eval(numberId)<=1489){
				//alert('4'); 
				//var sum = eval($("#"+pref+"1479").val())+eval($("#"+pref+"1480").val())+eval($("#"+pref+"1482").val())+eval($("#"+pref+"1483").val())+eval($("#"+pref+"1485").val())+eval($("#"+pref+"1486").val())+eval($("#"+pref+"1487").val())+eval($("#"+pref+"1489").val());
				var sum = eval((eval($("#"+pref+"1479").val())>0)?$("#"+pref+"1479").val():"0")+eval((eval($("#"+pref+"1480").val())>0)?$("#"+pref+"1480").val():"0")+eval((eval($("#"+pref+"1482").val())>0)?$("#"+pref+"1482").val():"0")+eval((eval($("#"+pref+"1483").val())>0)?$("#"+pref+"1483").val():"0")+eval((eval($("#"+pref+"1485").val())>0)?$("#"+pref+"1485").val():"0")+eval((eval($("#"+pref+"1486").val())>0)?$("#"+pref+"1486").val():"0")+eval((eval($("#"+pref+"1487").val())>0)?$("#"+pref+"1487").val():"0")+eval((eval($("#"+pref+"1489").val())>0)?$("#"+pref+"1489").val():"0");
				$("#"+pref+"1478").val(sum);
			}
		});
}


//实际零售价格
function onblurCost(numberId){
		$("[id$=_"+numberId+"]").change(function(e){
			var result = this.value;
			//alert(numberId);
			var arr = this.id.split("_");
			var pref = arr[0]+"_"+arr[1]+"_";
			if(eval(result)>0){
				//alert(result.indexOf("."));
				if(result.indexOf(".")==-1){
					this.value = result+".00";
				}
			}
			
		});
}
//验证选项是否必选
function vaildeSelect(SalesId){
	//alert();
	//var name = $("[name$=_"+SalesId+"]").attr("name");
	//alert(name);
	$("[id$=_"+SalesId+"]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_"+(eval(SalesId)-1)+"]:checked").val();
		var ids = $("[name=sq_a_"+arr[1]+"_"+(eval(SalesId)-1)+"]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_1").parents("td").find("div:last"), "该题必选", true);
//			e.stopPropagation();
//		    e.preventDefault();	
			return;
		}
		
	});
}
//验证POSM选项是否必选
function vaildeSelect2(){
	$("[id$=_1508]").each(function(e){
		var arr = this.id.split("_");
		var re = $("[name=sq_a_"+arr[1]+"_1497]:checked").val();
		var ids = $("[name=sq_a_"+arr[1]+"_1497]").attr("id");
		var arrIds = ids.split("_");
		if(!re){
			Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_1").parents("td").find("div:last"), "该题必选", true);
//			e.stopPropagation();
//		    e.preventDefault();	
			return;
		}
	});
}
//验证是否口头推荐
function vaildeSelect3(ids){	
	var re = $("[name=sq_a_"+ids+"_1513]:checked").val();
	var ids = $("[name=sq_a_"+ids+"_1513]").attr("id");
	var arrIds = ids.split("_");
	if(!re){
		Paper.setValidationResult($("#"+arrIds[0]+"_"+arrIds[1]+"_"+arrIds[2]+"_2").parents("td").find("div:last"), "该题必选", true);
		return;
	}
}
function initaddClass(){
	addClass("1906","7","#3299CC");
		addClass("1906","8","#3299CC");
		addClass("1906","9","#3299CC");
		addClass("1906","10","#3299CC");
		addClass("1906","11","#8FBC8F");
		addClass("1906","12","#8FBC8F");
		addClass("1906","13","#8FBC8F"); 
		addClass("1906","14","#C0D9D9");
		addClass("1906","15","#C0D9D9");
		addClass("1906","16","#C0D9D9");
		addClass("1906","17","#C0D9D9");
		
		addClass("1907","7","#3299CC");
		addClass("1907","8","#3299CC");
		addClass("1907","9","#3299CC");
		addClass("1907","10","#3299CC");
		addClass("1907","11","#8FBC8F");
		addClass("1907","12","#8FBC8F");
		addClass("1907","13","#8FBC8F"); 
		addClass("1907","14","#C0D9D9");
		addClass("1907","15","#C0D9D9");
		addClass("1907","16","#C0D9D9");
		addClass("1907","17","#C0D9D9");
		
		addClass("1908","7","#3299CC");
		addClass("1908","8","#3299CC");
		addClass("1908","9","#3299CC");
		addClass("1908","10","#3299CC");
		addClass("1908","11","#8FBC8F");
		addClass("1908","12","#8FBC8F");
		addClass("1908","13","#8FBC8F"); 
		addClass("1908","14","#C0D9D9");
		addClass("1908","15","#C0D9D9");
		addClass("1908","16","#C0D9D9");
		addClass("1908","17","#C0D9D9");
		
		addClass("1909","7","#3299CC");
		addClass("1909","8","#3299CC");
		addClass("1909","9","#3299CC");
		addClass("1909","10","#3299CC");
		addClass("1909","11","#8FBC8F");
		addClass("1909","12","#8FBC8F");
		addClass("1909","13","#8FBC8F"); 
		addClass("1909","14","#C0D9D9");
		addClass("1909","15","#C0D9D9");
		addClass("1909","16","#C0D9D9");
		addClass("1909","17","#C0D9D9");
	
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