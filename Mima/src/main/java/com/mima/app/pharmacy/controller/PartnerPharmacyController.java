package com.mima.app.pharmacy.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Base64;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.rowset.serial.SerialException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mima.app.comments.service.CommentsService;
import com.mima.app.criteria.domain.Criteria;
import com.mima.app.criteria.domain.PageVO;
import com.mima.app.meditation.domain.MeditAttachVO;
import com.mima.app.member.domain.MemberVO;
import com.mima.app.member.service.MemberService;
import com.mima.app.pharmacy.domain.MedDeliveryVO;
import com.mima.app.pharmacy.domain.PartnerPharmacyVO;
import com.mima.app.pharmacy.service.MedDeliveryService;
import com.mima.app.pharmacy.service.PatnerPharmacyService;
import com.mima.app.push.domain.PushVO;
import com.mima.app.push.service.PushService;
import com.mima.app.session.domain.BookingVO;
import com.mima.app.session.service.BookingService;

import lombok.extern.java.Log;

@Log
@Controller
@RequestMapping("/pharmacy/*")
public class PartnerPharmacyController {
	
	@Autowired PatnerPharmacyService partPhaService;
	@Autowired MedDeliveryService deliverSerive;
	@Autowired MemberService memberSerivce;
	@Autowired BCryptPasswordEncoder cryptEncoder;
	@Autowired CommentsService commentsService;
	@Autowired PushService pushService;
	@Autowired BookingService bookingService;
	@Autowired MemberService memberService;


	@Value("#{global['path']}")
	String path;
	
	// 약국 대쉬보드 [K]210929 
	@GetMapping("/pharmacyDash")
	public void pharmacyDash(Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		int memberNo = vo.getMemberNo();
		// 약국한건 조회
		model.addAttribute("profile", partPhaService.selectOne(memberNo));
		// 오늘의 배달예약수
		model.addAttribute("cnt", deliverSerive.deliveryCnt(memberNo));
		// 복약지도수
		model.addAttribute("ptEduCnt", deliverSerive.ptEducationCnt(memberNo));
		// 오늘의 약배달 등록 및 취소
		model.addAttribute("delivery", deliverSerive.todayDelivery(vo.getMemberNo()));
		// 리뷰 수
		model.addAttribute("reviewCnt", commentsService.phaReviewCnt(vo.getMemberNo()));
	}
	
	// 약배달 전체관리페이지 [K]210929
	@GetMapping("/mediDelivery")
	public void mediDelivery(Model model, HttpServletRequest request, @ModelAttribute("cri") Criteria cri) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		int memberNo = vo.getMemberNo();
		int total = deliverSerive.phaSelectOneCount(memberNo);
		// 약국 한건 조회
		model.addAttribute("profile", partPhaService.selectOne(memberNo));
		// 약배달 현황
		model.addAttribute("phaDelivery", deliverSerive.phaSelectOne(memberNo,cri));
		model.addAttribute("pageMaker", new PageVO(cri,total));
	}
	
	// 약배달 완료목록 페이지 
	@GetMapping("/comDelivery")
	public void comDelivery(Model model, HttpServletRequest request, @ModelAttribute("cri") Criteria cri) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		int memberNo = vo.getMemberNo();
		int total = deliverSerive.phaCompleteDelCount(memberNo);
		// 약국 한건 조회
		model.addAttribute("profile", partPhaService.selectOne(memberNo));
		// 약배달 완료목록
		model.addAttribute("phaComDelivery", deliverSerive.phaCompleteDel(memberNo,cri));
		model.addAttribute("pageMaker", new PageVO(cri,total));
	}
	
	// 약배달 상태 업데이트
	@PostMapping("/ptEduStatusUpdate")
	@ResponseBody
	public int ptEduStatusUpdate(int bookingNo) {
		return deliverSerive.ptEduStatusUpdate(bookingNo);
	}
	
	// 약배달 상태 업데이트
	@PostMapping("/deliveryStatusUpdate")
	@ResponseBody
	public int deliveryStatusUpdate(MedDeliveryVO vo) {
		return deliverSerive.deliveryStatusUpdate(vo);
	}
	
	// 약배달 취소
	@PostMapping("/delCancel")
	@ResponseBody
	public int delCancel(MedDeliveryVO vo, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO mvo = (MemberVO) session.getAttribute("session");
		int memberNo = mvo.getMemberNo();
		
		// 약배달에서 넘기는 예약번호 환자번호 받아오기
		BookingVO bvo = bookingService.getRoomId(vo.getBookingNo());

		// 약배달 취소 신청시 push 알람에 내용이 저장
		PushVO push = new PushVO();
		push.setToMemberNo(bvo.getPtNo());
		push.setUserMemberNo(memberNo);
		push.setType("phaCancel");
		push.setContentId(vo.getBookingNo());
		push.setMessage(vo.getDeliveryDecline());
		int result = pushService.delCancelAlarm(push);
		// push에 입력 후 med_delivery에 저장
		if (result > 0) {
			result = deliverSerive.delCancel(vo);
		} else {
			result = 0;
		}
		return result; 
	}
	
	// 약배달 등록/취소 페이지
	@GetMapping("/deliveryRegCancel")
	public void deliveryRegCancel(Model model, HttpServletRequest request, @ModelAttribute("cri") Criteria cri) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		int total = deliverSerive.memDeliveryCount(vo.getMemberNo());
		model.addAttribute("profile", partPhaService.selectOne(vo.getMemberNo()));
		model.addAttribute("delivery", deliverSerive.memDelivery(vo.getMemberNo(),cri));
		model.addAttribute("pageMaker", new PageVO(cri,total));
		
	}
	
	// 복약지도 관리페이지 [K]210929
	@GetMapping("/medGuid")
	public void medGuid(Model model, HttpServletRequest request, @ModelAttribute("cri") Criteria cri) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		int total = deliverSerive.ptEducationCnt(vo.getMemberNo());
		model.addAttribute("profile", partPhaService.selectOne(vo.getMemberNo()));
		model.addAttribute("ptEducation",deliverSerive.ptEducation(vo.getMemberNo(),cri));
		model.addAttribute("pageMaker", new PageVO(cri,total));
		
	}
	
	
		
	// 프로필 페이지 [K]210929
	
	@GetMapping("/myProfile") 
	public void myProfile(Model model,HttpServletRequest request) { 
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session"); 
		int memberNo = vo.getMemberNo(); 
		model.addAttribute("profile",partPhaService.selectOne(memberNo)); 
	}
		
	
	// 프로필 수정 - ajax [K]210929
	@PutMapping("/profileUpdate")
	@ResponseBody
	public int profileUpdate(@RequestBody PartnerPharmacyVO vo, Model model ) {
		return partPhaService.profileUpdate(vo);
	}
	
	// 리뷰페이지 [K]210929
	@GetMapping("/review")
	public void review(Model model, HttpServletRequest request, @ModelAttribute("cri") Criteria cri) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		model.addAttribute("profile", partPhaService.selectOne(vo.getMemberNo()));
		model.addAttribute("review", commentsService.phaReviewList(cri,vo.getMemberNo()));
		model.addAttribute("reviewCnt", commentsService.phaReviewCnt(vo.getMemberNo()));
		model.addAttribute("pageMaker", new PageVO(cri,commentsService.phaReviewCnt(vo.getMemberNo())));
	}
	
	// 문의페이지 [K]211006
	@GetMapping("/phaQna")
	public void phaQna() {}

	// 비밀번호 변경페이지 [K]210929
	@GetMapping("/pwUpdate")
	public void pwConfirmPage(Model model, HttpServletRequest request) {
		HttpSession session = request.getSession();
		MemberVO vo = (MemberVO) session.getAttribute("session");
		model.addAttribute("memberId", vo.getMemberId());
		model.addAttribute("profile", partPhaService.selectOne(vo.getMemberNo()));
	}
	
	// 현재 비밀번호 확인페이지 [K]10.12s
	@PostMapping("/pwConfirm")
	@ResponseBody
	public boolean pwConfirm(MemberVO vo,HttpServletRequest request) {
		String password = vo.getPassword();
		String memberId = vo.getMemberId();
		MemberVO pass = memberSerivce.findPassword1(memberId);
		
		Boolean matchPass = cryptEncoder.matches(password, pass.getPassword()); //비교
		
		System.out.println(matchPass);
		
		return matchPass;
	}
	
	// 닥터 비밀번호 변경 p.10/12
	@PostMapping("updatePassword")
	@ResponseBody
	public int updatePassword(MemberVO vo) {
		vo.setPassword(cryptEncoder.encode(vo.getPassword()));
		int result = memberSerivce.updatePassword(vo);
		return result;
	}
	
	
	//K.10/11 약국프로필등록
	@PostMapping("/register")
	public String register(HttpServletRequest request, PartnerPharmacyVO vo, MemberVO mVo, MultipartFile[] uploadFile, RedirectAttributes rttr) {
		log.info("파트너 약국 컨트롤러-> 인서트// 등록할때 보 보는거임======" + vo);
		//K.10/11 파트너약국테이블에 저장
		partPhaService.profileUpdate(vo);
		
		HttpSession session = request.getSession();
		MemberVO msvo = (MemberVO) session.getAttribute("session"); 
		log.info("**************msvo********" + msvo);
		
		//K.10/11 멤버 테이블 주소 업데이트
		mVo.setAddr1(vo.getDeliveryArea());
		mVo.setAddr2(vo.getDeliveryArea2());
		mVo.setAddr3(vo.getDeliveryArea3());
		mVo.setPostcode(vo.getPharmacyPostCode());
		mVo.setMemberNo(vo.getMemberNo());
		partPhaService.phaAddrUpdate(mVo);
		
		// 단건 조회후 세션에 다시 담아줌
		MemberVO mvo = memberService.getUserById(msvo.getMemberId());
		request.getSession().setAttribute("session", mvo);
		
		log.info("파트너 약국 컨트롤러-> 멤버테이블 주소 업뎃 보 보는거임======" + mVo);
		
		rttr.addFlashAttribute("result", vo.getMemberNo());
		return "redirect:/pharmacy/pharmacyDash"; // 파라미터 전달하고 싶을 때 redirectAttr사용
	} 
	
	//K.10/11 첨부파일 등록 폼-- 약국 프로필사진
	@PostMapping("/phaAjaxInsert")
	@ResponseBody
	// 업로드 폼에서 인풋에서 타입이 파일이기 때문에 멀티파트파일로 주고 그 네임을 찾아서 여기 업로드파일 변수에 담아줌
	public MeditAttachVO docAjaxInsert(MultipartFile uploadFile, MeditAttachVO vo)
			throws IllegalStateException, IOException {
		MeditAttachVO attachVo = null;

		MultipartFile uFile = uploadFile;
		if (!uFile.isEmpty() && uFile.getSize() > 0) {
			String filename = uFile.getOriginalFilename(); // 사용자가 업로드한 파일명

			// 파일 자체도 보안을 걸기 위해 파일이름 바꾸기도 한다. 원래 파일명과 서버에 저장된 파일이름을 따로 관리
			// String saveName = System.currentTimeMillis()+""; //이거를 팀별로 상의해서 지정해 주면 된다.
			// File file =new File("c:/upload", saveName);
			UUID uuid = UUID.randomUUID();
			File file = new File(path, uuid + filename);
			uFile.transferTo(file);

			attachVo = new MeditAttachVO(); // attachVO list안에 파일정보 저장하기 위해 만듦
			attachVo.setPImgName(filename);
			attachVo.setUuid(uuid.toString());
			attachVo.setUploadPath(path);

			System.out.println(attachVo);
		}
		return attachVo;
	}
	
	
	//제은이꺼 훔쳐옴 의사 리스트 프로필 이미지 불러오기
	@RequestMapping(value = "/pharmacy/FileDown.do")
	public void cvplFileDownload(@RequestParam Map<String, Object> commandMap, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		log.info("파일 다운로드 커맨드맵 이미지"+commandMap.toString());
		File uFile = new File(path, (String)commandMap.get("fname"));
		
		long fSize = uFile.length();
		if (fSize > 0) {
			String mimetype = "application/x-msdownload";
			response.setContentType(mimetype);

			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			try {
				in = new BufferedInputStream(new FileInputStream(uFile));
				out = new BufferedOutputStream(response.getOutputStream());
				FileCopyUtils.copy(in, out);
				out.flush();
			} catch (IOException ex) {
				ex.printStackTrace();
			} finally {
				in.close();
				response.getOutputStream().flush();
				response.getOutputStream().close();
			}
		} 
	}//제은이꺼 훔쳐옴 의사 리스트 프로필 이미지 불러오기 끝
	
	

	
	
	
	/*
	 * @RequestMapping("/pharmacyApi") public void pharmacyApi() throws IOException
	 * {
	 * 
	 * String url
	 * ="http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyFullDown";
	 * String serviceKey =
	 * "kOfUtJpoB2nNx7jaI6XEcYuKUkswBceaC1lOvwdoLaEHRjjQvgNkQwOs%2Fh3MhO%2FWHv8%2BuL0zs6LKHuXP%2Bs2qhQ%3D%3D";
	 * String decodeServiceKey = URLDecoder.decode(serviceKey,"UTF-8"); String
	 * pageNo = "1"; String numbOfRows = "23414";
	 * 
	 * try { Document documentInfo = DocumentBuilderFactory.newInstance()
	 * .newDocumentBuilder() .parse(url + "?serviceKey=" + serviceKey + "&pageNo="+
	 * pageNo + "&numOfRows=" + numbOfRows);
	 * 
	 * documentInfo.getDocumentElement().normalize();
	 * 
	 * // 파싱 NodeList nList = documentInfo.getElementsByTagName("item"); for(int
	 * temp=0; temp < nList.getLength(); temp++) { Node nNode = nList.item(temp);
	 * if(nNode.getNodeType() == Node.ELEMENT_NODE) { Element eElement = (Element)
	 * nNode; System.out.println("약국주소:"+getTagValue("dutyAddr",eElement));
	 * 
	 * System.out.println("약국주소:"+getTagValue("dutyTel1",eElement));
	 * System.out.println("좌표1:"+getTagValue("wgs84Lat",eElement));
	 * System.out.println("좌표2:"+getTagValue("wgs84Lon",eElement)); } } } catch
	 * (Exception e) { e.printStackTrace(); }
	 */

		
        
        
        /*<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <response>
        	<header>
        		<resultCode>00</resultCode>
        		<resultMsg>NORMAL SERVICE.</resultMsg>
        	</header>
        	<body>
        		<items>
        			<item>
        				<dutyAddr>대전광역시 동구 계족로 362, 성남약국 1층 (성남동)</dutyAddr>
        				<dutyName>성남약국</dutyName>
        				<dutyTel1>042-672-2957</dutyTel1>
        				<dutyTime1c>1900</dutyTime1c>
        				<dutyTime1s>0900</dutyTime1s>
        				<dutyTime2c>1900</dutyTime2c>
        				<dutyTime2s>0900</dutyTime2s>
        				<dutyTime3c>1900</dutyTime3c>
        				<dutyTime3s>0900</dutyTime3s>
        				<dutyTime4c>1900</dutyTime4c>
        				<dutyTime4s>0900</dutyTime4s>
        				<dutyTime5c>1900</dutyTime5c>
        				<dutyTime5s>0900</dutyTime5s>
        				<dutyTime6c>1300</dutyTime6c>
        				<dutyTime6s>0900</dutyTime6s>
        				<hpid>C1601311</hpid>
        				<postCdn1>345</postCdn1>
        				<postCdn2>90 </postCdn2>
        				<rnum>1</rnum>
        				<wgs84Lat>36.3444243564852</wgs84Lat>
        				<wgs84Lon>127.434066050389</wgs84Lon>
        			</item>
        		</items>
	        	<numOfRows>3</numOfRows>
	        	<pageNo>1</pageNo>
	        	<totalCount>23413</totalCount>
        	</body>
        </response>
        */
        
        
//	}

//	private String getTagValue(String tag, Element eElement) {
//		// TODO Auto-generated method stub
//		NodeList nlList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
//		Node nValue = (Node) nlList.item(0);
//		if(nValue == null) return null;
//		return nValue.getNodeValue();
//	}
	

	
	
	
	
}
