<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
Date nowTime = new Date();
SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");
%>


<style>
.team-block-three .inner-box .image-box .textBox {
	position: absolute;
	left: 1px;
	display: inline-block;
	width: 100%;
	height: 100%;
	line-height: 100%;
	text-align: center;
	z-index: 0.5;
}

.team-block-three .inner-box .image-box .textBox div {
	position: relative;
	display: inline-block;
	padding: 0 50px;
	top: 45%;
	text-align: center;
	z-index: 1;
}

.clinic-section {
	padding: 20px 0px 20px 0px;
}

.team-block-three .inner-box {
	box-shadow: none;
}

.modal {
	display: none; /* Hidden by default */
	position: fixed; /* Stay in place */
	z-index: 2; /* Sit on top */
	left: 0;
	top: 0;
	width: 100%; /* Full width */
	height: 100%; /* Full height */
	overflow: auto; /* Enable scroll if needed */
	background-color: rgb(0, 0, 0); /* Fallback color */
	background-color: rgba(0, 0, 0, 0.4); /* Black w/ opacity */
}

/* Modal Content/Box */
.modal-content {
	background-color: #fefefe;
	margin: 15% auto; /* 15% from the top and centered */
	padding: 20px;
	border: 1px solid #888;
	width: 400px; /* Could be more or less, depending on screen size */
	height: 40%;
	box-sizing: none;
}

.accept {
	position: relative;
	display: inline-block;
	font-size: 15px;
	font-weight: 500;
	line-height: 20px;
	padding: 9px 20px;
	background: #ebfaf8;
	border-radius: 25px;
	float: right;
	margin-right: 10px;
	color: #39cabb;
}

.cancel {
	position: relative;
	display: inline-block;
	font-size: 15px;
	font-weight: 500;
	line-height: 20px;
	padding: 9px 21.5px;
	background: #ffeeec;
	border-radius: 25px;
	margin-right: 30px 10px;
	color: #fe5948;
}

.pallet {
	width: 295px;
	height: 250px;
}

.active {
	outline: 1px solid black;
}

.colorBox {
	width: 20px;
	height: 20px;
	float: left;
	margin: 1px 1px 0px 0px;
	cursor: pointer;
}

.team-block-three .inner-box .image-box a:hover {
	background: #eaf8f6;
}
</style>

<div class="boxed_wrapper">


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
					<h1>그린 포스트잇</h1>
				</div>
			</div>
		</div>
		<div class="lower-content">
			<div class="auto-container">
				<ul class="bread-crumb clearfix">
					<li><a href="index.html">Home</a></li>
					<li>그린 포스트잇</li>
				</ul>
			</div>
		</div>
	</section>
	<!--page-title-two end-->


	<div class="select-field bg-color-3">
		<div class="auto-container">
			<div class="row clearfix">
				<div class="col-lg-12 col-md-12 col-sm-12 content-side">
					<div class="item-shorting clearfix">
						<div class="left-column pull-left">
							<h3>오늘 하루는 어땠나요? 😃</h3>
						</div>
						<div class="right-column pull-right clearfix">
							<div class="short-box clearfix">
								<div class="select-box">
									<p id="nowTimes"></p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>


	<!-- clinic-section -->
	<section class="clinic-section">
		<div class="auto-container">
			<div class="row clearfix">
				<div class="col-lg-12 col-md-12 col-sm-12 content-side">
					<!-- 리스트 출력 방식  -->
					<div class="content-box clearfix">
						<ul class="select-box ">
							<li>
								<div class="single-checkbox">
									<input type="radio" name="check-box" id="check1"> <label
										for="check1"><span></span>Latest</label>
								</div>
							</li>
							<li>
								<div class="single-checkbox">
									<input type="radio" name="check-box" id="check2"> <label
										for="check2"><span></span>Random</label>
								</div>
							</li>
						</ul>
						<!-- 등록버튼 -->
						<div class="right-column pull-right clearfix">
							<div class="btn-box">
								<a class="theme-btn-one" id="insertBtn"> <i
									class="icon-image"></i> 등록
								</a>
							</div>
						</div>
					</div>

					<br>
					<div class="wrapper grid">

						<div class="clinic-grid-content grid-item">
							<div class="row clearfix postContents">
								<!-- 메모 내용 -->

							</div>
						</div>
					</div>
					<div></div>
					<div class="pagination-wrapper">
						<ul class="pagination">
							<li><a href="clinic-1.html" class="current">1</a></li>
							<li><a href="clinic-1.html">2</a></li>
							<li><a href="clinic-1.html">3</a></li>
							<li><a href="clinic-1.html"><i class="icon-Arrow-Right"></i></a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- clinic-section end -->

	<!-- The Modal -->
	<div id="myModal" class="modal">

		<!-- Modal content -->
		<div id="box" class="modal-content box">
			<p style="text-align: center;">
				<span style="font-size: 14pt;"><b><span
						style="font-size: 16pt;">포스트잇 등록</span></b></span>
			</p>
			<form name="insert"
				style="padding-bottom: 10px; padding-top: 10px; height: 200px;">
				<textarea id="contents" name="contents"
					style="background-color: transparent; line-height: 1.5; width: 100%; height: 170px;"></textarea>
				<br />
			</form>
			<div style="cursor: pointer; flex-direction: none;">
				<span id="palletBox" class="pallet"></span> <span
					class="accept insertBtn" style="float: right;"><i
					class="fas fa-check"></i></span> <span class="cancel closeBtn"
					style="float: right;"><i class="fas fa-times"></i></span>
			</div>
		</div>
	</div>
	<!--End Modal-->


	<!--Scroll to top-->
	<button class="scroll-top scroll-to-target" data-target="html">
		<span class="fa fa-arrow-up"></span>
	</button>
</div>

<script>
	var CurrentNo = 30; // 현재 회원번호 
	
	document.addEventListener("DOMContentLoaded", function() {



        // 시간을 딜레이 없이 나타내기위한 선 실행

        realTimer();



        // 이후 0.5초에 한번씩 시간을 갱신한다.

        setInterval(realTimer, 500);

    });



    // 시간을 출력

    function realTimer() {

		const nowDate = new Date();

		const year = nowDate.getFullYear();

		const month= nowDate.getMonth() + 1;

		const date = nowDate.getDate();

		const hour = nowDate.getHours();

		const min = nowDate.getMinutes();

		const sec = nowDate.getSeconds();

		document.getElementById("nowTimes").innerHTML = 

                  year + "-" + addzero(month) + "-" + addzero(date) + "&nbsp;" + hour + ":" + addzero(min) + ":" + addzero(sec);

	}



        // 1자리수의 숫자인 경우 앞에 0을 붙여준다.

	function addzero(num) {

		if(num < 10) { num = "0" + num; }

 		return num;

	}
	
	$(function() {
		postList();

		// 모달창 띄우기
		$("#insertBtn").on("click", function() {
			$('#myModal').show();

			insert.contents.focus();

			$(".closeBtn").on("click", function() {
				$('#myModal').hide();
				modalReset();
			});

		})// 모달창 버튼 end

		postInsert(); // 등록

	}); //end

	// 좋아요 클릭시
	$(document).on("click", ".heartIcon", function() {
		var heart = $(this);
		var postNo = $(this).closest('#post').data("postno");
		var memberNo = $(this).closest('#post').data("memberno");
		var urlJuso;
						
		if (heart.css("background-color") == "rgb(6, 26, 58)") {
			urlJuso = "updateNotLike";
			$.ajax({
				url : "likesDelete",
				method : "delete",
				dataType : "json",
				data : JSON.stringify({
					likeMainNo : postNo,
					memberNo : CurrentNo
				}),
				contentType : 'application/json',
				success : function(data) {
					console.log("Likes_기록취소_성공");
					
				}// success end
			}); //  ajax end
			
		} else {
			urlJuso = "updateLike";
			$.ajax({
				url : "likesInsert",
				method : "post",
				dataType : "json",
				data : JSON.stringify({
					likeMainNo : postNo,
					memberNo : CurrentNo
				}),
				contentType : 'application/json',
				success : function() {
					console.log("Likes 기록입력 성공!!");
				}// success end
			}); //  ajax end
		}
		
		console.log(urlJuso);
		console.log("===========좋아요 수==========");
		$.ajax({
			url : urlJuso,
			method : "put",
			dataType : "json",
			data : JSON.stringify({
				postNo : postNo
			}),
			contentType : 'application/json',
			success : function() {
				if (urlJuso == "updateLike") {
					console.log("좋아요_성공")
					alert("좋아요 성공!!");
					heart.css("background-color", "#061a3a");
				} else {
					console.log("좋아요_취소_성공")
					alert("좋아요 취소!!");
					heart.css("background-color", "#eaf8f6");
				}
			}// success end
		})
		//  ajax end
	})// heartIcon end

	// 신고 클릭시
	$(document).on("click", ".angryIcon", function() {
		var angry = $(this);
		var urlJuso;
		var reportNo;
		var postNo = $(this).closest('#post').data("postno");
		var memberNo = $(this).closest('#post').data("memberno");

		// 신고한 건수 확인
		$.ajax({
			url : "reportConfirm",
			method : "post",
			dataType : "json",
			data : JSON.stringify({
				reportMNo : CurrentNo,
				postNo : postNo
			}),
			contentType : 'application/json',
			success : function(data) {
				if (data.report) {
					var test = confirm("신고한 내역이 있습니다. 취소할까요?") // 신고내역 확인
					if ( test == false) {
						return;
					} else {
						urlJuso = "delete/" + data.report.reportNo;
						$.ajax({
							url : urlJuso,
							method : "delete",
							dataType : "json",
							contentType : 'application/json',
							success : function(data) {
								console.log("신고_취소_성공");
								alert("신고 취소!!");
								angry.css("background-color", "#eaf8f6");
							}// success end
						}); //  ajax end
					}
				} else {
					urlJuso = "angryUpdate";
					$.ajax({
						url : urlJuso,
						method : "post",
						dataType : "json",
						data : JSON.stringify({
							postNo : postNo,
							memberNo : memberNo,
							reportMNo : CurrentNo
						}),
						contentType : 'application/json',
						success : function() {
							alert("신고 성공!!");
							angry.css("background-color", "#061a3a");
 						}// success end
					}); //  ajax end
				}
			},
			error : function() {
				console.log("error");
			}
		}); // 신고건수 확인 ajax end

	});// angryIcon end

	// 모달 리셋
	function modalReset() {
		$("#contents").val("");
		$("#box").css("background-color", "#fff");
	}

	// 포스트 등록
	function postInsert() {
		$(".insertBtn").on("click", function() {
			if ($("#contents").val() == "") {
				alert("내용을 입력하세요!")
				return;
			}
			$.ajax({
				url : "postInsert",
				method : "post",
				dataType : "json",
				data : JSON.stringify({
					memberNo : CurrentNo,
					contents : $("#contents").val(),
					postColor : $(".pallet").find(".active").data("img")
				}),
				contentType : 'application/json',
				success : function(data) {
					postList();
					$('#myModal').hide();
					modalReset();
				},// success end
				error : function(xhr, status, message) {
					alert(xhr + " status: " + status + " er:" + message);
				}
			}) //ajax end	
		})
	} // 포스트 등록 end

	//페이지 목록 조회
	function postList() {
		var angryStr ='';
		var heartStr ='';
		$.ajax({
			url : "postList",
			method : "get",
			data : {
				reportMno : CurrentNo,
			},
			contentType : 'application/json',
			success : function(datas) {
				$(".postContents").empty();
				$.each(datas,function(i, data) {
					if(data.reportMno == 1){ angryStr = 'background-color: #061a3a;'; }else {
						angryStr = '';
					}
					if(data.likesNo == 1){ heartStr = 'background-color: #061a3a;'; }else {
						heartStr = '';
					}
					$("<div id='post' data-postNo='"+data.postNo+"' data-memberNo='"+data.memberNo+"' class='col-lg-4 col-md-6 col-sm-12 team-block'>")
						.append(
							"<div class='team-block-three'>"
							+ '<div class="inner-box">'
							+ '<figure class="image-box">'
							+ '<img src="${pageContext.request.contextPath}/resources/assets/images/post/'+data.postColor+'" alt=""> '
							+ '<a class="heartIcon" style="'+ heartStr +'"><i class="far fa-heart"></i></a>'
							+ '<a class="angryIcon" style="top: 20px; right: 70px;'+ angryStr +'"><i class="far fa-angry"></i></a>'
							+ '<div class="textBox">'
							+ '<div><h4>'
							+ data.contents
							+ '</h4></div>'
							+ '</div></figure></div></div>')
						.appendTo($(".postContents"));
						
					}); // each end
					
			} // success end
		}) //ajax end
	} // 페이지목록 조회 end
	

	var beforeColor; //이전에 선택된 컬러 저장 할 변수	

	//HTML 로딩이 끝난 후
	window.onload = function() {
		init();
	}

	function init() {
		// 배열 파레트 데이터
		var pallet = [ "#f4ddda", "#f5f4d6", "#dfe5da", "#dde3e2", "#ebebeb",
				"#e7dbed" ];
		var postColor = [ "redPost.png", "yellow.png", "green.png",
				"blueGray.png", "purpleGray.png", "purple.png" ];
		var tag = "";
		for (i = 0; i < pallet.length; i++) {
			tag += "<div id='" + pallet[i] + "' data-img='" + postColor[i]
					+ "' class='colorBox' onclick='colorSet(this)'></div>";
		}
		//파레트 파싱
		document.getElementById("palletBox").innerHTML = tag;

		//색상 입히기
		var colorBox = document.getElementsByClassName("colorBox");
		for (i = 0; i < colorBox.length; i++) {
			colorBox[i].style.background = colorBox[i].id;
		}
	}

	// onclick event
	function colorSet(target) {
		document.querySelector("#box").style.background = target.id;

		if (beforeColor != undefined && beforeColor != null) {
			document.getElementById(beforeColor).className = document
					.getElementById(beforeColor).className.replace(" active",
					"");
		}
		document.getElementById(target.id).className += " active";
		beforeColor = target.id;

		console.log(beforeColor);
	}
</script>



