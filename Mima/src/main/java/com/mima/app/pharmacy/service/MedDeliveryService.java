package com.mima.app.pharmacy.service;

import com.mima.app.pharmacy.domain.MedDeliveryVO;

public interface MedDeliveryService {

	// K.10/08 약배달 신청
	public int deliveryInsert(MedDeliveryVO vo);
	
	// K.10/09 약배달 신청 한건 조회
	public MedDeliveryVO selectOne(int bookingNo);
}
