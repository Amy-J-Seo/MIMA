package com.mima.app.member.mapper;

import java.util.List;

import com.mima.app.member.domain.PatientsVO;

public interface PatientsMapper {
	
	//e.29
	//관리자 회원정보조회
	public List<PatientsVO> getList();
	
	//s:1004 자가진단표+정보 입력
	public int update(PatientsVO vo);

}
