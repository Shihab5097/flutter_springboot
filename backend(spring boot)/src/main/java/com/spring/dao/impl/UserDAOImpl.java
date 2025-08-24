// src/main/java/com/spring/dao/impl/UserDAOImpl.java
package com.spring.dao.impl;
import com.spring.dao.UserDAO;
import com.spring.model.User;
import org.springframework.stereotype.Repository;
import javax.persistence.*;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class UserDAOImpl implements UserDAO {
  @PersistenceContext private EntityManager em;

  @Override public User addUser(User u){ em.persist(u); return u; }
  @Override public User updateUser(Long id, User u){ u.setId(id); return em.merge(u); }
  @Override public boolean deleteUser(Long id){
    User u = em.find(User.class, id);
    if(u!=null){ em.remove(u); return true; } return false;
  }
  @Override public List<User> getAllUsers(){
    return em.createQuery("FROM User", User.class).getResultList(); }
  @Override public User getById(Long id){ return em.find(User.class, id); }
  @Override public User findByUsernameAndPassword(String username,String password){
    try {
      return em.createQuery(
        "FROM User u WHERE u.username=:uname AND u.password=:pwd", User.class)
        .setParameter("uname", username)
        .setParameter("pwd", password)
        .getSingleResult();
    } catch(NoResultException e) { return null; }
  }
}
