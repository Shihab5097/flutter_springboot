package com.spring.boot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@ComponentScan(basePackages = "com.spring")
@EntityScan( basePackages = {"com.spring"} )
@EnableJpaRepositories("com.spring.dao.impl")
public class Demo48Application extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplication.run(Demo48Application.class, args);
	}

}
