<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
				<h1>약국 대쉬보드</h1>
			</div>
		</div>
	</div>
	<div class="lower-content">
		<ul class="bread-crumb clearfix">
			<li><a href="${pageContext.request.contextPath}">Home</a></li>
			<li>약국 대쉬보드</li>
		</ul>
	</div>
</section>
<!--page-title-two end-->  
    
<section class="doctors-dashboard bg-color-3">
	<!-- 사이드 메뉴바 연결 -->
	<div class="left-panel">
		<div class="profile-box">
			<div class="upper-box">
				<figure class="profile-image">
					<img src="${pageContext.request.contextPath}/resources/assets/images/resource/profile-2.png" alt="">
				</figure>
				<div class="title-box centred">
					<div class="inner">
						<h3>${profile.pharmacyInfo}</h3>
						<p>${profile.profileContents}</p>
					</div>
				</div>
			</div>
			<div class="profile-info">
				<ul class="list clearfix">
					<li><a id="dash" href="${pageContext.request.contextPath}/pharmacy/pharmacyDash" ><i
							class="fas fa-columns"></i>대쉬보드</a></li>
					<li><a id="delivery" href="${pageContext.request.contextPath}/pharmacy/medDelivery"><i class="fas fa-ambulance"></i>약배달관리</a></li>
					<li><a id="guid" href="${pageContext.request.contextPath}/pharmacy/medGuid"><i class="fas fa-comment-medical"></i>복약지도관리</a></li>
					<li><a id="revicw" href="${pageContext.request.contextPath}/pharmacy/review"><i class="fas fa-star"></i>약국 후기</a></li>
					<li><a id="ques" href="${pageContext.request.contextPath}/pharmacy/phaQna"><i class="fas fa-comments"></i>문의</a><span>20</span></li>
					<li><a id="profile" href="${pageContext.request.contextPath}/pharmacy/myProfile"><i class="fas fa-user"></i>약국 프로필</a></li>
					<li><a id="pwUpdate" href="${pageContext.request.contextPath}/pharmacy/pwUpdate" class="current"><i
							class="fas fa-unlock-alt"></i>비밀번호 변경</a></li>
					<li><a id="logout" href="login.html"><i class="fas fa-sign-out-alt"></i>로그아웃</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div class="right-panel">
                <div class="content-container">
                    <div class="outer-container">
                        <div class="add-listing change-password">
                            <div class="single-box">
                                <div class="title-box">
                                    <h3>비밀번호 변경</h3>
                                </div>
                                <div class="inner-box">
                                    <form action="add-listing.html" method="post">
                                        <div class="row clearfix">
                                        	<div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                <label>현재 비밀번호</label>
                                                <input type="hidden" name="id" value="${memberId}">
                                                <input type="password" id="password" name="password" >
                                            </div>
                                            <div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                <span class="accept"><i class="fas fa-check"></i>체크</span>
                                            </div>
                                            <div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                <label>새로운 비밀번호</label>
                                                <input type="password" name="password2" required="">
                                            </div>
                                            <div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                
                                            </div>
                                            <div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                <label>새로운 비밀번호 확인</label>
                                                <input type="password" name="password3" required="">
                                            </div>
                                            <div class="col-lg-6 col-md-12 col-sm-12 form-group">
                                                
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="btn-box">
                                <a id="pwUpdateBtn" class="theme-btn-one">비밀번호 변경<i class="icon-Arrow-Right"></i></a>
                                <a class="cancel-btn">취소</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
</section>
<script>
	
	var memberId = $("input[name='id']").val();
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	// 현재 비밀번호 확인
	$("#password").on("change", function(){
		var password = $("input[name='password']").val();
		if(password == ""){
			return;
		}
		$.ajax({
			url : "pwConfirm",
			method : "post",
			dataType : "json",
			data : JSON.stringify({
				memberId : memberId,
				password : password
			}),
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			contentType : 'application/json',
			success : function(data) {
				if(data){
					$('.accept').css("color", "#39cabb");
				}else {
					$('.accept').text("비밀번호가 일치하지 않습니다")
								.css("color","red");
				}
			},// success end
			error : function(xhr, status, message) {
				alert(xhr + " status: " + status + " er:" + message);
			}
		}) //ajax end
	}); // 현재 비밀번호 확인 끝
	
	// 비밀번호 변경 버튼
	$("#pwUpdateBtn").on("click",function(){
		var acceptColor = $('.accept').css("color");
		console.log(acceptColor);
		
		if(acceptColor == rgb(57, 202, 187)){
			alert("성공!");
		} else {
			alert()
		}
		
	});// 비밀번호 변경 버튼 end

</script>