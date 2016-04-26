var Paper = function () {

	//旧文件在保存问卷时删除，用户上传的文件但未保存问卷在离开页面时删除
	var oldFiles = [], unSavedFiles = [];

	var handleInit = function(options){
		
		this.options = options;
		
		if(options.pm == 'edit'){
			if(options.dt != 'm'){
				$(window).bind('beforeunload',function(){
					return '您确定离开此页面吗？';
				});			
			}
			
			if(options.rs == 'N') {
				$(window).bind('unload', function(){
					deleteFiles(unSavedFiles);
				});		
			}
		}
	};
	
    var handleFancybox = function () {
        if (!jQuery.fancybox) {
            return;
        }

        if (jQuery(".fancybox-button").size() > 0) {            
            jQuery(".fancybox-button").fancybox({
                groupAttr: 'data-rel',
                prevEffect: 'none',
                nextEffect: 'none',
                closeBtn: true,
                helpers: {
                    title: {
                        type: 'inside'
                    }
                }
            });
        }
    };	

	//获取回答结果
	var getResult = function(){

		var resultJson = [];
		
		$("#paperContent .qc:not(.skip)").each(function(){
			
			$(this).find(":input[qtype]").each(function(){
				   
				var $e = $(this), qtype = $e.attr("qtype");
				   
				//输入题有值或者选择题有选中
				if( (qtype == 'I' && $e.val()) || ((qtype == 'S' || qtype == 'AS') && $e.is(":checked")) ){
					var result = this.id.split("_");
					resultJson.push({
						"questionId": result[0], 
						"subQuestionId": result[1],
						"answerId": result[2], 
						//输入题、单选或多选组附加结果为自身值，否则查找选择题的附加结果
						"result": (qtype == 'I' || qtype == 'AS') ? $e.val() : ($("#append_"+this.id).val() || ''),
						"remark": $e.next().find(".abnormal").text()
					});
				}
				
			});	
			
		});
		
		return JSON.stringify(resultJson);
	};
	
	var getResultAndroid = function(){
		var result = getResult();
		Paper01.getResult(result);
	};
	
	var getLeaveRemark = function(){
		var leaveRemark = $("#pnlRemark textarea").map(function(){
			var val = $(this).val().trim();
			if(val){
				return "<strong>"+$(this).parent().find("label").text() + "</strong>：" + val;
			}
		}).get().join("<br/>") || $("#leaveRemarkText").html();
		
		return leaveRemark || '';
	};
	
	var getLeaveRemarkAndroid = function(){
		var leaveRemark = getLeaveRemark();
		Paper01.getLeaveRemark(leaveRemark);
	};
	
	//保存数据
	var saveData = function(resultId, resultStatus){
		
		if(options.pm != 'edit') return;
		
		if(resultStatus == 'Y' && !isValideForm()){
			return;
		}
		
		if(options.dt == 'm'){
			saveToApp();
			return;
		}		
		
		var resultJson = getResult();
		if(!resultJson){
			alert("您未填写问卷，请填写后再保存！");
			return;
		}
		
		//return;
		
		$("#btnSave,#btnSubmit").attr("disabled", true);
		$(resultStatus == 'N' ? "#btnSave" : "#btnSubmit").html(function(){return $(this).html()+"中...";}); 
		
		//保存状态不获取离店备注
		var leaveRemarkText = resultStatus == 'N' ? "" : getLeaveRemark();
		
		$.ajax({
			url: "../../publicapi.PublicApiPRC.submitResult.submit",
			data: {
				resultId: resultId, 
				resultStatus: resultStatus, 
				resultJson: resultJson,
				startDate: $("#startDate").val(),
				endDate: $("#endDate").val(),
				resultDate: $("#resultDate").val(),
				dt: options.dt,
				remark: leaveRemarkText
			},
			dataType: "json",
			type: "post",
			success: function(data){
				
				//清空未保存的文件, 删除旧文件
				unSavedFiles = [];
				deleteFiles(oldFiles);
				oldFiles = [];
				
				alert(data.errorMsg || (resultStatus == 'Y' ? "提交成功" : "保存成功"));
				
				if(options.dt != 'm' && resultStatus == 'Y' && !data.errorMsg){
					$(window).unbind('beforeunload');
					window.opener = null;
					window.open('','_self');
					window.close();
				}
			},
			error: function(XMLHttpRequest, textStatus, errorThrown){				
				alert(textStatus);
			},
			complete: function(){
				$("#btnSave,#btnSubmit").attr("disabled", false).html(function(){return $(this).html().replace("中...","");});
			}
		});
	};
	
	var clearResult = function(){
		$("#paperContent :input[qtype]").each(function(){
			var $e = $(this), qtype = $e.attr("qtype");
			if(qtype == 'I'){
				$e.val('');
			} else {
				$e.removeAttr("checked");
				$e.parent().removeClass("checked");
			}
		});
	};
	
	//回填结果
	var backfillResult = function(resultDtl){
		
		if(!resultDtl || resultDtl.length == 0) return;
		
		//clearResult();
		
		for(var i=0; i<resultDtl.length; i++){
			
			var combinationId = resultDtl[i].questionId+"_"+resultDtl[i].subQuestionId+"_"+resultDtl[i].answerId, 
				result = resultDtl[i].result, //附加结果
				remark = resultDtl[i].remark; //不满足逻辑的备注
			
			$e = $("#"+combinationId);

			//矩阵单选组或多选组
			if($e.length == 0){
				$("[id^="+combinationId+"]").each(function(){
					if(this.value == result){
						this.checked = true;
						$(this).parent().addClass("checked");
						return false;
					}
				});
			} else {
				
				var qtype = $e.attr("qtype");
				
				//输入题
				if(qtype == 'I'){
					$e.val(result);
					
					//不满足逻辑的备注
					if(remark){
						setAbnormal($e.attr("id"), remark);
					}
					
					//显示图片缩略图
					if(result){
						if($e.attr("name") == "resultImage"){
							if(options.dt == 'm'){
								$e.parents("form").find(".imgtool").remove();
								$e.parents("form").append(getImageToolApp(result, 60));
							} else {
								$e.parents("form").append(getImageTool(result, 60));
							}
						} else if($e.attr("name") == "resultAudio"){
							$e.parents("form").append(getAudioTool(result));
						} else if($e.attr("name") == "resultVideo"){
							$e.parents("form").append(getVideoTool(result));
						} else if($e.attr("name") == "resultFile"){
							$e.parents("form").append(getFileTool(result));
						}
					}
				}
				//选择题
				else if(qtype == 'S'){
					
					//以下序列不能换
					
					//先跳题
					if($e.attr("skipids")){
						skipQuestion($e.parents(".radio,.checkbox")[0], true);
					}
					
					//选中
					$e.prop("checked", true);
					$e.parent().addClass("checked");
					result && $("#append_"+combinationId).val(result);
					
					//排他性选项，必须要先选中
					if($e.attr("exclusion")){
						exclusion($e[0]);
					}
				}
			}
		}
		
		handleFancybox();
		
		//app绑定数据后调用一下初始化工作
		if(options.dt == 'm' && typeof pageInit == "function"){
			pageInit();
		}
	};
	
	var backfillResultAndroid = function(resultDtl){
		backfillResult(resultDtl);
		Paper01.backfillComplete();
	};
	
	//图片缩略图
	var getImageTool = function(src, viewSize){
		
		var srcSmall = src;
		
		if(src.indexOf("http://") == -1){
			srcSmall = options.fs + "small/"+src;
			src = options.fs + src;
		}
		
		var del = '<span class="glyphicon glyphicon-trash" aria-hidden="true" onclick="Paper.removeFile(this);"></span>';
		
		var imageToolHtml = '\
			<span class="imgtool margin-left-10">\
				<a class="fancybox-button" data-rel="fancybox-button" href="'+src+'" target="_blank">\
					<img src="'+srcSmall+'" alt="" class="img-thumbnail-'+(viewSize || 60)+' margin-bottom-10 " />\
				</a>\
				'+(options.pm =='edit' ? del : '')+'\
			</span>';		
		
		return imageToolHtml;
	};
	
	//图片缩略图
	var getImageToolApp = function(src, viewSize){
		
		return '<span class="imgtool margin-left-10"><span src="'+src+'" onclick="Paper.appShowImage(this);" class="glyphicon-class">查看图片</span><span class="glyphicon glyphicon-trash margin-left-10" aria-hidden="true" onclick="Paper.removeFile(this);"></span></span>';
		/*
		var del = '<span class="glyphicon glyphicon-trash" aria-hidden="true" onclick="Paper.removeFile(this);"></span>';
		
		var imageToolHtml = '\
			<span class="imgtool margin-left-10">\
				<img src="'+src+'" onclick="Paper.appShowImage(this);" alt="" class="img-thumbnail-'+(viewSize || 60)+' margin-bottom-10 " />\
				'+(options.pm =='edit' ? del : '')+'\
			</span>';		
		
		return imageToolHtml;
		*/
	};
	
	//录音
	var getAudioTool = function(src){
		
		if(src.indexOf("http://") == -1){
			src = options.fs + src;
		}
		
		var del = '<span class="glyphicon glyphicon-trash" aria-hidden="true" onclick="Paper.removeFile(this);"></span>';
		
		var audioToolHtml = '\
			<span class="audiotool  margin-left-10">\
				<audio src="'+src+'" controls="controls" style="width:220px;height:40px;">\
					您的浏览器不支持,请使用IE9+、Chrome、Firefox等浏览器\
				</audio>\
				'+(options.pm =='edit' ? del : '')+'\
			</span>';		
		
		return audioToolHtml;
	};	
	
	//视频
	var getVideoTool = function(src){
		
		if(src.indexOf("http://") == -1){
			src = options.fs + src;
		}
		
		var del = '<span class="glyphicon glyphicon-trash" aria-hidden="true" onclick="Paper.removeFile(this);"></span>';
		
		var videoToolHtml = '\
			<div class="videotool margin-left-10 margin-bottom-20" style="width: 320px; height: 240px; margin: 0px auto; background-color: rgb(0, 0, 0);">\
				<video controls="controls" src="'+src+'" style="width:100%;height:100%;">\
					您的浏览器不支持,请使用Chrome浏览器\
				</video>\
				'+(options.pm =='edit' ? del : '')+'\
			</div>';		
		
		return videoToolHtml;
	};
	
	//文件
	var getFileTool = function(src){
		
		if(src.indexOf("http://") == -1){
			src = options.fs + src;
		}
		
		var del = '<span class="glyphicon glyphicon-trash" aria-hidden="true" onclick="Paper.removeFile(this);"></span>';
		
		var fileToolHtml = '\
			<span class="videotool  margin-left-10">\
				<a href="'+src+'" target="_blank" title="右键选择目录另存为">下载</a>\
				'+(options.pm =='edit' ? del : '')+'\
			</span>';		
		
		return fileToolHtml;
	};
	
	var appShowImage = function(sender){		
    	var arr = $(sender).attr("src").split("\/");    	
		var url = "LJ://ShowImage//imageName="+arr[arr.length - 1];
		window.location.href = url;     	
	};
	
	var uploadIconClick = function(questionId, subQuestionId, answerId, type, sender){
		
		if(options.pm != 'edit') return;
		
		if(options.dt == 'm'){
			var url = "LJ://"+type+"//questionId="+questionId+"&subQuestionId="+subQuestionId+"&answerId="+answerId;
			window.location.href = url;  
		} else {
			$(sender).siblings("[name='filePath']").click();
		}		
	};
	
	//app拍照或图片上传
	var photograph = function(questionId, subQuestionId, answerId, sender){
		
		if(options.pm != 'edit') return;
		
		if(options.dt == 'm'){
			var url = "LJ://Recharge//questionId="+questionId+"&subQuestionId="+subQuestionId+"&answerId="+answerId;
			window.location.href = url;  
		} else {
			$(sender).siblings("[name='filePath']").click();
		}
	};
	
	//app拍照回调
	var setImage = function(questionId, subQuestionId, answerId, filePath){
		
		if(!filePath) return;
		
    	var $e = $("#"+questionId+"_"+subQuestionId+"_"+answerId);
    	
    	var arr = filePath.split("\/");
    	$e.val(arr[arr.length - 1]);
    	
    	$e.parents("form").find(".imgtool").remove();
    	$(getImageToolApp(filePath)).insertAfter($e);
    	
	};	
	
	//上传文件（图片、音频、视频、文件）
	var uploadFile = function(sender, type){
		
		if(options.pm != 'edit') return;
		
		if(!sender.value) return;
		
		var $p = $(sender).siblings(".glyphicon").first();
		
		$p.replaceWith('<img src="../../assets3/img/loading.gif" class="loading">');
		
		var form = $(sender).parents("form");
		
        $(form).ajaxSubmit({
        	type: "post",
        	dataType: "json",
        	traditional: true,
        	url: "../../publicapi.PublicApiPRC.upload"+type+".submit",
        	success: function(data, statusText){
        		
        		if(data.errorMsg != ""){
        			alert(data.errorMsg);
        		} else {
	        		//未保存时需删除用户上传的文件
	        		unSavedFiles.push(data.result);
	        		
	        		$(sender).removeAttr("readonly");
	        		$(sender).next().val(data.result);
	        		
	        		if(type == "Image"){
	        			
		        		var $fb = form.find(".fancybox-button");
		        		if($fb.length > 0){
		        			oldFiles.push($fb.attr("href").replace(options.fs,""));
		        			$fb.parent().remove();
		        		}
	        			form.append(getImageTool(data.result, 60));	
		        		handleFancybox();
		        		
	        		} else if(type == "Audio"){
	        			
		        		var $t = form.find("audio");
		        		if($t.length > 0){
		        			oldFiles.push($t.attr("src").replace(options.fs,""));
		        			$t.parent().remove();
		        		}	        			
	        			form.append(getAudioTool(data.result));	
	        			
	        		} else if(type == "Video"){
	        			
		        		var $t = form.find("video");
		        		if($t.length > 0){
		        			oldFiles.push($t.attr("src").replace(options.fs,""));
		        			$t.parent().remove();
		        		}	        			
	        			form.append(getVideoTool(data.result));	
	        			
	        		} else if(type == "File"){
	        			
		        		var $t = form.find("a");
		        		if($t.length > 0){
		        			oldFiles.push($t.attr("href").replace(options.fs,""));
		        			$t.parent().remove();
		        		}	        			
	        			form.append(getFileTool(data.result));	
	        			
	        		}
	        		
        		}
        	},
        	error: function(){
        		alert("上传失败，请检查网络是否通畅");
        	},
        	complete: function(){
        		$(sender).siblings(".loading").replaceWith($p);
        	}
        });		
		
	};
	
	//删除文件，在保存问卷之前仅隐藏，保存时物理删除
	var removeFile = function(sender){
		
		var $e = $(sender).parents("form").find("[name^='result']");
		
		if($e.length == 0 || !$e.val()) return;
		
		oldFiles.push($e.val());
		
		$e.val("");
		
		$(sender).parent().remove();
		
	};	
		
	//删除文件（物理删除）
	var deleteFiles = function(arrFiles){
		
		if(!arrFiles || arrFiles.length == 0 || this.options.rs == 'Y') return;
		
		$.ajax({
			async: false,
			url: "../../publicapi.PublicApiPRC.deleteFiles.submit",
			data: {filePaths: arrFiles.join("|") },
			type: "post",
			success: function(data){
				;
			}
		});
		
	};	
	
	//附加的面板
	var getAppendPanel = function(id, title, body, closeCallback){
		var panelHtml = '\
			<div class="row margin-top-20 margin-bottom-20" id="'+id+'">\
				<div class="col-md-12">\
					<div class="panel panel-default">\
						<div class="panel-heading">\
							<button type="button" class="close" aria-label="Close" onclick="'+closeCallback+'"><span aria-hidden="true">&times;</span></button>\
							<h3 class="panel-title">'+title+'</h3>\
						</div>\
	                  	<div class="panel-body">\
							'+body+'\
	                  	</div>\
					</div>\
				</div>\
			</div>';		
		return panelHtml;
	};
	
	//搜索问题
	var searchQuestion = function(searchKey){
		
		if(!$.trim(searchKey)) return;
		
		$("#searchResult").remove();
		
		var questionList = [], qIdList = [];
		
		$("#paperContent [issearch='Y']").each(function(){
			var questionTitle = $(this).text();
			var reg= new RegExp(searchKey, "gi"); 
			if(reg.test(questionTitle)){
				questionList.push('<li class="margin-top-10"><h5><a class="refed" href="#'+this.id+'" onclick="Paper.goToQuestion(this);">'+questionTitle.replace(reg, "<mark>"+searchKey+"</mark>")+'</a></h5></li>');
				qIdList.push(this.id);
			}
		});
		
		if(qIdList.length == 1){
			scrollToQuestion(qIdList[0]);
		} else {
			var searchResult = questionList.length > 0 ? "<ol>"+questionList.join("")+"</ol>" : "很抱歉，没有找到与“"+searchKey+"”相关的问题，请检查您的输入是否正确。";
			var searchHtml = getAppendPanel('searchResult', '搜索结果：', searchResult, 'Paper.removeSearchResult(this);');
			$(".container").prepend(searchHtml);
			
			scrollToPos($("#searchResult"));
		}
	};
	
	//题盘定位
	var scrollToQuestion = function(qid){
		//$("#paperContent .panel[id^=page]").hide();
		var $e = $("#"+qid);
		$e.parents(".panel").show();
		$e.is(":visible") ? scrollToPos($e) : scrollToPos($e.parent());
	};
	
	//定位到问题
	var goToQuestion = function(sender){
		$(".matchedq").removeClass("matchedq");
		$($(sender).attr("href")).find(".question,em").addClass("matchedq");
		$("#paperContent .panel[id^=page]").hide();
		$($(sender).attr("href")).parents(".panel").show();
	};
	
	//关闭搜索结果
	var removeSearchResult = function(sender){
		$(".matchedq").removeClass("matchedq");
		$(sender).parents(".row").remove();		
	};
	
	//获取分页
	var getPageList = function(){
		var pages = [];
		$("#paperContent .panel[id^=page]:not(.skip)").each(function(){
			pages.push({id: this.id.replace("page",""), name: $(this).find(".panel-heading .panel-title").text()});
		});
		return JSON.stringify(pages);
	};
	
	var getPageListAndroid = function(){
		var pageList = getPageList();
		Paper01.getPageList(pageList);
	};
	
	//显示页
	var showPage = function(pageId){
    	$("#paperContent .panel[id^=page][id!=page"+pageId+"]").hide();
    	var $page = $("#paperContent #page"+pageId);
    	$page.show();
    	scrollToPos($page);
	};
	
	//app 离线保存
	var saveToApp = function(){
		window.location.href = "LJ://SaveData//";
	};
	
	//数组去重
	var uniqueArr = function(arr) {
	    var result = [], hash = {};
	    for (var i = 0, elem; (elem = arr[i]) != null; i++) {
	        if (!hash[elem]) {
	            result.push(elem);
	            hash[elem] = true;
	        }
	    }
	    return result;
	};	
	
    //跳题（先触发跳题事件，再触发选中事件）
	/* 前置处理：
	 * 1. 选项被禁用时不处理
	 * 2. 无跳题项时不处理
	 * 处理过程：
	 * 1. 找出所有被跳过的题目，认为将要显示出来的题目，标记为:showIds
	 * 2. 将showIds去掉重复的题目
	 * 3. 取得当前选项选中后需要隐藏的题目，并隐藏之，标记为：hiddenIds
	 * 4. 从showIds去掉hiddenIds的题目
	 * 5. 显示showIds中的题目
	 * 6. 分页中所有题目都跳过，则隐藏掉整个分页
	 */
    var skipQuestion = function(sender, isInit){
    	
       if(options.pm == 'view' && !isInit) return;
       
       //被禁用掉的不触发跳题逻辑
       if($(sender).find(":radio:disabled,:checkbox:disabled").length == 1) return;
       
 	   var skipids = $(sender).parents("ul").find("[skipids]").map(function(){
		   return $(this).attr("skipids");
	   }).get().join(",");
 	   
 	   if(!skipids) return false;
 	   
 	   var showIds = uniqueArr(skipids.split(','));
 	   
 	   //因为先执行跳题事件然后才会触发选中事件，所以这里加了反逻辑，即非选中时（等于选中）要隐藏跳过的题目，而选中时（等于取消选中）则要将隐藏的题目显示出来
	   var hiddenIds = $(sender).find(":radio:not(:checked),:checkbox:not(:checked)").attr("skipids");
	   if(hiddenIds){
		   
		   var hIds = hiddenIds.split(',') , hash = {};
		   for (var i = 0, elem; (elem = hIds[i]) != null; i++) {
			   hash[elem] = true;
			   
	 		   var $q = $("#"+elem);
	 		   if(!$q.is(".skip")){
	 			  $q.addClass("skip").hide();
	 		   }			   
		   }
		   
		   var arrIds = [];
		   for (var i = 0, elem; (elem = showIds[i]) != null; i++) {
		        if (!hash[elem]) {
		        	arrIds.push(elem);
		        }
		   }
		   
		   showIds = arrIds;
	   }
	   
	   if(showIds.length > 0){
		   for (var i = 0, elem; (elem = showIds[i]) != null; i++) {
	 		   var $q = $("#"+elem);
	 		   if($q.is(".skip")){
	 			  $q.removeClass("skip").show();
	 		   }
	 	   }  		   
	   }
	   
	   $("#paperContent .panel[id^=page]").each(function(){
		   var $e = $(this);
		   if($e.find(".qc:not(.skip)").length == 0){
			   $e.addClass("skip");
			   $e.is(":visible") && $e.hide();
		   } else {
			   $e.removeClass("skip");
			   options.dt != 'm' && $e.is(":hidden") && $e.show();
		   }
	   });
	   
	   return false;    	
    };
    
    //滚动到元素位置
    var scrollToPos = function(target){
    	if (target.length == 0) return;
        var pos = target.offset().top;
        $('html, body').animate({
            scrollTop: pos
        }, 'slow');
    };
    
	//题盘,完成情况
	var getQuestionPanel = function(){
		
		var questionPanel = [];
		
		$("#paperContent .qc:not(.skip)").each(function(){
			
			var $q = $(this), ismatrix = $q.attr("ismatrix"), isrequired = $q.attr("isrequired");
			
			var select = [], hash = {}, completed = "1", locationId = "";
			
			if(isrequired == "Y") {
				
				$q.find(":input[isrequired=Y]").each(function(){
					
					var $a = $(this), qtype = $a.attr("qtype");
					
					if(qtype == "I" && $a.val() == '') {
						completed = "0";
						!locationId && (locationId = this.id);
					} else if(qtype == "S" || qtype == "AS") {
						var name = $a.attr("name");
						if(!hash[name]){
							select.push(name);
							hash[name] = true;
						}					
					}
					
				});
				
				if(select.length > 0) {
					
					$.each(select, function(i, v){

						var checked = false;
						
						$q.find("[name="+v+"]").each(function(){
							if(this.checked){
								var $append = $("#append_"+this.id);
								if( $append.length > 0 && !$.trim($append.val()) ){
									!locationId && (locationId = this.id);
								} else {
									checked = true;
									return false;
								}
							}		
						});	
						
						if(!checked){
							completed = "0";
							if(ismatrix == "Y") {
								!locationId && (locationId = $q.find("[name="+v+"]:first").attr("id"));
							} else {
								!locationId && (locationId = $q.attr("id"));
							}
						}		
					
					});
				}				
			} else {
				
				completed = "0";
					
				$q.find(":input[qtype]").each(function(){
					var $e = $(this), qtype = $e.attr("qtype");
					if( (qtype == 'I' && $e.val()) || ((qtype == 'S' || qtype == 'AS') && $e.is(":checked")) ){
						completed = "1";
						return false;
					}
				});	
				
			}

			!locationId && (locationId = $q.attr("id"));
			
			questionPanel.push({qindex: $q.attr("qindex"), completed: completed, qid: locationId});
				
		});			
		
		return JSON.stringify(questionPanel);
	};
	
	var getQuestionPanelAndroid = function(){
		var questionPanel = getQuestionPanel();
		Paper01.getQuestionPanel(questionPanel);
	};
	
	//完成率
	var getCompletionRate = function(){
		
		var questionPanel = getQuestionPanel();
		
		if(!questionPanel){
			return 0;
		}
		
		var arr = JSON.parse(questionPanel), completedCount = 0;
		
	    for (var i = 0, elem; (elem = arr[i]) != null; i++) {
	    	elem.completed == "1" && completedCount++;
	    }	
	    
	    return (completedCount / arr.length).toFixed(2);
	};
	
	var getCompletionRateAndroid = function(){
		var rate = getCompletionRate();
		Paper01.getCompletionRate(rate);
	};    
	
	//表单常规验证
	var isValideForm = function (){

		//return true;
		
		//app模式显示所有分页
		options.dt == "m" && $("#paperContent .panel[id^=page]:not(.skip)").show();
		
		//清空错误定位
		this.errorIndex = 0;
		this.isValideForm = true;
		
		//验证结果
		var isValideResult = true;
		
		//清除错误
		$(".error").removeClass("error");
		$(".help-block-error").remove();

		//错误提示
		var errSpan = "<label class='help-block-error'>此项必填</label>", errClass = "error";
		
		//验证问卷相关时间
		$("#paperDate :input").each(function(){
			
			var $a = $(this), isValide = true, errEl = null, val = $a.val();
			
			if(!$.trim(val)){	
				isValide = false;
				errEl = errSpan;
			} else if(this.id == "endDate" && val < $("#startDate").val()){
				isValide = false;
				errEl = "<span class='help-block-error'>结束时间不能小于开始时间</span>";						
			} else if(this.id == "resultDate") {
				if(val > options.cd) {
					isValide = false;
					errEl = "<span class='help-block-error'>不能大于当前时间</span>";							
				} else if(val < options.sd  || val > options.ed) {
					isValide = false;
					errEl = "<span class='help-block-error'>不能超出计划时间： "+options.sd+" ~ "+options.ed+"</span>";	
				}
			}
			
			if(!isValide){
				$a.addClass(errClass);
				$(errEl).insertAfter($a);
				isValideResult = false;
				!errorIndex++ && scrollToPos($a);
			}
			
		});
		
		//逐题验证
		$("#paperContent .qc:not(.skip)").each(function(){
			
			var isValidQuestion = true;
			
			var $q = $(this), ismatrix = $q.attr("ismatrix"), qt = $q.attr("qt");
			
			var select = [], hash = {};
			
			$q.find(":input[isrequired=Y]").each(function(){
				
				var $a = $(this), qtype = $a.attr("qtype");
				
				if(qtype == "I" && $a.val().trim() == '') {
					isValidQuestion = false;	
					$a.addClass(errClass);
					$(errSpan).insertAfter($a);
					!errorIndex++ && scrollToPos($a.parent());					
				} else if(qtype == "S" || qtype == "AS") {
					var name = $a.attr("name");
					if(!hash[name]){
						select.push(name);
						hash[name] = true;
					}					
				}
				
			});
			
			if(select.length > 0) {
				
				$.each(select, function(i, v){

					var checked = false;
					
					$q.find("[name="+v+"]").each(function(){
						var $a = $(this);
						if($a.is(":checked")){
							var $append = $("#append_"+this.id);
							if( $append.length > 0 && !$.trim($append.val()) ){
								$append.addClass(errClass);
								!errorIndex++ && scrollToPos($append);
							} else {
								checked = true;
								return false;
							}
						}		
					});	
					
					if(!checked){
						isValidQuestion = false;
						if(ismatrix == "Y") {
							var $af = $q.find("[name="+v+"]:first");
							if(qt == "S" || qt == "M"){
								if(options.dt == "m") {
									$af.parents("table").find("tr>td:first").append(errSpan);
								} else {
									$af.parents("tr").find("td:first").append(errSpan);
								}
							} else {
								$af.parents("td").append(errSpan);
							}
							!errorIndex++ && scrollToPos($af.parent());	
						} else {
							$(errSpan).insertAfter($q.find(".question"));
							!errorIndex++ && scrollToPos($q);							
						}
					}
				
				});
			}
			
			if(!isValidQuestion)
				isValideResult = false;
				
		});		
			
		//常规验证(忽略跳题)
		$("#paperContent .qc:not(.skip) :input[verify='1']").change();
		this.errorIndex > 0 && (isValideResult = false);
		
		//自定义验证
		if(typeof customValidation == "function"){
			customValidation();
			this.errorIndex > 0 && (isValideResult = false);
		}
		
		//离店验证, 常规验证与自定义验证都通过后才会触发离店验证
		if(isValideResult && $("#leaveRemarkText").length == 0 && typeof leaveValidation == "function"){
			!leaveValidation() && (isValideResult = false);
		} else {
			//如果值变更先清空离店验证
			setLeaveRemark(null);
		}

		this.errorIndex = 0;
		this.isValideForm = false;
		
		return isValideResult;
	};	
	
	var isValideFormAndroid = function(){
		var isValide = isValideForm();
		Paper01.isValideForm(isValide);
	};

	//每次离店时都必须重新验证一次逻辑，因为选项或者数值可能会发生变化
	//对于同一个题目id的相关验证放在一起，每次离店时会继承上次填写的备注
	var setLeaveRemark = function(arrTip){
		
		//值变更之后无离店逻辑时清空
		if(!arrTip || arrTip.length == 0) {
			$("#pnlRemark").remove();
			return true;
		};

		var isFirst = false, isValide = true;
		
		if($("#pnlRemark").length == 0){
			//添加离店验证的panel
			$("#paperContent .col-md-12").append('<div class="panel panel-default" id="pnlRemark"><div class="panel-heading"><h3 class="panel-title">离店验证</h3></div><div class="panel-body"></div></div>');
			//初始化时返回验证不通过
			isFirst = true;
			isValide = false;
		}
		
		var html = "";
		
		$.each(arrTip, function(i, v){
			var remarkTextBox = "";
			if(v.nonRigidity){
				remarkTextBox = '<button class="btn btn-default" onclick="$(this).parent().find(\'textarea\').toggle();"><span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 备注</button> '+
								'<textarea maxlength="100" class="form-control hidden2 lr" rows="3" id="alr_'+v.qid+'">'+($('#alr_'+v.qid).val() || "")+'</textarea>';
			}
			
			html += 
				'<div id="qlr_'+v.qid+'" nonRigidity="'+v.nonRigidity+'">'+
					'<label class="control-label question">'+v.title+'</label> '+ 
					'<button class="btn btn-default" onclick="Paper.scrollToQuestion(\''+v.qid+'\');"><span class="glyphicon glyphicon-edit" aria-hidden="true"></span> 修改</button> '+ remarkTextBox +
				'</div>';
		});

		//每次都重新设置html，相同题目id会继承上次填写的值
		$("#pnlRemark .panel-body").html(html);

		//验证是否填写了备注
		if(isFirst){
			scrollToPos($("#pnlRemark"));
		} else {
			//刚性的离店逻辑必须要填写备注
			var $rigidityQuestion = $("#pnlRemark [nonRigidity=false]:first");
			if($rigidityQuestion.length == 1) {
				isValide = false;
				scrollToPos($rigidityQuestion);
			} else {
				$("#pnlRemark textarea").each(function(){
					if(!$(this).val().trim()){
						isValide = false;
						scrollToPos($(this).parent());
						return false;
					}
				});
			}
		}
		
		return isValide;
	};
	
	//设置非刚逻辑备注
	var setAbnormal = function(senderId, remark){
		
		//不可编辑时不能查看非刚备注项
		if(options.pm !='edit' || !remark) return;
		
		setValidationResult($("#"+senderId), "");
		$("#"+senderId).attr("verified","1");
		
		var del = '<button type="button" onclick="$(\'#'+senderId+'\').removeAttr(\'verified\');" class="close" data-dismiss="alert" aria-label="Close" title="删除备注"><span aria-hidden="true">&times;</span></button>';
		
		var html = '<div class="alert alert-warning alert-dismissible" role="alert">'+ del +'<strong>备注：</strong> <span class="abnormal">'+remark+'</span></div>';
		$(html).insertAfter($("#"+senderId));		
	};
	
	//设置离店备注文本
	var setLeaveRemarkText = function(leaveRemark){
		
		//不可编辑时不能查看非刚备注项
		if(options.pm !='edit' || !leaveRemark || leaveRemark == 'null') return;

		var html = '<div class="alert alert-warning alert-dismissible" role="alert">'+
					'<button type="button" class="close" data-dismiss="alert" aria-label="Close" title="删除备注"><span aria-hidden="true">&times;</span></button>'+
					'<strong>离店备注：</strong> <div id="leaveRemarkText">'+leaveRemark+'</div></div>';
		$("#paperContent .col-md-12").append(html);
	};

	//marked表示是否标红着色，默认不传或false表示要着色，单选或多选不需要着色时传递true
	var setValidationResult = function($e, errorMsg, marked){
		if(errorMsg){
			!marked && !$e.hasClass("error") && $e.addClass("error");
			$e.siblings(".help-block-error").html(errorMsg).length == 0 && $("<label class='help-block-error'>"+errorMsg+"</label>").insertAfter($e);
			!this.errorIndex++ && Paper.scrollToPos($e);
		} else {
			!this.isValideForm && $e.removeClass("error").siblings(".help-block-error").remove();
		}			
	};
	
	var getOption = function(key){
		return this.options[key];
	};

    return {
        init: function (options) {
        	handleInit(options);
        },
        getPageList: function(){
        	return getPageList();
        },
        getPageListAndroid: function(){
        	getPageListAndroid();
        },
        showPage: function(pageId){
        	showPage(pageId);
        },
        searchQuestion: function(searchKey){
        	searchQuestion(searchKey);
        },
        getResult: function(){
        	return getResult();
        },
        getResultAndroid: function(){
        	getResultAndroid();
        },
        getLeaveRemark: function(){
        	return getLeaveRemark();
        },
        getLeaveRemarkAndroid: function(){
        	return getLeaveRemarkAndroid();
        },
        isValideForm: function(){
        	return isValideForm();
        },
        isValideFormAndroid: function(){
        	isValideFormAndroid();
        },
        backfillResult: function(resultJson){
        	backfillResult(resultJson);
        },
        backfillResultAndroid: function(resultJson){
        	backfillResultAndroid(resultJson);
        },
        saveData: function(resultId, resultStatus){
        	saveData(resultId, resultStatus);
        },
        setImage: function(questionId, subQuestionId, answerId, filePath){
        	setImage(questionId, subQuestionId, answerId, filePath);
        },
        uploadIconClick: function(questionId, subQuestionId, answerId, type, sender){
        	uploadIconClick(questionId, subQuestionId, answerId, type, sender);    	
        },
        uploadFile: function(sender, type){
        	uploadFile(sender, type);
        },
        removeFile: function(sender){
        	removeFile(sender);
        },
        appShowImage: function(sender){
        	appShowImage(sender);
        },
        goToQuestion: function(sender){
        	goToQuestion(sender);
        },
        removeSearchResult: function(sender){
        	removeSearchResult(sender);
        },
        skipQuestion: function(sender){
        	skipQuestion(sender);
        },
        getQuestionPanel: function(){
        	return getQuestionPanel();
        },
        getQuestionPanelAndroid: function(){
        	getQuestionPanelAndroid();
        },
        getCompletionRate: function(){
        	return getCompletionRate();
        },
        getCompletionRateAndroid: function(){
        	getCompletionRateAndroid();
        },
        scrollToPos: function(target){
        	scrollToPos(target);
        },
        scrollToTop: function(){
        	$('html, body').animate({scrollTop: 0}, 'slow');        	
        },
        scrollToQuestion: function(qid){
        	scrollToQuestion(qid);
        },
        setValidationResult: function($e, errorMsg, marked){
        	setValidationResult($e, errorMsg, marked);
        },
        getOption: function(key){
        	return getOption(key);
        },
        setLeaveRemark: function(arrTip){
        	return setLeaveRemark(arrTip);
        },
        setAbnormal: function(senderId, remark){
        	setAbnormal(senderId, remark);
        },
        setLeaveRemarkText: function(leaveRemark){
        	setLeaveRemarkText(leaveRemark);
        }
    };

}();