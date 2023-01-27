package egovframework.common.service;

import egovframework.common.dao.CocCommonDAO;
import egovframework.common.vo.CommonHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CocCommomService {
    private static final Logger LOGGER = LoggerFactory.getLogger(CommonService.class);

    @Autowired
    private CocCommonDAO cocCommonDAO;

    /**
     * 세계 대륙 정보
     * 009 코드 포함
     * @param code
     * @return CommonVO
     */
    public List<CommonHashMap<String, Object>> getRelCdList(String code) throws Exception {
         List<CommonHashMap<String, Object>> list = null;
         list = cocCommonDAO.getRelCdList(code);

        return list;
    }


}