package egovframework.common.auth.service;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;

public class SessionVO implements Serializable{
	private static final long serialVersionUID = 2289848623541089729L;

	@JsonProperty("seqNo") 
	@JsonSerialize(using = ToStringSerializer.class)
	private int seqNo;
	
	@JsonProperty("userId") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String userId;
	
	@JsonProperty("userNm") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String userNm;
	
	@JsonProperty("source") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String source;
		
	@JsonProperty("clientIp") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String clientIp;
	
	@JsonProperty("authIp") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String authIp;
	
	@JsonProperty("intgrtCnvrsYn") 
	@JsonSerialize(using = ToStringSerializer.class)
	private String intgrtCnvrsYn;

	public int getSeqNo() {
		return seqNo;
	}

	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getAuthIp() {
		return authIp;
	}

	public void setAuthIp(String authIp) {
		this.authIp = authIp;
	}

	public String getIntgrtCnvrsYn() {
		return intgrtCnvrsYn;
	}

	public void setIntgrtCnvrsYn(String intgrtCnvrsYn) {
		this.intgrtCnvrsYn = intgrtCnvrsYn;
	}
}