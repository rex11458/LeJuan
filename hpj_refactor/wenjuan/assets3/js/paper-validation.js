
//整数验证为刚性逻辑，范围验证为非刚性逻辑
//最大、最小值如果没有提供可以从控件本身获取，以满足每个对象的自定义数值范围的验证
function vInt(sender, min, max, nonRigidity){

	var $e = $(sender);
	
	if($e.attr("disabled")) return;
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}
	
	var val = sender.value, errorMsg = "", ra = "";
	
	if(min == null && $e.attr("minval")){
		min = +$e.attr("minval");
	}

	if(max == null && $e.attr("maxval")){
		max = +$e.attr("maxval");
	}	
	
	if(!/^-?\d+$/.test(val)){
		errorMsg = "请输入整数";
	} else {
	
		//非刚逻辑处理
		if(nonRigidity){
			
			//非刚逻辑已经确认过的无需再次验证
			if($(sender).attr("verified") == "1") {
				Paper.setValidationResult($e, "");
				return;
			};
			
			ra = nonRigidityAction(sender);
		}
		
		if(min != null && max != null){
			var intVal = +val;
			if(intVal < min || intVal > max){
				//errorMsg = "数值超出范围，请输入"+min+"-"+max+"的整数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		} else if(min != null){
			var intVal = +val;
			if(intVal < min){
				//errorMsg = "数值超出范围，请输入大于"+min+"的整数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		} else if(max != null){
			var intVal = +val;
			if(intVal > max){
				//errorMsg = "数值超出范围，请输入小于"+max+"的整数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		}
	}
	
	Paper.setValidationResult($e, errorMsg);
}

//数值验证为刚性逻辑，范围验证为非刚性逻辑
//最大、最小值如果没有提供可以从控件本身获取，以满足每个对象的自定义数值范围的验证
function vFloat(sender, min, max, precision, nonRigidity){

	var $e = $(sender);
	
	if($e.attr("disabled")) return;
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}
	
	if(min == null && $e.attr("minval")){
		min = +$e.attr("minval");
	}

	if(max == null && $e.attr("maxval")){
		max = +$e.attr("maxval");
	}
	
	if(precision == null || precision == 0){
		vInt(sender, min, max);
		return;
	}

	var val = sender.value, errorMsg = "", ra = "";
	
	var reg= new RegExp("^-?\\d+(\\.\\d{1,"+precision+"})?$", "gi"); 
	
	if(!reg.test(val)){
		errorMsg = "请输入"+precision+"位小数";
	} else {
		
		//非刚逻辑处理
		if(nonRigidity){
			
			//非刚逻辑已经确认过的无需再次验证
			if($(sender).attr("verified") == "1") {
				Paper.setValidationResult($e, "");
				return;
			};
			
			ra = nonRigidityAction(sender);
		}
		
		if(min != null && max != null){
			var intVal = +val;
			if(intVal < min || intVal > max){
				//errorMsg = "数值超出范围，请输入"+min+"-"+max+"的小数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		} else if(min != null){
			var intVal = +val;
			if(intVal < min){
				//errorMsg = "数值超出范围，请输入大于"+min+"的小数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		} else if(max != null){
			var intVal = +val;
			if(intVal > max){
				//errorMsg = "数值超出范围，请输入小于"+max+"的小数"+ra;
				errorMsg = "数值超出范围"+ra;
			}
		}
	}
	
	Paper.setValidationResult($e, errorMsg);
}

function vEmail(sender){
	
	var $e = $(sender);
	
	if($e.attr("disabled")) return;	
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}

	var val = sender.value, errorMsg = "";
	
	var reg = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
	if(!reg.test(val)){
		errorMsg = "请输入正确的邮箱";
	}

	Paper.setValidationResult($e, errorMsg);
}

function vMobile(sender){
	
	var $e = $(sender);
	
	if($e.attr("disabled")) return;
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}

	var val = sender.value, errorMsg = "";
	
	var reg = /^1\d{10}$/;
	if(!reg.test(val)){
		errorMsg = "请输入正确的手机号码";
	}	

	Paper.setValidationResult($e, errorMsg);
}

function vPhone(sender){

	var $e = $(sender);
	
	if($e.attr("disabled")) return;
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}

	var val = sender.value, errorMsg = "";
	
	var reg = /^0\d{2,3}-?\d{7,8}$/;
	if(!reg.test(val)){
		errorMsg = "请输入正确的电话号码";
	}	
	
	Paper.setValidationResult($e, errorMsg);
}

function vDate(sender){
	
	var $e = $(sender);
	
	if($e.attr("disabled")) return;
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}

	var val = sender.value, errorMsg = "";
	
	var result = val.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
	if(result == null){
		errorMsg = "日期格式错误，正确如:1900-01-01";
	} else {
		var d = new Date(result[1], result[3] - 1, result[4]);
        if (!(d.getFullYear() == result[1] && (d.getMonth() + 1) == result[3] && d.getDate() == result[4])){
        	errorMsg = "日期格式错误，正确如:1900-01-01";
        }
	}
	
	errorMsg && Paper.setValidationResult($e, errorMsg);
}

function vDateTime(sender){
	
	var $e = $(sender);
	
	if($e.attr("disabled")) return;	
	
	if(!sender.value) {
		Paper.setValidationResult($e, "");
		return;
	}

	var val = sender.value, errorMsg = "";
	
	var result = val.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2})$/);
	if(result == null){
		errorMsg = "时间格式错误，正确如:1900-01-01 00:01";
	} else {
		var d = new Date(result[1], result[3] - 1, result[4], result[5], result[6]);
        if (!(d.getFullYear() == result[1] && (d.getMonth() + 1) == result[3] && d.getDate() == result[4] && d.getHours() == result[5] && d.getMinutes() == result[6])){
        	errorMsg = "时间格式错误，正确如:1900-01-01 00:01";
        }
	}
	
	errorMsg && Paper.setValidationResult($e, errorMsg);
}

//多选题排他性选项，如：以上全无
function exclusion(sender){
	var isChecked = sender.checked;
	$("[name="+sender.name+"][id!="+sender.id+"]").each(function(){
		if(isChecked){
			$(this).attr({"disabled": true, "checked": false}).parent().removeClass("checked").addClass("disabled");
		} else {
			$(this).removeAttr("disabled").parent().removeClass("disabled");
		}
	});
}

//非刚逻辑触发入口
function nonRigidityAction(sender){
	return '请备注<div><button class="btn btn-default" onclick="nonRigidityConfirm(\''+sender.id+'\');"><span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 备注</button></div>';
}

//非刚逻辑确认动作
function nonRigidityConfirm(senderId){
	dialog.prompt({title:"请输入备注", content: ""}, function(result){
		Paper.setAbnormal(senderId, result);
    });
}

