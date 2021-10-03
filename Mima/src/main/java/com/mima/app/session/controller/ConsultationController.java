package com.mima.app.session.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mima.app.member.domain.MemberVO;
import com.mima.app.session.domain.BookingVO;
import com.mima.app.session.domain.ConsultationVO;
import com.mima.app.session.domain.PtInfoVO;
import com.mima.app.session.service.BookingService;
import com.mima.app.session.service.ConsultationService;

import lombok.extern.java.Log;


@Log
@CrossOrigin("*")
@Controller
@RequestMapping("/consultation/*")
public class ConsultationController {

	@Autowired ConsultationService consultationService;
	//s:1003
	@Autowired BookingService bookingService;
	
	//s:0930 진료 시작 테스트 페이지로 이동
	@GetMapping("/consultationStart2")
	public void consultationStart2(Model model, BookingVO vo) {
		model.addAttribute("bookingNo", vo);
	}
	
	//s:0929 진료 시작 테스트 페이지로 이동
		@GetMapping("/consultationStart")
		public void consultationStart(Model model, BookingVO vo) {
			//나중에 예약 번호를 넘겨줄 거예요
		}
		
		//s:1003 자가검진 페이지
		@GetMapping("/preSelfAssessment")
		public void preSelfAssessment(Model model, BookingVO vo, ConsultationVO consultationVo) {
			
		}

		//노드 화상진료에서 환자 정보 조회시
	@GetMapping("/ptInformation")
	public void ptInformation(Model model, BookingVO vo, PtInfoVO ptVo) {
		ptVo=consultationService.getPtInformation(vo);
		System.out.println(ptVo);
		model.addAttribute("pt", ptVo);
	}
	
	
	// s:1003 노드에서 요청해서 예약기록 조회
	@GetMapping("/getBookingInfo")
	@ResponseBody
	public BookingVO getBookingInfo(BookingVO vo, MemberVO memberSessionVo, HttpServletRequest requset) {
		
//		HttpSession session = requset.getSession();
//	      log.info(session.getAttribute("session").toString());
//	      MemberVO mvo = (MemberVO) session.getAttribute("session");
//	      log.info(mvo.getName());
		
		vo=bookingService.getBookingInfo(vo);
		return  vo;
	}
	
}
