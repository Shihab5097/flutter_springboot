package com.spring.common;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.servlet.ModelAndView;
import java.util.List;

public interface ICommonController {
	
//	public T save(T t);
//	public ReponseEntity<T> getById(Long id);
//	public ResponseEntity<T> update(Long id, T t):
//	public Map<String, Boolean> delet(Long id);
	
	
	public ModelAndView create();
	public ModelAndView save(HttpServletRequest request);
	public ModelAndView edit(String id);
	public ModelAndView update(HttpServletRequest request);
	public ModelAndView delete(String id);
	public ModelAndView getAll();
}
