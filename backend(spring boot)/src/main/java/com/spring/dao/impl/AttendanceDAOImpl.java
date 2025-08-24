package com.spring.dao.impl;

import com.spring.dao.AttendanceDAO;
import com.spring.model.Attendance;
import org.springframework.stereotype.Repository;

import javax.persistence.*;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class AttendanceDAOImpl implements AttendanceDAO {
    @PersistenceContext
    private EntityManager em;

    @Override
    public void saveAll(List<Attendance> records) {
        for (Attendance r : records) {
            if (r.getAttendanceId() == null) {
                // ???? ???????
                em.persist(r);
            } else {
                // ??? ???? ??? ? update present flag
                Attendance a = em.find(Attendance.class, r.getAttendanceId());
                if (a != null) {
                    a.setPresent(r.isPresent());
                    em.merge(a);
                }
            }
        }
    }

    @Override
    public List<Attendance> findByCourse(Long courseId) {
        return em.createQuery(
            "SELECT a FROM Attendance a WHERE a.courseId = :cid", Attendance.class)
          .setParameter("cid", courseId)
          .getResultList();
    }
}
