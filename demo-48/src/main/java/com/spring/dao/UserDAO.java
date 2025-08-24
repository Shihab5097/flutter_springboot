package com.spring.dao;
import com.spring.model.User;
import java.util.List;

public interface UserDAO {
  User addUser(User u);
  User updateUser(Long id, User u);
  boolean deleteUser(Long id);
  List<User> getAllUsers();
  User getById(Long id);
  User findByUsernameAndPassword(String username, String password);
}
