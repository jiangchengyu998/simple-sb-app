package com.example.simplesbapp;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@Slf4j
public class SimpleSbAppApplication {

    public static void main(String[] args) {
        SpringApplication.run(SimpleSbAppApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello(){
        log.info("I'm healthy!!!");
        return "hello springboot!";
    }


}
