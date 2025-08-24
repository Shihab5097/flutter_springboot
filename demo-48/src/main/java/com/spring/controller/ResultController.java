package com.spring.controller;

import com.spring.dao.ResultDAO;
import com.spring.model.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/results")
@CrossOrigin(origins="*")
public class ResultController {
    @Autowired private ResultDAO dao;

    @PostMapping("/bulk")
    public void saveBulk(@RequestBody List<Result> list) {
        dao.saveAll(list);
    }

    @GetMapping("/by-params/{deptId}/{semId}/{courseId}")
    public List<Result> byParams(@PathVariable Long deptId,
                                 @PathVariable Long semId,
                                 @PathVariable Long courseId) {
        return dao.findByParams(deptId, semId, courseId);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        dao.delete(id);
    }
}
