package com.spring.controller;

import com.spring.dao.UserDAO;
import com.spring.model.User;           // ? ????? add ????
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@CrossOrigin("*")
public class LoginController {

    @Autowired
    private UserDAO userDAO;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User creds) {
        // ??? creds.getUsername() ???? ???? User ????? ????? getter
        User u = userDAO.findByUsernameAndPassword(creds.getUsername(), creds.getPassword());
        if (u != null) {
            return ResponseEntity.ok(u);
        } else {
            return ResponseEntity
                     .status(HttpStatus.UNAUTHORIZED)
                     .body("Invalid username or password");
        }
    }
}
