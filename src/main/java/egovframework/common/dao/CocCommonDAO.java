package egovframework.common.dao;

import egovframework.common.vo.CommonHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class CocCommonDAO extends CommonDAO {
    private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());


    public List<CommonHashMap<String, Object>> getRelCdList(String code) throws Exception {
        return selectList("CocCommonSQL.getRelCdList", code);
    }

    /**
     * MTI 정보
     * @param code
     * @return String
     * @throws Exception
     */
    public String codeMtiName(String code) throws Exception {
        return selectOne("CocCommonSQL.codeMtiName", code);
    }

    /**
     * CTR 정보
     * @param code
     * @return String
     * @throws Exception
     */
    public String codeCtrName(String code) throws Exception {
        return selectOne("CocCommonSQL.codeCtrName", code);
    }


    /**
     * 첨부파일 시퀀스 정보
     *
     * @return String
     * @throws Exception
     */
    public int getAttachDocumId() throws Exception{
        return selectOne("CocCommonSQL.getAttachDocumId");
    }

    /**
     * 첨부파일 삭제
     * @param fileId
     * @param fileSeq
     * @throws Exception
     */
    public void deleteFile(String fileId, String fileSeq) throws Exception{
        Map<String, String> map = new HashMap<String, String>();
        map.put("fileId", fileId);
        map.put("fileSeq", fileSeq);

        delete("CocCommonSQL.deleteFile", map);
    }
}