
//泰森鸡肉2个问卷逻辑写在一起
//自定义验证方法，提交时会调用
function customValidation() {
	valideScore();
}

//验证得分的选择器
var vSelector = {
		"score": "[name$=_4723],[name$=_4740]",
		"scorePost": "[name=sq_a_2817_4723],[name=sq_a_2818_4723],[name=sq_a_2819_4723],[name=sq_a_2848_4740],[name=sq_a_2849_4740],[name=sq_a_2850_4740]"
};

//陈列要求打分项不控制
var exclude = {
		"sq_a_2820_4723": true,
		"sq_a_2821_4723": true,
		"sq_a_2822_4723": true,
		"sq_a_2851_4740": true,
		"sq_a_2852_4740": true,
		"sq_a_2853_4740": true
};

$(function(){
	
	//得分验证
	$(vSelector.scorePost).change(function(e){
		
		var v = $(vSelector.scorePost).map(function(){
			return this.checked ? $(this).val() : null;
		}).get().join("");
		
		//在岗情况的3个问题得分为0时（全都选择否），将其他问题设为否（除陈列要求外）
		if(v.length == 3 && v.indexOf("是") == -1){
			
			$(vSelector.score).each(function(){
				
				if(exclude[this.name]) 
					return true;
				
				if(this.value == "是"){
					this.checked = false;
					$(this).parent().removeClass("checked");
				} else{
					this.checked = true;
					$(this).parent().addClass("checked");					
				}
			});
		}
		
        e.stopPropagation();
        e.preventDefault();		
		
	});
	
});


//第5大题（在岗情况）得分为0，则第1、2、3、4和7大题总分必须为0
function valideScore(){
	
	//第5题的总分
	var v = $(vSelector.scorePost).map(function(){
		return this.checked ? $(this).val() : null;
	}).get().join("");
	
	//在岗情况的3个问题得分为0时（全都选择否），其他问题必须为否（除陈列要求外）
	if(v.length == 3 && v.indexOf("是") == -1){
		
		$(vSelector.score).each(function(){
			
			if(exclude[this.name]) 
				return true;
			
			if(this.value == "是" && this.checked){
				Paper.setValidationResult($(this).parents("td").find("div:last"), "必须选否");
			}
		});
	}
}

