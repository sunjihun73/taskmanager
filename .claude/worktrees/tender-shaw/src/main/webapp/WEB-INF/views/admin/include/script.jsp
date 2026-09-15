<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<script src="/adminkit/js/app.js"></script>
<script src="/adminkit/js/datatables.js"></script>
<script src="/adminkit/js/dataTables.treeGrid.js" type="text/javascript"></script>

<!-- spin JS -->
<script src="/adminkit/js/spin.js"></script>

<!-- JSTree -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>

<!-- flatpickr 한글 리소스 -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>

<!-- Common JS -->
<script src="/adminkit/common/common/common.js"></script>

<style>
div.backLayer {display : none; background-color : gray; position : absolute; left : 0px; top : 0px;}
div#loadingDiv {background-color : skyblue; display : none; position : absolute; width : 300px; height : 300px; }
</style>

<div class="backLayer" style=""></div>
<div id="spinner"></div>

<div class="modal fade" id="gMdlCfmDialog" tabindex="-1" role="dialog" aria-hidden="true">
	<div id="gMdlCfmDialogBody" class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">DB TASK MANAGER CONFIRM</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div id="gMdlMsg" class="modal-body m-3">
				<p class="mb-0">Some Message.</p>
			</div>
			<div class="modal-footer">
				<button id="gMdlBtnOk" type="button" class="btn btn-primary">확인</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="gMdlWrnCfmDialog" tabindex="-1" role="dialog" aria-hidden="true">
	<div id="gMdlWrnCfmDialogBody" class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">DB TASK MANAGER CONFIRM</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div id="gMdlWrnMsg" class="modal-body m-3">
				<p class="mb-0">Some Message.</p>
			</div>
			<div class="modal-footer">
				<button id="gWrnMdlBtnOk" type="button" class="btn btn-danger">확인</button>
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<script>
let gDelay_Short = 1000;
let gDelay_Medium = 2500;
let gDelay_Long = 5000;
var gSpinner = null;    // 로딩바 객체 변수
let gCmmnUsrAdmNm = "관리자";
let gCmmnUserNm = "사용자";
let gCmmnDeptNm = "부서";
let gCmmnTaskNm = "태스크";
let gCmmnSM_One = " 이(가) 조회되었습니다."; 
let gCmmnSM_List = " 목록이 조회되었습니다.";
let gCmmnSM_Update = " 이(가) 저장 되었습니다.";
let gCmmnSM_Delete = " 이(가) 삭제 되었습니다.";
let gCmmnSM_FileUp = "파일이 업로드 되었습니다.";
let gCmmnEM_ServiceError = " 서비스에서 오류가 발생하였습니다.<br>일시적인 문제일 수 있습니다.<br>잠시후 다시 시도해 주시기 바랍니다.";
let gCmmnSM_SyncData = "가 동기화 되었습니다.";
let buildNoHtml = "/ <b>Build No.</b> " + gBuildNo;

$("#liBuildNo").html(buildNoHtml);

function gfnShowLoadingBar() {
	let width = $(window).width();
	let height = $(window).height();
	
	$('.backLayer').width(width);
	$('.backLayer').height(height);
	$('.backLayer').fadeTo(300, 0.4);
	
	let opts = {
          lines: 13                // The number of lines to draw
        , length: 18             // The length of each line
        , width: 12             // The line thickness
        , radius: 42             // The radius of the inner circle
        , scale: 1                 // Scales overall size of the spinner
        , corners: 1             // Corner roundness (0..1)
        , color: '#0088cc'         // #rgb or #rrggbb or array of colors
        , opacity: 0.25         // Opacity of the lines
        , rotate: 0             // The rotation offset
        , direction: 1             // 1: clockwise, -1: counterclockwise
        , speed: 1                 // Rounds per second
        , trail: 60             // Afterglow percentage
        , fps: 20                 // Frames per second when using setTimeout() as a fallback for CSS
        , zIndex: 2e9             // The z-index (defaults to 2000000000)
        , className: 'spinner'     // The CSS class to assign to the spinner
        , top: '46%'             // Top position relative to parent
        , left: '41%'             // Left position relative to parent
        , shadow: false         // Whether to render a shadow
        , hwaccel: false         // Whether to use hardware acceleration
        , position: 'absolute'     // Element positioning
    }
	
	let target = document.getElementById("spinner");
    
    if (gSpinner == null) {
    	gSpinner = new Spinner().spin(target);
    }
}

function gfnHideLoadingBar() {
	if (gSpinner != null) {
		gSpinner.stop();
		gSpinner = null;
    }
	$(".backLayer").css("display", "none");
}

function gfnSelectMenu(menuGroupName, menuUlName, menuItemName) {
	$("#" + menuGroupName).addClass("active");
	
	if (menuUlName != "" && menuUlName != null && typeof menuUlName != "undefined") {
		$("#" + menuUlName).addClass("show");
	}

	if (menuItemName != "" && menuItemName != null && typeof menuItemName != "undefined") {
		$("#" + menuItemName).addClass("active");
	}	
}

function gfnSuccessAlert(pMsg, pDelay) {
	var message = pMsg;
	var type = 'success';
	var duration = pDelay;
	var ripple = true;
	var dismissible = true;
	var positionX = 'right';
	var positionY = 'top';
	window.notyf.open({
		type,
		message,
		duration,
		ripple,
		dismissible,
		position: {
			x: positionX,
			y: positionY
		}
	});
}

function gfnFailAlert(pMsg, pDelay) {
	var message = pMsg;
	var type = 'danger';
	var duration = pDelay;
	var ripple = true;
	var dismissible = true;
	var positionX = 'right';
	var positionY = 'top';
	window.notyf.open({
		type,
		message,
		duration,
		ripple,
		dismissible,
		position: {
			x: positionX,
			y: positionY
		}
	});
}

function gfnCheckRequired(frmObj) {
	var title = "";
	var msg = '는(은) 필수 입력값 입니다.';
	var f  = frmObj;
	var $t, t;
	var result = true;
	
	f.find("input, select, textarea").each(function() {
		$t = $(this);
		
		if ($t.prop("required")) {
			if (!$.trim($t.val())) {
				t = $("label[for='"+$t.attr("id")+"']").text();
				result = false;
				$t.focus();
				gfnFailAlert(t + " " + msg, 2500);
				return false;
			}
		}
	});
	
	if (!result)
		return false;
	else
		return true;
}

function fnPostMove(url, param, target) { 
	 if(!target) target = "_self";
	 let form = document.createElement('form'); 
	 let objs = new Array();
	 for(let key in param){ 
	 	let value = param[key]; 
		objs = document.createElement('input'); 
	   	objs.setAttribute('type', 'hidden'); 
	   	objs.setAttribute('name', key); 
	   	objs.setAttribute('value', value); 
	   	form.appendChild(objs); 
	 } 
	 form.setAttribute('target', target);
	 form.setAttribute('method', 'post'); 
	 form.setAttribute('action', url); 
	 document.body.appendChild(form); 
	 form.submit(); 
}

function gfnFormatDate(date, sep) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    return [year, month, day].join(sep);
}

function gfnNoFormatDate(date) {
	let rtvalue = "";
	
	if (date != null && date != "") {
	    let d = new Date(date),
	    month = '' + (d.getMonth() + 1),
	    day = '' + d.getDate(),
	    year = d.getFullYear();

	    if (month.length < 2) 
	        month = '0' + month;
	    if (day.length < 2) 
	        day = '0' + day;

	    rtvalue = [year, month, day].join('');
	}
	else {
		rtvalue = "";
	}
    return rtvalue
}


function gfnYmdFormat(ymd, sep) {
	let rtValue = "";
	
	try {
		if (ymd == null || ymd.length < 8) {
			rtValue = "";
		}
		else {
			let year = ymd.substr(0, 4);
			let mm = ymd.substr(4, 2);
			let dd = ymd.substr(6, 2);
			rtValue = year.toString() + sep + mm.toString() + sep + dd.toString();
		}
	} 
	catch (e) {
		rtValue = "";
	}
	
	return rtValue;
}

function gfnInitCfmMdlDialog(msg, callback) {
	$("#gMdlMsg").html("<i class='fa fa-check'></i>&nbsp;&nbsp;" + msg);

	$("#gMdlBtnOk").off("click").on("click", function(event) {
		event.preventDefault();
		if (typeof callback === "function") {
			callback();
			$("#gMdlCfmDialog").modal("hide");
		}
	});
	
	$("#gMdlCfmDialog").modal("show");
}

function gfnInitWrnCfmMdlDialog(msg, callback) {
	$("#gMdlWrnMsg").html("<i class='fa fa-check'></i>&nbsp;&nbsp;" + msg);

	$("#gWrnMdlBtnOk").off("click").on("click", function(event) {
		event.preventDefault();
		if (typeof callback === "function") {
			callback();
			$("#gMdlWrnCfmDialog").modal("hide");
		}
	});
	
	$("#gMdlWrnCfmDialog").modal("show");
}

function gfnGetCurYM() {
	let rtVal = "";
	let today = new Date();   
	let year = today.getFullYear(); 
	let month = today.getMonth() + 1; 

	if (Number(month) < 10) {
		month = "0" + month;
	}

	rtVal = year + "-" + month; 
	return rtVal;
}

function gfnUnescapeHTML(escapedHTML) {
	return escapedHTML ? escapedHTML.replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&amp;/g,'&').replace(/&quot;/g, '"') : escapedHTML;
}
</script>