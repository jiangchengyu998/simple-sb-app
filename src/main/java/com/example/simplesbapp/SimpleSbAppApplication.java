package com.example.simplesbapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SimpleSbAppApplication {

    public static void main(String[] args) {
        SpringApplication.run(SimpleSbAppApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello(){
        return "hello springboot!";
    }

    

    @GetMapping("/")
    public String hello(){
        return "hello springboot!";
    }

}
