package egovframework.api.ktnet.web;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.api.ktnet.service.KtnetService;
import egovframework.api.ktnet.vo.DocInfoVO;
import egovframework.api.ktnet.vo.DocListVO;
import egovframework.common.util.PropertyUtil;
import egovframework.common.util.StringUtil;

@Controller
public class KtnetController {
	private static final Logger LOGGER = LoggerFactory.getLogger(KtnetController.class);

	/** KtnetService */
	@Autowired
	private KtnetService ktnetService;

	@RequestMapping(value = "/api/ktnet/searchElecDocApi.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> searchElecDocApi(@RequestBody Map<String, String> data) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			String busiRegNo = StringUtil.nullCheck(data.get("busiRegNo"));
			String startDt = StringUtil.nullCheck(data.get("startDt"));

			if (StringUtil.isNotEmpty(startDt)) {
				startDt = "20220707";
			}

			Map<String, String> map1 = new HashMap<String, String>();
			map1.put("busiRegNo", busiRegNo);
			map1.put("startDt", startDt);

			String jsonList = ktnetService.searchElecDocList(map1);

			JSONParser parser = new JSONParser();
			JSONObject jsonListObject = (JSONObject)parser.parse(jsonList);

			JSONArray jsonArray = (JSONArray)jsonListObject.get("elecDocList");

			long localAmt1 = 0;
			long localAmt2 = 0;
			long localAmt3 = 0;

			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject objectInArray = (JSONObject)jsonArray.get(i);

				Map<String, String> map2 = new HashMap<String, String>();
				map2.put("busiRegNo", (String)objectInArray.get("busiRegNo"));
				map2.put("issueNo", (String)objectInArray.get("issueNo"));

				Map<String, Object> amtMap = ktnetService.searchElecDocInfo(map2);

				try {
					if (amtMap.get("local_amt1") != null && !"0".equals(amtMap.get("local_amt1"))) {
						localAmt1 = Long.parseLong(String.format("%.0f", amtMap.get("local_amt1")));

						result.put("local_amt1", localAmt1);
					}
				} catch (Exception ex) {
					if (amtMap.get("local_amt1") != null && !"0".equals(amtMap.get("local_amt1"))) {
						localAmt1 = (long)amtMap.get("local_amt1");

						result.put("local_amt1", localAmt1);
					}
				}

				try {
					if (amtMap.get("local_amt2") != null && !"0".equals(amtMap.get("local_amt2"))) {
						localAmt2 = Long.parseLong(String.format("%.0f", amtMap.get("local_amt2")));

						result.put("local_amt2", localAmt2);
					}
				} catch (Exception ex){
					if (amtMap.get("local_amt2") != null && !"0".equals(amtMap.get("local_amt2"))) {
						localAmt2 = (long)amtMap.get("local_amt2");

						result.put("local_amt2", localAmt2);
					}
				}

				try {
					if (amtMap.get("local_amt3") != null && !"0".equals(amtMap.get("local_amt3"))) {
						localAmt3 = Long.parseLong(String.format("%.0f", amtMap.get("local_amt3")));

						result.put("local_amt3", localAmt3);
					}
				} catch(Exception ex){
					if (amtMap.get("local_amt3") != null && !"0".equals(amtMap.get("local_amt3"))) {
						localAmt3 = (long)amtMap.get("local_amt3");

						result.put("local_amt3", localAmt3);
					}
				}
            }
		} catch(Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	@RequestMapping(value = "/api/ktnet/searchElecDocList.do", method = RequestMethod.POST)
	@ResponseBody
	public String searchElecDocList(@RequestBody Map<String, String> data) {
		String jsonResult = "";

		try {
			String API_URL = PropertyUtil.getProperty("ktnet.api.host");
			String API_KEY = PropertyUtil.getProperty("ktnet.api.client.secret");

			String busiRegNo = StringUtil.nullCheck(data.get("busiRegNo"));
			String startDt = StringUtil.nullCheck(data.get("startDt"));
			String endDt = StringUtil.nullCheck(data.get("endDt"));

			if (StringUtil.isEmpty(endDt)) {
				endDt = "20221030";
			}

			String apiURL = API_URL + "/searchElecDocList";

			DocListVO docVO = new DocListVO();
			docVO.setDocType("APPCRT");
			docVO.setOrgCd("B410033");
			docVO.setIssueStartDt(startDt);
			docVO.setIssueEndDt(endDt);
			docVO.setBusiRegNo(busiRegNo);

			ObjectMapper mapper = new ObjectMapper();
			String body = mapper.writeValueAsString(docVO);

            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("apikey", API_KEY);
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.write(body.getBytes("utf-8"));
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;

            // 정상 호출
            if (responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            // 에러 발생
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }

            String inputLine;
            StringBuffer responseData = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
            	responseData.append(inputLine);
            }

            br.close();

            jsonResult = responseData.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return jsonResult;
	}

	@RequestMapping(value = "/api/ktnet/searchElecDocInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public String searchElecDocInfo(@RequestBody Map<String, String> data) {
		String jsonResult = "";

		try {
			String API_URL = PropertyUtil.getProperty("ktnet.api.host");
			String API_KEY = PropertyUtil.getProperty("ktnet.api.client.secret");

			String busiRegNo = StringUtil.nullCheck(data.get("busiRegNo"));
			String issueNo = StringUtil.nullCheck(data.get("issueNo"));
			String endDt = StringUtil.nullCheck(data.get("endDt"));

			if (StringUtil.isEmpty(endDt)) {
				endDt = "20221030";
			}

			String apiURL = API_URL + "/searchElecDocInfo";

			DocInfoVO docVO = new DocInfoVO();
			docVO.setDocType("APPCRT");
			docVO.setOrgCd("B410033");
			docVO.setBusiRegNo(busiRegNo);
			docVO.setIssueNo(issueNo);

			ObjectMapper mapper = new ObjectMapper();
			String body = mapper.writeValueAsString(docVO);

            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("apikey", API_KEY);
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.write(body.getBytes("utf-8"));
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;

            // 정상 호출
            if (responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            // 에러 발생
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }

            String inputLine;
            StringBuffer responseData = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
            	responseData.append(inputLine);
            }

            br.close();

            jsonResult = responseData.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return jsonResult;
	}
}