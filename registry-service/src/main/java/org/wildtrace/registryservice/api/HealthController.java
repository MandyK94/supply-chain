package org.wildtrace.registryservice.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
  @GetMapping("/api/ping")
  public ResponseEntity<String> ping() {
    return ResponseEntity.ok("registry-service: pong");
  }
}
