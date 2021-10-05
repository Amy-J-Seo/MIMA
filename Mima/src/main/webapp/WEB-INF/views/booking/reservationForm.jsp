<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- placeholder 및 input date, time 태그에 사용할 스타일 추가 p.01 -->
<style>
.good-date {
	height: 44px;
    border: 1px solid #e5eded !important;
    border-radius: 30px;
    padding: 3px 20px;
    width : 75%;
    color: #061a3a;
    font-size: 14px;
    font-weight: 500;
}

.good-select {
	height: 44px;
    border: 1px solid #e5eded !important;
    border-radius: 30px;
    padding: 3px 20px;
    width: 75%;
    color: #061a3a;
    font-size: 14px;
    font-weight: 500;
}

input[type="date"]::before {
	content:attr(data-placeholder);
	width: 100%;
}

input[type="date"]:focus::before,
input[type="date"]:valid::before {
	display : none;
}

input[type="time"]::before {
	content:attr(data-placeholder);
	width: 100%;
}

input[type="time"]:focus::before,
input[type="time"]:valid::before {
	display : none;
}


</style>

<!--page-title-two-->
<section class="page-title-two">
	<div class="title-box centred bg-color-2">
		<div class="pattern-layer">
			<div class="pattern-1"
				style="background-image: url(${pageContext.request.contextPath}/resources/assets/images/shape/shape-70.png);"></div>
			<div class="pattern-2"
				style="background-image: url(${pageContext.request.contextPath}/resources/assets/images/shape/shape-71.png);"></div>
		</div>
		<div class="auto-container">
			<div class="title">
				<h1>진료 예약</h1>
			</div>
		</div>
	</div>
	<div class="lower-content">
		<div class="auto-container">
			<ul class="bread-crumb clearfix">
				<li><a href="">Home</a></li>
				<li>진료 예약</li>
			</ul>
		</div>
	</div>
</section>
<!--page-title-two end-->


<!-- appointment-section -->
<section class="appointment-section bg-color-3">
	<div class="auto-container">
		<div class="row clearfix">
			<div class="col-lg-12 col-md-12 col-sm-12">
				<div class="appointment-information">
					<div align="center" class="title-box">
						<h3>진료 예약(medical appointment)</h3>
						<div id="resTime"></div>
					</div>
					<div class="inner-box">
						<div class="single-box">
							<div class="information-form">
								<form id="frm" name="frm">
									<div class="row clearfix">
									
										<div class="col-lg-12 col-md-12 col-sm-12 form-group">
											<label>의사</label>
											<div class="select-box">
												<select class="good-select wide" id="doctorSelect" name="doctorSelect">
													<option data-display="의사를 선택해주세요">의사를 선택해주세요</option>
													<c:forEach items="${doctors}" var="doc">
														<option value="${doc.memberNo}">Dr. ${doc.name}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									
										<div class="col-lg-12 col-md-12 col-sm-12 form-group">
											<label>진료 날짜</label> 
											<input type="date" id="date" name="date" class="good-date"
												data-placeholder="진료 받고 싶은 날을 정해주세요" required="required">
											<button type="button" id="selecttime" name="selecttime" class="theme-btn-one">조회</button>
										</div>
										
										<div class="col-lg-12 col-md-12 col-sm-12 form-group">
											<label>진료 시간</label> 
											<div id="addTime"></div>
										</div>
										<div class="col-lg-12 col-md-12 col-sm-12 form-group">
											<div id="firstCheck"></div>
										</div>
										<div align="center" class="col-lg-12 col-md-12 col-sm-12 form-group">
											<button type="button" id="checkTime" name="checkTime" 
												class="theme-btn-one" style="width: 45%;">
												진료 예약 체크
											</button>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<!-- appointment-section end -->

<script>
	
	$(function() {
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$("#selecttime").on("click", function() {
			
			var week = new Array('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT');
			var date = $("#date").val();
			var today = new Date(date).getDay();
			var day = week[today];
			var docNo = $("#doctorSelect option:selected").val();
			console.log(day);
			console.log(docNo);
			
			$.ajax({
				url : "selectDocTime",
				type : "post",
				beforeSend : function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data : JSON.stringify({day : day,
									docNo : docNo}),
				contentType : "application/json",
				success : function(data){
					console.log(data);
					$("#addTime").empty();
					$("#firstCheck").empty();
					
					for (i = 0; i < data.length; i++){
						console.log(data[i]);
						//makediv(data[i], i);
						$("#addTime").append(makediv(data[i], i));
					}
					$("#firstCheck").append(firstCheck());
				},
				error : function(reject){
					console.log(reject);
				}
			});
		});
		
		// 진료 가능 시간 추가 p.1003
		function makediv(time, i){
			let hTag = $("<h3 />").css("display", "inline");
			let aTag = $("<a />")
					.addClass("mx-3")
					.addClass("fs-3")
					.attr("id","checkDocTime"+i)
					.click(checkTime)
					.attr("href", "#")
					.text(time);
					
			$(hTag).append(aTag);
			
			return hTag;
		}
		
		// 첫 진료 여부 체크 박스 추가 p.10/05
		function firstCheck(){
			return "<h3>Are You a New Patient?</h3>"
				 + "<div class='custom-check-box'>"
				 + "	<div class='custom-controls-stacked'>"
				 + "		<label class='custom-control material-checkbox'>"
				 + "			<input type='checkbox' class='material-control-input' "
				 + "				id='chooseFirst' name='chooseFirst' value='y'>"
				 + "			<span class='material-control-indicator'></span> "
				 + "			<span class='description'>"+"Yes i have seen this doctor before"+"</span>"
				 + "		</label>"
				 + "		<label class='custom-control material-checkbox'>"
				 + "			<input type='checkbox' class='material-control-input'"
				 + "				id='chooseFirst' name='chooseFirst' value='n'>"
				 + "			<span class='material-control-indicator'></span>"
				 + "			<span class='description'>No i am a new patient</span>"
				 + "		</label>"
				 + "	</div>"
				 + "</div>"
		}
		
		// 진료 예약 아래에 시간 확인 용 추가 코드 p.10/05 
		function checkTime(e){
			e.preventDefault();
			
			// div 자식요소 삭제 
			$("#resTime").empty();
			
			var resTime = $(this).text();
			var date = $("#date").val();
			
			date = new Date(date);
			
			var year = date.getFullYear();	// 년도
			var month = date.getMonth();	// 월
			var day = date.getDate();		// 일
			
			var time = year + "년 " + month + "월 " + day + "일"
			console.log(resTime);
			console.log(date);
			
			let hTag = $("<h4/>").addClass("mt-3")
								 .css("color", "white");
			let sTag = $("<span/>").text(time + " " + resTime);
			$(hTag).append(sTag);
			$("#resTime").append(hTag);
		}
		
		// 체크 박스 하나만 클릭 p.10/05
		$(document).on("click", 'input[type="checkbox"][name="chooseFirst"]', function(){
			
			// 체크박스가 클릭 되었을 때
			if($(this).prop('checked')){
				
				$('input[type="checkbox"][name="chooseFirst"]').prop('checked', false);
				$(this).prop('checked', true);
			}
		});
		
	});
	
</script>